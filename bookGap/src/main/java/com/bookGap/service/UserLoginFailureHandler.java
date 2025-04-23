package com.bookGap.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class UserLoginFailureHandler implements AuthenticationFailureHandler {

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		//로그인 실패시 호출!
		System.out.println("로그인 실패!");
	
		request.getSession().setAttribute("loginError", "아이디 또는 비밀번호가 잘못되었습니다.");
		response.sendRedirect(request.getContextPath()); 
	}

}
