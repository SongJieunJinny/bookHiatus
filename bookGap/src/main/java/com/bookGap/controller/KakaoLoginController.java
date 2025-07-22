package com.bookGap.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import java.util.*;

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
	    String accessToken = payload.get("accessToken");

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
	    
	    session.setAttribute("KAKAO_ACCESS_TOKEN", accessToken);

	    Map<String, Object> result = new HashMap<>();
	    result.put("status", "success");
	    return ResponseEntity.ok(result);
	}
	
	
    @PostMapping("/kakaoServerLogout.do")
    @ResponseBody
    public Map<String, Object> kakaoServerLogout(HttpSession session) {
        String accessToken = (String) session.getAttribute("KAKAO_ACCESS_TOKEN");
        String url = "https://kapi.kakao.com/v1/user/unlink";
        Map<String, Object> result = new HashMap<>();

        if (accessToken != null && !accessToken.isEmpty()) {
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);
            HttpEntity<String> entity = new HttpEntity<>(headers);

            RestTemplate restTemplate = new RestTemplate();
            try {
                restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
                result.put("message", "카카오 계정 연결 해제 완료");
            } catch (Exception e) {
                result.put("message", "카카오 unlink 실패: " + e.getMessage());
            }
        }

        // Spring Security 세션 초기화
        SecurityContextHolder.clearContext();
        session.invalidate();

        result.put("status", "success");
        // 로그아웃 후 Spring Security logout 처리 URL로 리디렉션
        result.put("redirect", "/logout.do");
        return result;
    }

	
	
}
