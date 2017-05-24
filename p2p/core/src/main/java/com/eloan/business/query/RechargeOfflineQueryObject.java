package com.eloan.business.query;

import org.springframework.util.StringUtils;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RechargeOfflineQueryObject extends BaseAuditQueryObject {

	private Long applierId;//申请人
	private long bankInfoId = -1;//开户行
	private String tradeCode;//交易号

	public String getTradeCode(){
		return StringUtils.hasLength(tradeCode)?tradeCode:null;
	}
}
