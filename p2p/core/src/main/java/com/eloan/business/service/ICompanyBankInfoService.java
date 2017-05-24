package com.eloan.business.service;

import java.util.List;

import com.eloan.base.query.PageResult;
import com.eloan.base.query.QueryObject;
import com.eloan.business.domain.CompanyBankInfo;

public interface ICompanyBankInfoService {
	
	List<CompanyBankInfo> list();

	PageResult query(QueryObject qo);
	
	void save(CompanyBankInfo c);
}
