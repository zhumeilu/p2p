package com.eloan.business.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;

import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eloan.base.domain.Logininfo;
import com.eloan.base.query.PageResult;
import com.eloan.base.util.UserContext;
import com.eloan.business.domain.Account;
import com.eloan.business.domain.Bid;
import com.eloan.business.domain.BidRequest;
import com.eloan.business.domain.BidRequestAuditHistory;
import com.eloan.business.domain.PaymentSchedule;
import com.eloan.business.domain.PaymentScheduleDetail;
import com.eloan.business.domain.Userinfo;
import com.eloan.business.mapper.BidMapper;
import com.eloan.business.mapper.BidRequestAuditHistoryMapper;
import com.eloan.business.mapper.BidRequestMapper;
import com.eloan.business.mapper.PaymentScheduleDetailMapper;
import com.eloan.business.mapper.PaymentScheduleMapper;
import com.eloan.business.query.BidQueryObject;
import com.eloan.business.query.BidRequestQueryObject;
import com.eloan.business.service.IAccountFlowService;
import com.eloan.business.service.IAccountService;
import com.eloan.business.service.IBidRequestService;
import com.eloan.business.service.ISystemAccountService;
import com.eloan.business.service.IUserService;
import com.eloan.business.util.BidConst;
import com.eloan.business.util.BitStatesUtils;
import com.eloan.business.util.CalculatetUtil;
import com.eloan.business.util.DecimalFormatUtil;

@Service
public class BidRequestServiceImpl implements IBidRequestService {

	@Autowired
	private BidRequestMapper bidRequestMapper;

	@Autowired
	private IUserService userService;

	@Autowired
	private IAccountService accountService;

	@Autowired
	private BidRequestAuditHistoryMapper bidRequestAuditHistoryMapper;

	@Autowired
	private BidMapper bidMapper;

	@Autowired
	private IAccountFlowService accountFlowService;
	
	@Autowired
	private PaymentScheduleMapper paymentScheduleMapper;
	
	@Autowired
	private PaymentScheduleDetailMapper paymentScheduleDetailMapper;
	
	@Autowired
	private ISystemAccountService systemAccountService;

	@Override
	public BidRequest get(Long id) {
		return this.bidRequestMapper.selectByPrimaryKey(id);
	}

	@Override
	public List<BidRequest> listIndexBidRequests(int size) {
		BidRequestQueryObject qo = new BidRequestQueryObject();
		qo.setStates(new int[] { BidConst.BIDREQUEST_STATE_BIDDING,
				BidConst.BIDREQUEST_STATE_PAYING_BACK,
				BidConst.BIDREQUEST_STATE_COMPLETE_PAY_BACK });
		qo.setPageSize(size);
		qo.setOrderBy("bidRequestState");
		qo.setOrderType("ASC");
		return this.bidRequestMapper.query(qo);
	}

	@Override
	public void update(BidRequest br) {
		int ret = bidRequestMapper.updateByPrimaryKey(br);
		if (ret <= 0) {
			throw new RuntimeException("借款对象乐观锁失败:" + br.getId());
		}
	}

