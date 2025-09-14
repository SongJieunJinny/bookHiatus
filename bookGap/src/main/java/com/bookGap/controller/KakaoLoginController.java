package com.bookGap.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import org.springframework.security.core.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
	public ResponseEntity<Map<String, Object>> kakaoLogin(@RequestBody Map<String, String> payload, HttpSession session) {
	    String kakaoId = payload.get("kakaoId");
	    String nickname = payload.get("nickname");
	    String userId = "kakao_" + kakaoId;
	    String accessToken = payload.get("accessToken");
	    //System.out.println("세션 ID: " + kakaoId);
	    //System.out.println("userId: " + userId);
	    //System.out.println("KAKAO_ACCESS_TOKEN: " + session.getAttribute("KAKAO_ACCESS_TOKEN"));

	    // 1차 조회: 카카오 ID 기준
	    UserInfoVO user = userService.findByKakaoId(kakaoId);
	    //System.out.println("kakaoId 조회 결과: " + user);

	    if (user == null) {
	        // 2차 조회: 혹시 userId로도 존재하는 경우
	        user = userService.findById(userId);
	        //System.out.println("userId 조회 결과: " + user);
	        
	        if (user == null) {
	            // 신규 회원 등록
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

	    // userAuthority가 null인 경우 기본값 설정
	    String authority = user.getUserAuthority();
	    if (authority == null || authority.trim().isEmpty()) {
	        authority = "ROLE_USER";
	    }

	    // Spring Security 인증 처리
	    Authentication auth = new UsernamePasswordAuthenticationToken(
	        new KakaoUserDetails(user),
	        null,
	        List.of(new SimpleGrantedAuthority(authority))
	    );
	    SecurityContextHolder.getContext().setAuthentication(auth);
	    
	    session.setAttribute("KAKAO_ACCESS_TOKEN", accessToken);
	    //System.out.println("인증 여부: " + auth.isAuthenticated());
	    //System.out.println("유저명: " + auth.getName());
	    //System.out.println("타입: " + auth.getPrincipal().getClass());
	    

	    Map<String, Object> result = new HashMap<>();
	    result.put("status", "success");
	    return ResponseEntity.ok(result);
	}
	
	
	@PostMapping("/kakaoServerLogout.do")
	@ResponseBody
	public Map<String, Object> kakaoServerLogout(
	        javax.servlet.http.HttpServletRequest request,
	        javax.servlet.http.HttpServletResponse response,
	        HttpSession session) {

	    String accessToken = (String) session.getAttribute("KAKAO_ACCESS_TOKEN");

	   
	    if (accessToken != null && !accessToken.isEmpty()) {
	        try {
	            org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
	            headers.set("Authorization", "Bearer " + accessToken);
	            org.springframework.web.client.RestTemplate rt = new org.springframework.web.client.RestTemplate();

	            String url = "https://kapi.kakao.com/v1/user/logout";
	            rt.exchange(url, org.springframework.http.HttpMethod.POST,
	                    new org.springframework.http.HttpEntity<>(headers), String.class);
	        } catch (Exception ignore) {
	            
	        }
	    }

	    // 2) Spring 보안 컨텍스트/세션 정리
	    org.springframework.security.core.context.SecurityContextHolder.clearContext();
	    try { session.invalidate(); } catch (Exception ignore) {}

	    // 3) JSESSIONID/remember-me 쿠키 즉시 삭제 (경로 주의)
	    String path = request.getContextPath();
	    String cookiePath = (path == null || path.isEmpty()) ? "/" : path;

	    javax.servlet.http.Cookie js = new javax.servlet.http.Cookie("JSESSIONID", null);
	    js.setPath(cookiePath);
	    js.setMaxAge(0);
	    js.setHttpOnly(true);
	    response.addCookie(js);

	    javax.servlet.http.Cookie rm = new javax.servlet.http.Cookie("SPRING_SECURITY_REMEMBER_ME_COOKIE", null);
	    rm.setPath(cookiePath);
	    rm.setMaxAge(0);
	    rm.setHttpOnly(true);
	    response.addCookie(rm);

	    Map<String, Object> result = new HashMap<>();
	    result.put("status", "success");
	    return result; 
	}

	
	
}
