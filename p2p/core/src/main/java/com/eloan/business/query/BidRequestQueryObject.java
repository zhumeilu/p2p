package com.eloan.business.query;

import lombok.Getter;
import lombok.Setter;

/**
 * 借款查询对象
 *
 */
@Getter
@Setter
public class BidRequestQueryObject extends BaseAuditQueryObject {
	
	/**
	 * 可以按照多个状态查询
	 */
	private int[] states;
	private String orderType="DESC,id ASC";
	private String orderBy="publishTime";
	
	private Long createUserId;
	
	
}