	@Override
	public void bid(BigDecimal amount, Long bidRequestId) {
		//检查标的状态;
		BidRequest bidRequest = this.bidRequestMapper
				.selectByPrimaryKey(bidRequestId);
		if (bidRequest != null
				&& bidRequest.getBidRequestState() == BidConst.BIDREQUEST_STATE_BIDDING) {
			//检查这次投标是否合法;
			Account account = this.accountService.get(UserContext.getCurrent()
					.getId());
			if (account.getUsableAmount().compareTo(amount) >= 0
					&& amount.compareTo(bidRequest.getRemainAmount()) <= 0
					&& amount.compareTo(bidRequest.getMinBidAmount()) >= 0
					&& !account.getId().equals(
							bidRequest.getCreateUser().getId())) {
				//1,创建一个Bid对象;
				Bid bid = new Bid();
				bid.setActualRate(bidRequest.getCurrentRate());
				bid.setAvailableAmount(amount);
				bid.setBidRequestId(bidRequestId);
				bid.setBidRequestTitle(bidRequest.getTitle());
				bid.setBidTime(new Date());
				bid.setBidUser(UserContext.getCurrent());
				this.bidMapper.insert(bid);

				//2,修改标的信息;
				bidRequest.setBidCount(bidRequest.getBidCount() + 1);
				bidRequest
						.setCurrentSum(bidRequest.getCurrentSum().add(amount));

				//3,修改投标人账户相关信息
				account.addUseableAmount(amount.negate());
				account.addFreezedAmount(amount);
				this.accountService.update(account);
				//生成投标流水;
				accountFlowService.addBidFlow(bid, account);
				//4,判断是否进入满标一审状态;
				if (bidRequest.getCurrentSum().equals(
						bidRequest.getBidRequestAmount())) {
					bidRequest
							.setBidRequestState(BidConst.BIDREQUEST_STATE_APPROVE_PENDING_1);
				}
				this.update(bidRequest);
			}
		}
	}

	@Override
	public boolean canBorrow(Logininfo li) {
		Userinfo current = this.userService.get(li.getId());
		Account account = this.accountService.get(li.getId());

		return !current.getHasBidRequest()//没有标在过程当中
				&& current.getRealAuth()//通过实名认证
				&& current.getBaseInfo()//填写基本资料
				&& current.getVedioAuth()//通过视频认证
				&& current.getAuthScore() >= BidConst.CREDIT_BORROW_SCORE//用户风控分数大于要求分数
				&& account.getRemainBorrowLimit().compareTo(
						BidConst.SMALLEST_BIDREQUEST_AMOUNT) >= 0;//用户剩余额度>系统最小发标金额
	}

	@Override
	public void apply(BidRequest bidRequest) {
		Logininfo current = UserContext.getCurrent();
		Account account = this.accountService.get(current.getId());
		//再次检查当前用户是否能够发标
		if (canBorrow(current)
				&& bidRequest.getBidRequestAmount().compareTo(
						account.getRemainBorrowLimit()) <= 0) {
			bidRequest.setBidRequestType(BidConst.BIDREQUEST_TYPE_NORMAL);
			bidRequest
					.setBidRequestState(BidConst.BIDREQUEST_STATE_PUBLISH_PENDING);
			bidRequest
					.setTotalRewardAmount(CalculatetUtil.calTotalInterest(
							bidRequest.getReturnType(),
							bidRequest.getBidRequestAmount(),
							bidRequest.getCurrentRate(),
							bidRequest.getMonthes2Return()));
			bidRequest.setCreateUser(current);
			bidRequest.setApplyTime(new Date());

			this.bidRequestMapper.insert(bidRequest);
			Userinfo userinfo = this.userService.get(current.getId());
			userinfo.addState(BitStatesUtils.OP_HAS_BIDRQUEST);
			this.userService.update(userinfo);
		}
	}

	@Override
	public PageResult query(BidRequestQueryObject qo) {
		int count = this.bidRequestMapper.queryForCount(qo);
		if (count > 0) {
			List<BidRequest> list = this.bidRequestMapper.query(qo);
			return new PageResult(count, qo.getPageSize(), qo.getCurrentPage(),
					list);
		}
		return PageResult.empty(qo.getPageSize());
	}

	@Override
	public PageResult queryBid(BidQueryObject qo) {
		int count = this.bidMapper.queryForCount(qo);
		if (count > 0) {
			List<Bid> list = this.bidMapper.query(qo);
			return new PageResult(count, qo.getPageSize(), qo.getCurrentPage(),
					list);
		}
		return PageResult.empty(qo.getPageSize());
	}

