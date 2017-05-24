package com.eloan.uiweb.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.eloan.base.util.ResultJSON;
import com.eloan.base.util.UserContext;
import com.eloan.business.domain.RechargeOffline;
import com.eloan.business.query.RechargeOfflineQueryObject;
import com.eloan.business.service.ICompanyBankInfoService;
import com.eloan.business.service.IRechargeOfflineService;

@Controller
public class RechargeOfflineController extends BaseController {

	@Autowired
	private ICompanyBankInfoService companyBankInfoService;

	@Autowired
	private IRechargeOfflineService rechargeOfflineService;

	@RequestMapping("rechargeOffline")
	public String rechargeOffline(Model model) {
		model.addAttribute("banks", this.companyBankInfoService.list());
		return "recharge";
	}

	@RequestMapping("recharge_save")
	@ResponseBody
	public ResultJSON rechargeApply(RechargeOffline recharge) {
		ResultJSON json = new ResultJSON();
		this.rechargeOfflineService.apply(recharge);
		json.setSuccess(true);
		return json;
	}
	
	@RequestMapping("recharge_list")
	public String rechargeList(@ModelAttribute("qo")RechargeOfflineQueryObject qo,Model model){
		qo.setApplierId(UserContext.getCurrent().getId());
		model.addAttribute("pageResult",this.rechargeOfflineService.query(qo));
		return "recharge_list";
	}
}
