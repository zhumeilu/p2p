package com.eloan.base.util;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.eloan.base.domain.Logininfo;
import com.eloan.business.service.VerifyCode;

public class UserContext {

	public static final String LOGIN_IN_SESSION = "logininfo";
	public static final String VERIFYCODE_IN_SESSION = "VERIFYCODE_IN_SESSION";

	private static HttpServletRequest getRequest() {
		return ((ServletRequestAttributes) RequestContextHolder
				.getRequestAttributes()).getRequest();
	}
	
	public static void putLogininfo(Logininfo logininfo) {
		getRequest().getSession().setAttribute(LOGIN_IN_SESSION, logininfo);
	}

	public static Logininfo getCurrent() {
		return (Logininfo) getRequest().getSession().getAttribute(
				LOGIN_IN_SESSION);
	}

	public static void putVerifyCode(VerifyCode code) {
		getRequest().getSession().setAttribute(VERIFYCODE_IN_SESSION, code);
	}

	public static VerifyCode getVerifyCode() {
		return (VerifyCode) getRequest().getSession().getAttribute(
				VERIFYCODE_IN_SESSION);
	}
}