	@Override
	public void publishAudit(Long id, String remark, int state) {
		BidRequest bidRequest = this.bidRequestMapper.selectByPrimaryKey(id);
		if (bidRequest != null
				&& bidRequest.getBidRequestState() == BidConst.BIDREQUEST_STATE_PUBLISH_PENDING) {
			Date now = new Date();

			BidRequestAuditHistory history = new BidRequestAuditHistory();
			history.setApplier(bidRequest.getCreateUser());
			history.setApplyTime(bidRequest.getApplyTime());
			history.setAuditor(UserContext.getCurrent());
			history.setAuditTime(now);
			history.setRemark(remark);
			history.setState(state);
			history.setBidRequestId(id);
			history.setAuditType(BidRequestAuditHistory.AUDITTYPE_PUBLISH_BIDREQUEST);
			this.bidRequestAuditHistoryMapper.insert(history);

			//处理标相关信息
			if (state == BidRequestAuditHistory.STATE_REJECT) {
				bidRequest
						.setBidRequestState(BidConst.BIDREQUEST_STATE_PUBLISH_REFUSE);
				Userinfo createUser = this.userService.get(bidRequest
						.getCreateUser().getId());
				createUser.removeState(BitStatesUtils.OP_HAS_BIDRQUEST);
				this.userService.update(createUser);
			} else if (state == BidRequestAuditHistory.STATE_PASS) {
				bidRequest
						.setBidRequestState(BidConst.BIDREQUEST_STATE_BIDDING);
				bidRequest.setNote(remark);
				bidRequest.setDisableDate(DateUtils.addDays(now,
						bidRequest.getDisableDays()));
				bidRequest.setPublishTime(now);
			}
			this.update(bidRequest);
		}
	}

	@Getter
	@Setter
	public class EntryValue<K, T> {
		private K key;
		private T value;

		public EntryValue(K key, T value) {
			this.key = key;
			this.value = value;
		}
	}

	@Override
	public List<EntryValue<Integer, String>> listBidRequestStates() {
		List<EntryValue<Integer, String>> states = new ArrayList<>();
		states.add(new EntryValue<>(0, "待发布"));
		states.add(new EntryValue<>(1, "招标中"));
		states.add(new EntryValue<>(2, "已撤销"));
		states.add(new EntryValue<>(3, "流标"));
		states.add(new EntryValue<>(4, "满标1审"));
		states.add(new EntryValue<>(5, "满标2审"));
		states.add(new EntryValue<>(6, "满标审核拒绝"));
		states.add(new EntryValue<>(7, "还款中"));
		states.add(new EntryValue<>(8, "已还清"));
		states.add(new EntryValue<>(9, "逾期"));
		states.add(new EntryValue<>(10, "发标审核拒绝"));
		return states;
	}

	@Override
	public void audit1(Long id, String remark, int state) {
		//检查状态
		BidRequest bidRequest = this.bidRequestMapper.selectByPrimaryKey(id);
		if (bidRequest.getBidRequestState() == BidConst.BIDREQUEST_STATE_APPROVE_PENDING_1) {
			//创建标的审核历史对象;
			BidRequestAuditHistory history = new BidRequestAuditHistory();
			history.setApplier(bidRequest.getCreateUser());
			history.setApplyTime(bidRequest.getApplyTime());
			history.setAuditor(UserContext.getCurrent());
			history.setAuditTime(new Date());
			history.setRemark(remark);
			history.setState(state);
			history.setBidRequestId(id);
			history.setAuditType(BidRequestAuditHistory.AUDITTYPE_FULL_AUDIT1);
			this.bidRequestAuditHistoryMapper.insert(history);

			//审核通过:直接修改标的状态为满标二审
			if (state == BidRequestAuditHistory.STATE_PASS) {
				bidRequest
						.setBidRequestState(BidConst.BIDREQUEST_STATE_APPROVE_PENDING_2);
			} else {
				//审核失败?
				//1,修改标的状态;
				bidRequest
						.setBidRequestState(BidConst.BIDREQUEST_STATE_REJECTED);
				//2,返还每一个投资者的投标款;
				returnMoney(bidRequest);
				//3,修改借款人正在借款状态
				Userinfo userinfo = this.userService.get(bidRequest
						.getCreateUser().getId());
				userinfo.removeState(BitStatesUtils.OP_HAS_BIDRQUEST);
				this.userService.update(userinfo);
			}
			this.update(bidRequest);
		}
	}

