package com.bookGap.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.vo.UserAddressVO;
import com.bookGap.vo.UserInfoVO;
import com.bookGap.service.UserService;

@Controller
public class UserController {
	
	@Autowired
	UserService userService;
	
	@Autowired
    private BCryptPasswordEncoder epwe;

	@RequestMapping(value="/join.do", method = RequestMethod.GET)
	public String join() {
		return "user/join";
	}
	
	@RequestMapping(value="/joinOk.do", method = RequestMethod.POST)
	public String joinOk(UserInfoVO userInfoVO, UserAddressVO userAddressVO) {
	  System.out.println("USER_ID: " + userInfoVO.getUserId());
	  System.out.println("Address PostCode: " + userAddressVO.getPostCode());

	  if (userInfoVO.getUserPw() == null || userInfoVO.getUserPw().isEmpty()) {
	    System.out.println("🚨 오류: 비밀번호가 null이거나 비어 있습니다!");
	    return "redirect:/join";  // 비밀번호가 없을 경우 회원가입 페이지로 다시 이동
	  }

	  // 정상적으로 비밀번호가 존재하면 암호화 진행
	  epwe = new BCryptPasswordEncoder();
    String encodedPassword = epwe.encode(userInfoVO.getUserPw());
    userInfoVO.setUserPw(encodedPassword);

    boolean isSuccess = userService.joinUserAndAddress(userInfoVO, userAddressVO);

    if(isSuccess){
      System.out.println("✅ 회원가입 및 주소 등록 성공");
    }else{
      System.out.println("🚨 회원가입 실패");
      return "redirect:/join.do"; 
    }
	  return "redirect:/";
	}
	
	@PostMapping("/auth/saveRedirect.do")
	@ResponseBody
	public ResponseEntity<?> saveRedirect(@RequestParam("redirectUrl") String redirectUrl, HttpSession session) {
	    session.setAttribute("redirectAfterLogin", redirectUrl);

	    return ResponseEntity.ok().build();
	}
	
	@RequestMapping("/login.do")
    public String loginPage() {
        return "user/login"; // 예: /WEB-INF/views/user/login.jsp
    }

}