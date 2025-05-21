package com.bookGap.controller;

import java.security.Principal;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookGap.service.MypageService;
import com.bookGap.vo.MypageVO;

@Controller 
public class MypageController {
	
	@Autowired
    private MypageService mypageService;
	
	@Autowired
    private BCryptPasswordEncoder passwordEncoder;
    
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

      return "user/mypageInfo";
    }
	
}