	/**
	 * 当满标一审拒绝,满标二审拒绝,流标和取消借款,都要把标的的投标人的钱返回
	 * @param bidRequest
	 */
	private void returnMoney(BidRequest bidRequest) {
		Map<Long, Account> updateAccounts = new HashMap<>();
		//遍历投标;
		for (Bid bid : bidRequest.getBids()) {
			//得到投标人;
			Long bidUserId = bid.getBidUser().getId();
			Account bidAccount = updateAccounts.get(bidUserId);
			if (bidAccount == null) {
				bidAccount = this.accountService.get(bidUserId);
				updateAccounts.put(bidUserId, bidAccount);
			}
			//修改投资人的账户信息;
			bidAccount.addUseableAmount(bid.getAvailableAmount());
			bidAccount.addFreezedAmount(bid.getAvailableAmount().negate());
			//生成投标退款的流水
			this.accountFlowService.addReturnBidMoneyFlow(bid, bidAccount);
		}
		for (Account account : updateAccounts.values()) {
			//修改账户
			this.accountService.update(account);
		}
	}

	@Override
	public void audit2(Long id, String remark, int state) {
		//检查状态
		BidRequest bidRequest = this.bidRequestMapper.selectByPrimaryKey(id);
		if (bidRequest.getBidRequestState() == BidConst.BIDREQUEST_STATE_APPROVE_PENDING_2) {
			//创建标的审核历史对象;
			BidRequestAuditHistory history = new BidRequestAuditHistory();
			history.setApplier(bidRequest.getCreateUser());
			history.setApplyTime(bidRequest.getApplyTime());
			history.setAuditor(UserContext.getCurrent());
			history.setAuditTime(new Date());
			history.setRemark(remark);
			history.setState(state);
			history.setBidRequestId(id);
			history.setAuditType(BidRequestAuditHistory.AUDITTYPE_FULL_AUDIT2);
			this.bidRequestAuditHistoryMapper.insert(history);

			//审核通过:直接修改标的状态为满标二审
			if (state == BidRequestAuditHistory.STATE_REJECT) {
				//审核失败?
				//1,修改标的状态;
				bidRequest.setBidRequestState(BidConst.BIDREQUEST_STATE_REJECTED);
				//2,返还每一个投资者的投标款;
				returnMoney(bidRequest);
				//3,修改借款人正在借款状态
				Userinfo userinfo = this.userService.get(bidRequest.getCreateUser().getId());
				userinfo.removeState(BitStatesUtils.OP_HAS_BIDRQUEST);
				this.userService.update(userinfo);
			} else {
				//审核通过
				//1,对于借款来说
				//1.1,借款状态修改;
				bidRequest.setBidRequestState(BidConst.BIDREQUEST_STATE_PAYING_BACK);
				//1.2,根据借款生成还款计划对应的回款计划
				List<PaymentSchedule> pss=createPaymentScheduleFromBidRequest(bidRequest);
				//2,对于借款人来说
				Map<Long,Account> updateAccounts=new HashMap<>();
				//2.1,借款人借款到账,生成借款到账流水;
				Account borrowAccount=this.accountService.get(bidRequest.getCreateUser().getId());
				updateAccounts.put(borrowAccount.getId(), borrowAccount);
				borrowAccount.addUseableAmount(bidRequest.getBidRequestAmount());
				//生成借款到账流水
				this.accountFlowService.addBorrowRecevieFlow(bidRequest,borrowAccount);
				
				//2.2,借款人支付借款手续费,;
				BigDecimal manageChargeFee=CalculatetUtil.calAccountManagementCharge(bidRequest.getBidRequestAmount());
				borrowAccount.addUseableAmount(manageChargeFee.negate());
				//生成支付手续费流水
				this.accountFlowService.addManageChargeFeeFlow(manageChargeFee,borrowAccount);
				
				//2.3,增加账户待还金额,账户剩余授信额度;
				borrowAccount.setUnReturnAmount(borrowAccount.getUnReturnAmount().add(bidRequest.getBidRequestAmount()).add(bidRequest.getTotalRewardAmount()));
				borrowAccount.setRemainBorrowLimit(borrowAccount.getRemainBorrowLimit().subtract(bidRequest.getBidRequestAmount()));
				//2.4,修改借款人正在借款状态
				Userinfo borrowUser=this.userService.get(bidRequest.getCreateUser().getId());
				borrowUser.removeState(BitStatesUtils.OP_HAS_BIDRQUEST);
				this.userService.update(borrowUser);
				
				//3,对于投资人来说
				for(Bid bid:bidRequest.getBids()){
					Account bidAccount=updateAccounts.get(bid.getBidUser().getId());
					if(bidAccount==null){
						bidAccount=this.accountService.get(bid.getBidUser().getId());
						updateAccounts.put(bidAccount.getId(), bidAccount);
					}
					//3.1,减少冻结资金,;
					bidAccount.addFreezedAmount(bid.getAvailableAmount().negate());
					//生成投资成功流水
					this.accountFlowService.addBidSuccessFlow(bid,bidAccount);
				}
				
				//3.2,修改代收利息和代收本金;
				changeBidAccountStates(pss,updateAccounts);
				
				//4,对于系统账户来说
				//4.1,收取借款手续费,并生成系统账户的流水;
				this.systemAccountService.chargeManageFee(manageChargeFee,bidRequest);
				
				//统一修改account;
				for(Account acc:updateAccounts.values()){
					this.accountService.update(acc);
				}
			} 
			this.update(bidRequest);
		}
	}
	
