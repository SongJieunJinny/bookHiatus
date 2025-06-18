package com.bookGap.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections4.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.QCommentService;
import com.bookGap.util.PagingUtil;
import com.bookGap.vo.QCommentVO;
import com.bookGap.vo.SearchVO;

@RequestMapping(value="/comment")
@Controller
public class QCommentController {
	
  @Autowired 
    private QCommentService qCommentService;
	
  @ResponseBody
  @RequestMapping(value="/loadComment.do",method=RequestMethod.GET, produces = "application/json; charset=utf-8")
  public Map<String,Object> loadComment(int boardNo, Model model, SearchVO searchVO, 
		  								Principal principal, HttpServletRequest request,
										@RequestParam(value="cnowpage",required = false, defaultValue="1")int cnowpage){
	
    String loginUserId = (principal != null) ? principal.getName() : null;
    boolean isAdmin = request.isUserInRole("ROLE_ADMIN");
    String boardWriterId = qCommentService.getBoardWriterId(boardNo);

    searchVO.setBoardNo(boardNo);
    int total = qCommentService.selectTotal(searchVO);
    PagingUtil paging = new PagingUtil(cnowpage, total, 5);

    searchVO.setStart(paging.getStart());
    searchVO.setPerPage(paging.getPerPage());

    List<QCommentVO> clist = qCommentService.clist(searchVO);

    int displayNo = total - (cnowpage - 1) * paging.getPerPage();
    
    for (QCommentVO qcvo : clist) {
      qcvo.setDisplayNo(displayNo--);

      System.out.println("loginUserId: " + loginUserId);
      System.out.println("boardWriterId: " + boardWriterId);
      System.out.println("commentUserId: " + qcvo.getUserId());

      boolean canView = loginUserId != null &&
              (loginUserId.equals(boardWriterId) ||
               loginUserId.equals(qcvo.getUserId()) ||
               isAdmin);
    }
    
    Map<String, Object> map = new HashedMap<>();
    map.put("clist", clist);
    map.put("cpaging", paging);
    map.put("boardType", searchVO.getBoardType());

    return map;

	}
  
  @ResponseBody
  @RequestMapping(value="/write.do",method=RequestMethod.POST)
  public String write(QCommentVO vo,HttpServletRequest request,Principal principal,
					  @RequestParam("boardType") int boardType){
	
	String loginUserId = principal.getName(); 
	String boardWriterId = qCommentService.getBoardWriterId(vo.getBoardNo()); // 게시글 작성자
    boolean isAdmin = request.isUserInRole("ROLE_ADMIN"); // 관리자 여부 확인
		
    // 댓글 작성 권한 체크
    if (!(loginUserId.equals(boardWriterId) || isAdmin)) {
      return "AccessDenied"; // 또는 403 응답 처리
    }
    
    vo.setUserId(loginUserId);
    
    if (request.getParameter("qCommentContent") != null && !request.getParameter("qCommentContent").isEmpty()) {
        vo.setqCommentContent(request.getParameter("qCommentContent"));
    }

    int result = qCommentService.insert(vo);
    
    return result > 0 ? "Success" : "Fail";
  }
  
  @ResponseBody
  @RequestMapping(value="/modify.do", method=RequestMethod.POST)
  public String modify(QCommentVO vo,HttpServletRequest request){
    	
	if(request.getParameter("qCommentContent") != null && !request.getParameter("qCommentContent").equals("")){
		vo.setqCommentContent(request.getParameter("qCommentContent"));
	}
    	
    int result = qCommentService.update(vo);
        
    if(result > 0){
      System.out.println("수정성공");
      return "Success";
    }else{
      System.out.println("수정실패");
      return "Fail";
    }
  }
    
  @ResponseBody
  @RequestMapping(value="/delete.do",method=RequestMethod.POST)
  public String delete(int qCommentNo){
		
	int result = qCommentService.changeState(qCommentNo);
	
    if(result > 0){
        System.out.println("삭제성공");
        return "Success";
      }else{
        System.out.println("삭제실패");
        return "Fail";
      }
  }
	
  private String restoreSanitizedInput(String input){
    if(input == null){
      return null;
    }input = input
      .replaceAll("&lt;", "<")
      .replaceAll("&gt;", ">")
      .replaceAll("&quot;", "\"")
      .replaceAll("&#x27;", "'")
      .replaceAll("&amp;", "&")
      .replaceAll("<br>", "\n");
    
    return input;
  }
}