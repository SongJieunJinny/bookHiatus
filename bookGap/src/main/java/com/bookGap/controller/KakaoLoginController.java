package com.bookGap.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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
import com.bookGap.vo.UserVO;

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

	    // 1차 조회: 카카오 ID 기준
	    UserInfoVO user = userService.findByKakaoId(kakaoId);
	    System.out.println("kakaoId 조회 결과: " + user);

	    if (user == null) {
	        // 2차 조회: 혹시 userId로도 존재하는 경우
	        user = userService.findById(userId);
	        System.out.println("userId 조회 결과: " + user);
	        
	        if (user == null) {
	            // 신규 회원 등록
	            user = new UserInfoVO();
	            user.setUserId(userId);
	            user.setUserName(nickname);
	            user.setKakaoId(kakaoId);
	            user.setOauthProvider("kakao");
	            user.setUserEnabled(true);
	            user.setUserAuthority("ROLE_USER");
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

	    Map<String, Object> result = new HashMap<>();
	    result.put("status", "success");
	    return ResponseEntity.ok(result);
	}
}