	/**
	 * 修改代收利息和代收本金;
	 * @param pss
	 * @param updateAccounts
	 */
	private void changeBidAccountStates(List<PaymentSchedule> pss,
			Map<Long, Account> updateAccounts) {
		Map<Long,BigDecimal> unPrincipals=new HashMap<>();
		Map<Long,BigDecimal> unInterests=new HashMap<>();
		
		for(Long accountId:updateAccounts.keySet()){
			unPrincipals.put(accountId, BidConst.ZERO);
			unInterests.put(accountId, BidConst.ZERO);
		}
		
		for(PaymentSchedule ps:pss){
			for(PaymentScheduleDetail psd:ps.getPaymentScheduleDetails()){
				Long bidAccountId=psd.getToLoginInfo().getId();
				unPrincipals.put(bidAccountId, unPrincipals.get(bidAccountId).add(psd.getPrincipal()));
				unInterests.put(bidAccountId, unInterests.get(bidAccountId).add(psd.getInterest()));
			}
		}
		
		for(Account account:updateAccounts.values()){
			account.setUnReceiveInterest(account.getUnReceiveInterest().add(unInterests.get(account.getId())));
			account.setUnReceivePrincipal(account.getUnReceivePrincipal().add(unPrincipals.get(account.getId())));
		}
	}

	/**
	 * 根据标的对象生成分期还款计划对象
	 *
	 * @param bidRequest
	 * @return
	 */
	private List<PaymentSchedule> createPaymentScheduleFromBidRequest(BidRequest bidRequest) {
		List<PaymentSchedule> paymentSchedules = new ArrayList<PaymentSchedule>();
		// 还款进度(分几期创建几个进度)
		int count = bidRequest.getMonthes2Return();
		for (int i = 1; i <= count; i++) {
			PaymentSchedule paymentSchedule = new PaymentSchedule();
			paymentSchedule.setBidRequestId(bidRequest.getId());// 还的是哪个借款
			paymentSchedule.setBidUser(bidRequest.getCreateUser());// 还款人
			paymentSchedule.setBidRequestType(bidRequest.getBidRequestType());
			paymentSchedule.setBidRequestTitle(bidRequest.getTitle());
			// 截止期限（从审核通过开始算）
			paymentSchedule.setDeadLine(DateUtils.addMonths(new Date(), i));
			// 本期还款总金额
			paymentSchedule.setTotalAmount(CalculatetUtil.calMonthToReturnMoney(bidRequest.getReturnType(),
					bidRequest.getBidRequestAmount(), bidRequest.getCurrentRate(), i, bidRequest.getMonthes2Return()));
			// 利息
			paymentSchedule.setInterest(CalculatetUtil.calMonthlyInterest(bidRequest.getReturnType(), bidRequest.getBidRequestAmount(),
					bidRequest.getCurrentRate(), i, bidRequest.getMonthes2Return()));
			// 本金
			paymentSchedule.setPrincipal(paymentSchedule.getTotalAmount().subtract(paymentSchedule.getInterest()));
			// 第几期
			paymentSchedule.setMonthIndex(i);
			// 还款状态(默认正常待还)
			paymentSchedule.setState(BidConst.PAYMENT_STATE_NORMAL);
			// 还款方式
			paymentSchedule.setReturnType(bidRequest.getReturnType());
			// 保存还款进度
			paymentScheduleMapper.addPaymentSchedule(paymentSchedule);
			// 生成该还款计划下的还款计划明细
			this.createPaymentScheduleDetail(bidRequest, paymentSchedule);
			paymentSchedules.add(paymentSchedule);
		}
		return paymentSchedules;
	}

