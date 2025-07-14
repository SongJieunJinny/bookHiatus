package com.bookGap.controller;

import java.security.Principal;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.CommentService;
import com.bookGap.vo.CommentVO;


@RequestMapping(value="/comment")
@Controller
public class CommentController {
  
	@Autowired public CommentService commentService;

  /* load GET */
	@ResponseBody
	@RequestMapping(value="/loadComment.do",method=RequestMethod.GET, produces = "application/json; charset=utf-8")
	public Map<String,Object> loadComment(@RequestParam("isbn") String isbn, Principal principal,
	                                      @RequestParam(value="cnowpage",required = false, defaultValue="1")int cnowpage){

    String loginUserId = (principal != null) ? principal.getName() : null;  // 현재 로그인한 사용자 ID를 서비스에 전달
    
    // 🔻 서비스 메소드 단 한 번 호출로 모든 로직 처리! 🔻
    return commentService.getCommentList(isbn, loginUserId, cnowpage);
	}
	
	/* write POST */
	
	@ResponseBody
	@RequestMapping(value="/write.do", method=RequestMethod.POST)
	public String write (CommentVO vo, Principal principal,
                  	   @RequestParam("commentRating") int rating,
                       @RequestParam("commentLiked") boolean liked) {

	  if(principal == null){ return "Fail_Login"; }  // 로그인되지 않은 사용자의 요청 거부

    try{
      vo.setUserId(principal.getName()); // 로그인된 사용자 ID를 VO에 설정
      commentService.writeComment(vo, rating, liked);
      
      return "Success";
    }catch(Exception e){
      e.printStackTrace(); // 서버 로그에 에러 기록
      return "Fail_Server"; // 서버 오류 발생 시
    }
  }

	/* modify POST */
	
	@ResponseBody
	@RequestMapping(value="/modify.do", method=RequestMethod.POST)
	public String modify(CommentVO vo, Principal principal,
	                     @RequestParam("commentNo") int commentNo,
                  	   @RequestParam("commentRating") int rating,
                       @RequestParam("commentLiked") boolean liked) {

	  if(principal == null){ return "Fail_Login"; }

    try{
      vo.setUserId(principal.getName()); // 보안을 위해 현재 로그인 사용자로 재설정
      vo.setCommentNo(commentNo);
      commentService.modifyComment(vo, rating, liked);
      
      return "Success";
    }catch (Exception e){
      e.printStackTrace();
      return "Fail_Server";
    }
  }
	
	/* delete POST */
	
	@ResponseBody
	@RequestMapping(value="/delete.do",method=RequestMethod.POST)
  public String delete(@RequestParam("commentNo") int commentNo,
                       Principal principal, HttpServletRequest request) {

	  if (principal == null) { return "Fail_Login"; }
	  
	  try{
      String loginUserId = principal.getName();
      boolean isAdmin = request.isUserInRole("ROLE_ADMIN");
      commentService.deleteComment(commentNo, loginUserId, isAdmin);
      
      return "Success";
    }catch(IllegalAccessException e){
      return "Fail_Permission"; 
    }catch(Exception e){
      e.printStackTrace();
      return "Fail_Server";
    }
  }

}