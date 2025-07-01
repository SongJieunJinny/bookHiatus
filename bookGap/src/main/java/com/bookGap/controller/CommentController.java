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

import com.bookGap.service.CommentService;
import com.bookGap.util.PagingUtil;
import com.bookGap.vo.CommentVO;
import com.bookGap.vo.SearchVO;

@RequestMapping(value="/comment")
@Controller
public class CommentController {
	
	@Autowired
	public CommentService commentService;
	
	@ResponseBody
	@RequestMapping(value="/loadComment.do",method=RequestMethod.GET, produces = "application/json; charset=utf-8")
	public Map<String,Object> loadComment(int bookNo, Model model, SearchVO searchVO, Principal principal, HttpServletRequest request,
										  @RequestParam(value="cnowpage",required = false, defaultValue="1")int cnowpage){
    
    String loginUserId = (principal != null) ? principal.getName() : null;
    boolean isAdmin = request.isUserInRole("ROLE_ADMIN");
    searchVO.setBookNo(bookNo);
    
    int total = commentService.selectTotal(searchVO);
    
    PagingUtil paging = new PagingUtil(cnowpage, total, 5);
    searchVO.setStart(paging.getStart());
    searchVO.setPerPage(paging.getPerPage());
    
    List<CommentVO> clist = commentService.clist(searchVO);
    
    int displayNo = total - (cnowpage - 1) * paging.getPerPage();
    
    for (CommentVO cvo : clist) {
      cvo.setDisplayNo(displayNo--);
    
      System.out.println("loginUserId: " + loginUserId);
      System.out.println("commentUserId: " + cvo.getUserId());
    
      boolean canView = loginUserId != null && (loginUserId.equals(cvo.getUserId()) || isAdmin);
    }
    
    Map<String, Object> map = new HashedMap<>();
    map.put("clist", clist);
    map.put("cpaging", paging);
    
    System.out.println("bookNo = " + bookNo); 
    System.out.println("searchVO.bookNo = " + searchVO.getBookNo());
    System.out.println("댓글 개수 = " + total);

    return map;

	}
	
	/* write POST */
	
	@ResponseBody
	@RequestMapping(value="/write.do",method=RequestMethod.POST)
	public String write(CommentVO vo,HttpServletRequest request,Principal principal){
	  
	  if (principal == null) {
      return "Fail"; // 로그인 안 된 상태
	  }
		
    String loginUserId = principal.getName(); 
    vo.setUserId(loginUserId);  // 댓글쓴이
    
    String content = request.getParameter("commentContent");
    if (content == null || content.trim().isEmpty()) {
        return "Fail";
    }
    vo.setCommentContent(content);  // 내용
    vo.setCommentState("1");  // 기본값: 활성화
    vo.setCommentRating( Integer.parseInt(request.getParameter("commentRating")) ); // 별점

  
    int result = commentService.insert(vo);
    
    return result > 0 ? "Success" : "Fail";
	}
	
	/* modify POST */
	
	@ResponseBody
	@RequestMapping(value="/modify.do", method=RequestMethod.POST)
	public String modify(CommentVO vo,HttpServletRequest request){
	    	
  	if(request.getParameter("commentContent") != null && !request.getParameter("commentContent").equals("")){
  		vo.setCommentContent(request.getParameter("commentContent"));
  	}
      	
    int result = commentService.update(vo);
        
    if(result > 0){
      System.out.println("수정성공");
      return "Success";
    }else{
      System.out.println("수정실패");
      return "Fail";
    }
	}
	
	/* delete POST */
	
	@ResponseBody
	@RequestMapping(value="/delete.do",method=RequestMethod.POST)
	public String delete(int commentNo){
			
  	int result = commentService.changeState(commentNo);
  	
    if(result > 0){
      System.out.println("삭제성공");
      return "Success";
    }else{
      System.out.println("삭제실패");
      return "Fail";
    }
	}
	
}