	/**
	 * 生成该还款计划下的还款计划明细
	 *
	 * @param bidRequest
	 * @param paymentSchedule
	 */
	private void createPaymentScheduleDetail(BidRequest bidRequest, PaymentSchedule paymentSchedule) {
		// 借款里面的所以投标记录
		List<Bid> bids = bidRequest.getBids();
		BigDecimal totalPrincipal = BidConst.ZERO;
		BigDecimal totalInterest = BidConst.ZERO;
		int index = 0;
		for (Bid bid : bids) {
			PaymentScheduleDetail detail = new PaymentScheduleDetail();
			// 设置对应还款计划id
			detail.setPaymentScheduleId(paymentSchedule.getId());
			// 还款人
			detail.setFromLoginInfo(bidRequest.getCreateUser());
			// 收款人(即投标人)
			detail.setToLoginInfo(bid.getBidUser());
			// 投标人实际投标金额
			detail.setBidAmount(bid.getAvailableAmount());
			// 对应的投标
			detail.setBidId(bid.getId());
			BigDecimal principal = BidConst.ZERO;
			BigDecimal interest = BidConst.ZERO;

			// 如果是最后一个还款明细，这个还款明细的金额应该等于该期还款的总额-前面累加的还款额，而不用再去计算
			if (index == bids.size() - 1) {
				principal = paymentSchedule.getPrincipal().subtract(totalPrincipal);
				interest = paymentSchedule.getInterest().subtract(totalInterest);
			} else {
				// 算出 所占比列 = 投标本金/借款本金
				BigDecimal proportion = bid.getAvailableAmount().divide(bidRequest.getBidRequestAmount(), BidConst.CAL_SCALE,
						RoundingMode.HALF_UP);

				// 本金 = 还款计划还款本金 * 所占比列
				principal = paymentSchedule.getPrincipal().multiply(proportion);
				totalPrincipal = totalPrincipal.add(principal);
				principal = DecimalFormatUtil.amountFormat(principal);

				// 利息 = 还款计划还款利息 * 所占比列
				interest = paymentSchedule.getInterest().multiply(proportion);
				totalInterest = totalInterest.add(interest);
				interest = DecimalFormatUtil.amountFormat(interest);
			}
			detail.setPrincipal(principal);
			detail.setInterest(interest);
			// 还款金额（本息）
			detail.setTotalAmount(detail.getPrincipal().add(detail.getInterest()));
			// 第几期
			detail.setMonthIndex(paymentSchedule.getMonthIndex());
			// 截止日期
			detail.setDeadline(paymentSchedule.getDeadLine());
			// 对应哪个借款
			detail.setBidRequestId(bidRequest.getId());
			// 还款方式
			detail.setReturnType(bidRequest.getReturnType());
			// 保存还款进度
			paymentScheduleDetailMapper.addPaymentScheduleDetail(detail);
			// 添加到还款计划对象中
			paymentSchedule.getPaymentScheduleDetails().add(detail);
			index++;
		}
	}
}
