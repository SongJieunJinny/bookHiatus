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
		//로그인 성공시 호출!
		System.out.println("로그인 성공!");
		// 세션에서 redirect URL 확인
				HttpSession session = request.getSession(false); // 이미 존재하는 세션만 가져옴 (없으면 null)
				String redirectUrl = request.getContextPath(); // 기본값: 메인페이지

				if (session != null && session.getAttribute("redirectAfterLogin") != null) {
					redirectUrl = (String) session.getAttribute("redirectAfterLogin");
					session.removeAttribute("redirectAfterLogin"); // 사용 후 삭제 (1회용)
				}

				// 해당 URL로 이동
				response.sendRedirect(redirectUrl);
			}
	
}
