package com.eloan.uiweb.controller;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.eloan.base.domain.Logininfo;
import com.eloan.base.query.PageResult;
import com.eloan.base.util.ResultJSON;
import com.eloan.base.util.UserContext;
import com.eloan.business.domain.BidRequest;
import com.eloan.business.domain.Userfile;
import com.eloan.business.domain.Userinfo;
import com.eloan.business.query.BidQueryObject;
import com.eloan.business.query.BidRequestQueryObject;
import com.eloan.business.query.UserFileQueryObject;
import com.eloan.business.service.IAccountService;
import com.eloan.business.service.IBidRequestService;
import com.eloan.business.service.IRealAuthService;
import com.eloan.business.service.IUserFileService;
import com.eloan.business.service.IUserService;
import com.eloan.business.util.BidConst;

/**
 * 借款模块
 * @author Administrator
 *
 */
@Controller
public class BorrowController extends BaseController {

	@Autowired
	private IAccountService accountService;

	@Autowired
	private IUserService userService;

	@Autowired
	private IBidRequestService bidRequestService;
	
	@Autowired
	private IUserFileService userFileService;
	
	@Autowired
	private IRealAuthService realAuthService;

	/**
	 * 我要借款
	 * @return
	 */
	@RequestMapping("/borrow")
	public String borrowIndex(Model model) {
		Logininfo current = UserContext.getCurrent();
		if (current == null) {
			return "redirect:borrow.html";
		}
		model.addAttribute("account", this.accountService.get(current.getId()));
		model.addAttribute("userinfo", this.userService.get(current.getId()));
		model.addAttribute("creditBorrowScore", BidConst.CREDIT_BORROW_SCORE);
		return "borrow";
	}

	/**
	 * 导向到借款界面
	 */
	@RequestMapping("borrowInfo")
	public String borrowInfo(Model model) {
		boolean canBidRequest = this.bidRequestService.canBorrow(UserContext
				.getCurrent());
		if (canBidRequest) {
			model.addAttribute("account",
					this.accountService.get(UserContext.getCurrent().getId()));
			model.addAttribute("minBidRequestAmount",
					BidConst.SMALLEST_BIDREQUEST_AMOUNT);
			model.addAttribute("minBidAmount", BidConst.SMALLEST_BID_AMOUNT);
			return "borrow_apply";
		} else {
			return "borrow_apply_result";
		}
	}

	/**
	 * 借款申请
	 */
	@RequestMapping("borrow_apply")
	public String borrowApply(BidRequest bidRequest) {
		this.bidRequestService.apply(bidRequest);
		return "redirect:borrowInfo.do";
	}

	/**
	 * 用于显示投资列表框架页面的方法
	 */
	@RequestMapping("invest")
	public String invest() {
		return "invest";
	}

	/**
	 * 用于显示投资列表分页内容的方法
	 */
	@RequestMapping("invest_list")
	public String investList(int bidRequestState, int currentPage, Model model) {
		BidRequestQueryObject qo = new BidRequestQueryObject();
		if (bidRequestState == -1) {
			qo.setStates(new int[] { BidConst.BIDREQUEST_STATE_BIDDING,
					BidConst.BIDREQUEST_STATE_APPROVE_PENDING_1,
					BidConst.BIDREQUEST_STATE_APPROVE_PENDING_2,
					BidConst.BIDREQUEST_STATE_PAYING_BACK,
					BidConst.BIDREQUEST_STATE_COMPLETE_PAY_BACK });
		} else {
			qo.setState(bidRequestState);
		}
		qo.setCurrentPage(currentPage);
		PageResult result = this.bidRequestService.query(qo);
		model.addAttribute("pageResult", result);
		return "invest_list";
	}
	
	@RequestMapping("borrow_info")
	public String borrowInfo(long id,Model model){
		//标相关内容
		BidRequest bidRequest=this.bidRequestService.get(id);
		Logininfo current=UserContext.getCurrent();
		//借款人
		Userinfo userinfo=this.userService.get(bidRequest.getCreateUser().getId());
		//如果是登陆用户,并且登陆用户为借款人,要加self==true;
		//如果是其他登陆用户,需要account,self==false
		//非登陆用户设置self为false;
		model.addAttribute("self",current!=null &&current.getId()==userinfo.getId());
		if(current!=null){
			model.addAttribute("account",this.accountService.get(current.getId()));
		}
		//借款人的realauth
		model.addAttribute("realAuth",this.realAuthService.get(userinfo.getRealauthId()));
		//借款人的userfiles;
		UserFileQueryObject qo=new UserFileQueryObject();
		qo.setPageSize(-1);
		qo.setState(Userfile.STATE_PASS);
		qo.setApplierId(userinfo.getId());
		model.addAttribute("userFiles",this.userFileService.queryList(qo));
		model.addAttribute("userInfo",userinfo);
		model.addAttribute("bidRequest",bidRequest);
		
		return "borrow_info";
	}
	
	/**
	 * 投标操作
	 * @param amount
	 * @param bidRequestId
	 * @return
	 */
	@RequestMapping("borrow_bid")
	@ResponseBody
	public ResultJSON borrowBid(BigDecimal amount,Long bidRequestId){
		ResultJSON json=new ResultJSON();
		try{
			this.bidRequestService.bid(amount,bidRequestId);
			json.setSuccess(true);
		}catch(Exception e){
			json.setMsg(e.getMessage());
		}
		return json;
	}
	
	/**
	 * 个人中心-借款明细
	 */
	@RequestMapping("myborrow_list")
	public String myBorrowList(@ModelAttribute("qo")BidRequestQueryObject qo,Model model){
		qo.setCreateUserId(UserContext.getCurrent().getId());
		model.addAttribute("pageResult",this.bidRequestService.query(qo));
		model.addAttribute("bidRequestStates",this.bidRequestService.listBidRequestStates());
		return "bidRequest_list";
	}
	
	/**
	 * 个人中心-投资明细
	 */
	@RequestMapping("bid_list")
	public String bidList(@ModelAttribute("qo")BidQueryObject qo,Model model){
		qo.setBidUserId(UserContext.getCurrent().getId());
		model.addAttribute("pageResult",this.bidRequestService.queryBid(qo));
		model.addAttribute("bidRequestStates",this.bidRequestService.listBidRequestStates());
		return "bid_list";
	}
}
