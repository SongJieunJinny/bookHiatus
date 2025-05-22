package com.bookGap.controller;

import java.security.Principal;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.MypageService;
import com.bookGap.vo.MypageVO;

@Controller 
public class MypageController {
	
	@Autowired
    private MypageService mypageService;
	
	@Autowired
    private BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	public JavaMailSenderImpl mailSender;
    
	// 마이페이지 진입(GET)
    @RequestMapping(value="/mypage.do", method = RequestMethod.GET)
    public String mypage() {
      System.out.println("GET /mypage.do");
      return "user/mypage";
    }

    // 본인확인 처리(POST)
    @RequestMapping(value="/user/mypage.do", method = RequestMethod.POST)
    public String mypage(@RequestParam("USER_ID") String inputId,
                         @RequestParam("USER_PW") String inputPw,
                         Principal principal, HttpSession session, Model model) {	  
	  String loggedInId = principal.getName();
	  System.out.println("🔍 getUserById 호출 - ID: " + loggedInId);
	  
	  MypageVO vo = mypageService.getUserById(loggedInId);
	  System.out.println("📌 DB 조회 결과: " + (vo != null ? "사용자 정보 있음" : "❌ 사용자 정보 없음"));
	  
	  //아이디 비교 (입력값 vs 로그인 아이디)
	  if (!loggedInId.equals(inputId)) {
		System.out.println("로그인된 아이디: " + loggedInId);
	    System.out.println("❌ 입력한 아이디가 로그인된 아이디와 다릅니다.");
	    model.addAttribute("error", "입력한 아이디가 현재 로그인된 계정과 일치하지 않습니다.");
	    return "user/mypage";
	  }
	
	  //사용자 정보 가져오기
      if (vo == null) {
    	System.out.println("로그인된 아이디: " + loggedInId);
	    System.out.println("❌ 사용자 정보 없음");
	    model.addAttribute("error", "사용자 정보를 찾을 수 없습니다.");
	    return "user/mypage";
	  }
	
	  //비밀번호 비교 (암호화된 비밀번호 비교)
	  if (!passwordEncoder.matches(inputPw, vo.getUserPw())) {
	    System.out.println("❌ 비밀번호 불일치");
	    System.out.println("로그인된 아이디: " + loggedInId);
	    System.out.println("로그인된 비번: " + vo.getUserPw());
	    model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
	    return "user/mypage";
	  }
	
	  //본인확인 성공
	  System.out.println("본인확인 성공");
	  System.out.println("✅ 본인 확인된 사용자 정보: " + vo);
	  session.setAttribute("LOGIN_USER", vo);  // 세션에 저장
	  model.addAttribute("user", vo); 
	  return "user/mypageInfo";  // 다음 JSP로 이동
    }
    
    // 본인정보 변경(POST)
    @RequestMapping(value="/user/mypageInfo.do", method = RequestMethod.POST)
    public String mypageInfo(MypageVO vo, Model model, HttpSession session) {
      System.out.println("✅ POST /user/mypageInfo.do 호출됨");

      MypageVO mypageUser = (MypageVO) session.getAttribute("LOGIN_USER");
      if (mypageUser == null) {
        System.out.println("❌ 세션 정보 없음. 본인확인 필요");
        return "redirect:/mypage.do";
      }

      vo.setUserId(mypageUser.getUserId());  // 보안상 세션에서 ID 설정

      int result = mypageService.userUpdate(vo);

      if (result > 0) {
       System.out.println("✅ 사용자 정보 수정 성공");
       MypageVO updatedUser = mypageService.getUserById(vo.getUserId());
        session.setAttribute("LOGIN_USER", updatedUser);
        model.addAttribute("user", updatedUser);  // 성공 시도 새 정보 반영
        model.addAttribute("message", "정보가 성공적으로 수정되었습니다.");
      } else {
        System.out.println("❌ 사용자 정보 수정 실패");
        model.addAttribute("error", "정보 수정에 실패했습니다.");
        model.addAttribute("user", vo);  // 입력값 유지
      }
      return "redirect:/";
    }
    
   // 비밀번호변경 모달창OPEN(GET)
    @ResponseBody
	@RequestMapping(value="/user/mypageInfo/openPwChangeModal.do", method = RequestMethod.GET)
	public String openPwChangeModal(String changePwModal) {
		return "success";
	}
    
    // 비밀번호변경위한 이메일전송(POST)
    @ResponseBody
	@RequestMapping(value = "/user/mypageInfo/sendMail.do", method = RequestMethod.POST)
	public String sendMail(String userEmail) {		
	  Random random = new Random();
	  int checkNum = random.nextInt(888888) + 111111;
	  System.out.println("checkNum::::::::::=>"+checkNum);
	  System.out.println("email::::::::::"+userEmail);
	  /* 이메일 보내기 */
      String setFrom = "sgh9948@gmail.com";
      String toMail = userEmail;
      String title = "회원가입 인증 이메일 입니다.";
      String content = 
        "홈페이지를 방문해주셔서 감사합니다." +
        "<br><br>" + 
        "인증 번호는 " + checkNum + "입니다." + 
        "<br>" + 
        "해당 인증번호를 인증번호 확인란에 기입하여 주세요.";
      try {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
        helper.setFrom(setFrom);
        helper.setTo(toMail);
        helper.setSubject(title);
        helper.setText(content,true);
        mailSender.send(message);
      }catch(Exception e) {
        e.printStackTrace();
      }
      return Integer.toString(checkNum);
	}
	
    // 비밀번호변경(POST)
    @ResponseBody
    @RequestMapping(value="/user/mypageInfo/pwChange.do", method = RequestMethod.POST)
	public String pwChange(MypageVO mypageVO,Principal principal) {
		
		String userId = principal.getName();
		mypageVO.setUserId(userId);
		
		BCryptPasswordEncoder epwe = new BCryptPasswordEncoder();
		String encodedPassword = epwe.encode(mypageVO.getUserPw());
		mypageVO.setUserPw(encodedPassword);
		System.out.println("암호화된 비밀번호: " + encodedPassword);
		System.out.println("userId: " + userId);
		System.out.println("변경할 비밀번호: " + mypageVO.getUserPw());
		
		int rs = mypageService.userPwUpdate(mypageVO);
		
		if (rs > 0) {
			System.out.println("success");
			return "success";
		} else {
			System.out.println("error");
			return "error";
		}
	}
    
    // 마이페이지 진입(GET)
    @RequestMapping(value="/deleteMembership.do", method = RequestMethod.GET)
    public String deleteMembership() {
      System.out.println("GET /deleteMembership.do");
      return "user/deleteMembership";
    }
	
}
