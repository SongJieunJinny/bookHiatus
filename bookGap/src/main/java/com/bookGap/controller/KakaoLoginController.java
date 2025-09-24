package com.bookGap.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import org.springframework.security.core.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.KakaoUserDetails;
import com.bookGap.service.UserService;
import com.bookGap.vo.UserInfoVO;

@Controller
public class KakaoLoginController {
	@Autowired
	UserService userService;
	
	@PostMapping("/kakaoLoginCallback.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> kakaoLogin(
	        @RequestBody Map<String, String> payload,
	        javax.servlet.http.HttpServletRequest request,
	        HttpSession session) {

	    String kakaoId = payload.get("kakaoId");
	    String nickname = payload.get("nickname");
	    String userId = "kakao_" + kakaoId;
	    String accessToken = payload.get("accessToken");

	    UserInfoVO user = userService.findByKakaoId(kakaoId);
	    if (user == null) {
	        user = userService.findById(userId);
	        if (user == null) {
	            user = new UserInfoVO();
	            user.setUserId(userId);
	            user.setUserName(nickname);
	            user.setKakaoId(kakaoId);
	            user.setOauthProvider("kakao");
	            user.setUserEnabled(true);
	            user.setUserAuthority("ROLE_USER_KAKAO");
	            user.setUserState(1);
	            userService.insertKakaoUser(user);
	        }
	    }

	    String authority = (user.getUserAuthority() == null || user.getUserAuthority().trim().isEmpty())
	            ? "ROLE_USER_KAKAO"
	            : user.getUserAuthority();

	    org.springframework.security.authentication.UsernamePasswordAuthenticationToken auth =
	        new org.springframework.security.authentication.UsernamePasswordAuthenticationToken(
	            new KakaoUserDetails(user), null,
	            java.util.Collections.singletonList(
	                new org.springframework.security.core.authority.SimpleGrantedAuthority(authority))
	        );
	    auth.setDetails(new org.springframework.security.web.authentication.WebAuthenticationDetails(request));

	    // 컨텍스트 & 세션에 저장(영속)
	    org.springframework.security.core.context.SecurityContext context =
	        org.springframework.security.core.context.SecurityContextHolder.createEmptyContext();
	    context.setAuthentication(auth);
	    org.springframework.security.core.context.SecurityContextHolder.setContext(context);

	    request.getSession(true).setAttribute(
	        org.springframework.security.web.context.HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
	        context
	    );

	    session.setAttribute("KAKAO_ACCESS_TOKEN", accessToken);

	    Map<String, Object> result = new HashMap<>();
	    result.put("status", "success");
	    return ResponseEntity.ok(result);
	}
	
	
	@RequestMapping(value="/kakaoServerLogout.do",  method={RequestMethod.GET, RequestMethod.POST})
	public String kakaoServerLogout(HttpServletRequest request,
	                                HttpServletResponse response,
	                                HttpSession session) {

	    String accessToken = (String) session.getAttribute("KAKAO_ACCESS_TOKEN");
	    if (accessToken != null && !accessToken.isEmpty()) {
	        try {
	            HttpHeaders headers = new HttpHeaders();
	            headers.set("Authorization", "Bearer " + accessToken);
	            new RestTemplate().exchange(
	                "https://kapi.kakao.com/v1/user/logout",
	                HttpMethod.POST,
	                new HttpEntity<>(headers),
	                String.class
	            );
	        } catch (Exception ignore) {}
	    }

	    // 표준 로그아웃(세션/컨텍스트/쿠키)
	    new SecurityContextLogoutHandler().logout(request, response, null);

	    // remember-me 쿠키 보강 삭제(선택)
	    String cookiePath = (request.getContextPath() == null || request.getContextPath().isEmpty())
	            ? "/" : request.getContextPath();
	    Cookie rm = new Cookie("SPRING_SECURITY_REMEMBER_ME_COOKIE", null);
	    rm.setPath(cookiePath); rm.setMaxAge(0); rm.setHttpOnly(true); response.addCookie(rm);

	    return "redirect:/";
	}

	
	
}
