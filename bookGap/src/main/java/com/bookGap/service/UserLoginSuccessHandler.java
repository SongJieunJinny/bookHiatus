package com.bookGap.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class UserLoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
	                                    Authentication authentication) throws IOException, ServletException {
	    System.out.println("로그인 성공!");
	    HttpSession session = request.getSession(false);
	    String redirectUrl = request.getContextPath(); // 기본

	    if (session != null && session.getAttribute("redirectAfterLogin") != null) {
	        redirectUrl = (String) session.getAttribute("redirectAfterLogin");
	        session.removeAttribute("redirectAfterLogin");
	    } else {
	        // SavedRequest 우선 적용
	        org.springframework.security.web.savedrequest.HttpSessionRequestCache cache =
	            new org.springframework.security.web.savedrequest.HttpSessionRequestCache();
	        org.springframework.security.web.savedrequest.SavedRequest saved = cache.getRequest(request, response);
	        if (saved != null) {
	            redirectUrl = saved.getRedirectUrl();
	        }
	    }
	    response.sendRedirect(redirectUrl);
	}
	
}
