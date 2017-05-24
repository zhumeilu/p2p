package com.eloan.business.service.impl;

import java.math.BigDecimal;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eloan.business.domain.Account;
import com.eloan.business.domain.AccountFlow;
import com.eloan.business.domain.Bid;
import com.eloan.business.domain.BidRequest;
import com.eloan.business.domain.RechargeOffline;
import com.eloan.business.mapper.AccountFlowMapper;
import com.eloan.business.service.IAccountFlowService;
import com.eloan.business.util.BidConst;

@Service
public class AccountFlowServiceImpl implements IAccountFlowService {

	@Autowired
	private AccountFlowMapper accountFlowMapper;

	private AccountFlow createBaseFlow(Account account) {
		AccountFlow flow = new AccountFlow();
		flow.setAccount(account);
		flow.setActionTime(new Date());
		flow.setBalance(account.getUsableAmount());
		flow.setFreezed(account.getFreezedAmount());
		return flow;
	}

	@Override
	public void addRechargeFlow(RechargeOffline recharge, Account account) {
		AccountFlow flow = createBaseFlow(account);
		flow.setAccountActionType(BidConst.ACCOUNT_ACTIONTYPE_DEPOSIT_OFFLINE_LOCAL);
		flow.setAmount(recharge.getAmount());
		flow.setNote("线下充值成功!");
		accountFlowMapper.insert(flow);
	}

	@Override
	public void addBidFlow(Bid bid, Account account) {
		AccountFlow flow = createBaseFlow(account);
		flow.setAccountActionType(BidConst.ACCOUNT_ACTIONTYPE_BID_FREEZED);
		flow.setAmount(bid.getAvailableAmount());
		flow.setNote("投标:" + bid.getBidRequestTitle() + ",冻结金额!");
		accountFlowMapper.insert(flow);
	}

	@Override
	public void addReturnBidMoneyFlow(Bid bid, Account bidAccount) {
		AccountFlow flow = createBaseFlow(bidAccount);
		flow.setAccountActionType(BidConst.ACCOUNT_ACTIONTYPE_BID_UNFREEZED);
		flow.setAmount(bid.getAvailableAmount());
		flow.setNote("投标取消,投标冻结金额返还!");
		accountFlowMapper.insert(flow);
	}

	@Override
	public void addBorrowRecevieFlow(BidRequest bidRequest,
			Account borrowAccount) {
		AccountFlow flow = createBaseFlow(borrowAccount);
		flow.setAccountActionType(BidConst.ACCOUNT_ACTIONTYPE_BIDREQUEST_SUCCESSFUL);
		flow.setAmount(bidRequest.getBidRequestAmount());
		flow.setNote("成功借款,借款金额到账!");
		accountFlowMapper.insert(flow);
	}

	@Override
	public void addManageChargeFeeFlow(BigDecimal manageChargeFee,
			Account borrowAccount) {
		AccountFlow flow = createBaseFlow(borrowAccount);
		flow.setAccountActionType(BidConst.ACCOUNT_ACTIONTYPE_CHARGE);
		flow.setAmount(manageChargeFee);
		flow.setNote("支付借款手续费!");
		accountFlowMapper.insert(flow);
	}

	@Override
	public void addBidSuccessFlow(Bid bid, Account bidAccount) {
		AccountFlow flow = createBaseFlow(bidAccount);
		flow.setAccountActionType(BidConst.ACCOUNT_ACTIONTYPE_BID_SUCCESSFUL);
		flow.setAmount(bid.getAvailableAmount());
		flow.setNote("借款成功取消冻结金额!");
		accountFlowMapper.insert(flow);
	}
	
	

}
