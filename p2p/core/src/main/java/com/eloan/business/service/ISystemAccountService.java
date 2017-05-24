package com.eloan.business.service;

import java.math.BigDecimal;

import com.eloan.business.domain.BidRequest;
import com.eloan.business.domain.SystemAccount;

/**
 * 系统账户
 * @author Administrator
 *
 */
public interface ISystemAccountService {

	/**
	 * 收取借款手续费
	 * @param manageChargeFee
	 * @param bidRequest
	 */
	void chargeManageFee(BigDecimal manageChargeFee, BidRequest bidRequest);

	void update(SystemAccount current);
	
}
