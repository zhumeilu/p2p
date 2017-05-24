package com.eloan.business.service;

import java.math.BigDecimal;

import com.eloan.business.domain.Account;
import com.eloan.business.domain.Bid;
import com.eloan.business.domain.BidRequest;
import com.eloan.business.domain.RechargeOffline;

public interface IAccountFlowService {

	/**
	 * 添加线下充值流水
	 * @param recharge
	 * @param account
	 */
	void addRechargeFlow(RechargeOffline recharge, Account account);

	/**
	 * 添加投标流水
	 * @param bid
	 * @param account
	 */
	void addBidFlow(Bid bid, Account account);

	/**
	 * 生成投标退款的流水
	 * @param bid
	 * @param bidAccount
	 */
	void addReturnBidMoneyFlow(Bid bid, Account bidAccount);

	/**
	 * 生成借款到账流水
	 * @param bidRequest
	 * @param borrowAccount
	 */
	void addBorrowRecevieFlow(BidRequest bidRequest, Account borrowAccount);

	/**
	 * 支付借款手续费流水
	 * @param manageChargeFee
	 * @param borrowAccount
	 */
	void addManageChargeFeeFlow(BigDecimal manageChargeFee,
			Account borrowAccount);

	/**
	 * 生成成功投资流水
	 * @param bid
	 * @param bidAccount
	 */
	void addBidSuccessFlow(Bid bid, Account bidAccount);

}
