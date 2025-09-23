package com.bookGap.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
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
	
	@Autowired UserService userService;
	
	@Autowired private BCryptPasswordEncoder epwe;
 
  @Autowired public JavaMailSenderImpl mailSender;
  
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
	

	
	@RequestMapping("/login.do")
  public String loginPage() {
      return "user/login"; // 예: /WEB-INF/views/user/login.jsp
  }
	
	// 비밀번호 찾기 페이지를 보여주는 메소드
	@RequestMapping(value="/findPw.do", method = RequestMethod.GET)
  public String findPw() {
    return "user/findPw";
  }
	
  //인증번호 발송 요청을 처리하는 메소드
	@PostMapping("/findPw/sendVerificationCode.do")
  @ResponseBody
  public Map<String, Object> sendVerificationCode( @RequestParam("userId") String userId,
                                                   @RequestParam("userEmail") String userEmail,
                                                   HttpSession session) {
      
    Map<String, Object> response = new HashMap<>();

    // 아이디/이메일로 사용자 존재 여부 확인 기능 
    boolean userExists = userService.checkUserExists(userId, userEmail);

    if(!userExists){
      response.put("success", false);
      response.put("message", "일치하는 사용자 정보가 없습니다.");
      return response;
    }

    // 인증번호 생성 및 이메일 발송
    try{
      int verificationCode = new Random().nextInt(888888) + 111111;
      String from = "sgh9948@gmail.com";
      String title = "BookGap 비밀번호 재설정 인증 메일";
      String content = "인증 번호는 <b style='font-size:16px;'>" + verificationCode + "</b> 입니다.";
      
      MimeMessage message = mailSender.createMimeMessage();
      MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
      helper.setFrom(from);
      helper.setTo(userEmail);
      helper.setSubject(title);
      helper.setText(content, true);
      mailSender.send(message);

      // 세션에 인증번호와 누구의 것인지(userId) 저장 (보안을 위해 3분만 유지)
      session.setAttribute("verificationCode", verificationCode);
      session.setAttribute("userIdForReset", userId);
      session.setMaxInactiveInterval(180); 

      response.put("success", true);

    }catch (Exception e){
      e.printStackTrace();
      response.put("success", false);
      response.put("message", "메일 발송 중 오류가 발생했습니다.");
    }
    return response;
  }

  //인증번호 확인 후, 비밀번호를 최종 변경하는 메소드
  @PostMapping("/findPw/resetPassword.do")
  @ResponseBody
  public Map<String, Object> resetPassword(@RequestParam("code") int userSubmittedCode,
                                           @RequestParam("newPassword") String newPassword,
                                           HttpSession session) {
      
    Map<String, Object> response = new HashMap<>();
    
    Integer sessionCode = (Integer) session.getAttribute("verificationCode");
    String userId = (String) session.getAttribute("userIdForReset");

    if(sessionCode == null || userId == null){
      response.put("success", false);
      response.put("message", "인증 시간이 만료되었습니다. 처음부터 다시 시도해주세요.");
      return response;
    }

    if(sessionCode == userSubmittedCode){
      UserInfoVO userToUpdate = new UserInfoVO();
      userToUpdate.setUserId(userId);
      userToUpdate.setUserPw(epwe.encode(newPassword)); // 비밀번호 암호화
      
      int result = userService.userPwUpdate(userToUpdate);

      if(result > 0){
        response.put("success", true);
        session.invalidate(); // 보안을 위해 사용한 세션은 즉시 삭제
      }else{
        response.put("success", false);
        response.put("message", "DB 오류로 비밀번호 변경에 실패했습니다.");
      }
    }else{
      response.put("success", false);
      response.put("message", "인증번호가 일치하지 않습니다.");
    }
    return response;
  }
}