package com.bookGap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bookGap.vo.UserInfoVO;
import com.bookGap.service.UserService;

@Controller
public class UserController {
	
	@Autowired
	UserService userService;

	@RequestMapping(value="/join.do", method = RequestMethod.GET)
	public String join() {
		return "user/join";
	}
	
	@RequestMapping(value="/joinOk.do", method = RequestMethod.POST)
	public String joinOk(UserInfoVO userInfoVO) {
		System.out.println("USER_ID:" + userInfoVO.getUserId());
		BCryptPasswordEncoder epwe = new BCryptPasswordEncoder();
		String encodedPassword = epwe.encode(userInfoVO.getUserPw());
		userInfoVO.setUserPw(encodedPassword);
		System.out.println("암호화된 비밀번호: " + encodedPassword);
		
		int result = userService.insertUser(userInfoVO);
		
		if(result > 0) {
			System.out.println("회원가입성공");
		}else {
			System.out.println("회원가입실패");
		}
		
		return "redirect:/";
	}
	
}
