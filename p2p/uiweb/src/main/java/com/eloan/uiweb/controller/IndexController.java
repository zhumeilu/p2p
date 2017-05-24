package com.eloan.uiweb.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.eloan.business.service.IBidRequestService;

@Controller
public class IndexController extends BaseController {
	
	@Autowired
	private IBidRequestService bidRequestService;
	
	@RequestMapping("index")
	public String index(Model model){
		model.addAttribute("bidRequests",this.bidRequestService.listIndexBidRequests(6));
		return "main";
	}

}
