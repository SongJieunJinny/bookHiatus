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
    
    return map;

	}
	
	/* write POST */
	
	@ResponseBody
	@RequestMapping(value="/write.do",method=RequestMethod.POST)
	public String write(CommentVO vo,HttpServletRequest request,Principal principal){
		
    String loginUserId = principal.getName(); 
    boolean isAdmin = request.isUserInRole("ROLE_ADMIN"); // 관리자 여부 확인
    
    vo.setUserId(loginUserId);
    
    if(request.getParameter("commentContent") != null && !request.getParameter("commentContent").isEmpty()){
        vo.setCommentContent(request.getParameter("commentContent"));
    }
  
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