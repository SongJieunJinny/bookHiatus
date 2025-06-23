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

import com.bookGap.service.ECommentService;
import com.bookGap.util.PagingUtil;
import com.bookGap.vo.ECommentVO;
import com.bookGap.vo.SearchVO;

@RequestMapping(value="/eComment")
@Controller
public class ECommentController {
  
  @Autowired 
  private ECommentService eCommentService;
  
  /* loadComment GET */
  
  @ResponseBody
  @RequestMapping(value="/loadComment.do",method=RequestMethod.GET, produces = "application/json; charset=utf-8")
  public Map<String,Object> loadComment(int boardNo, Model model, SearchVO searchVO, Principal principal, HttpServletRequest request,
                                        @RequestParam(value="cnowpage",required = false, defaultValue="1")int cnowpage){

    String loginUserId = (principal != null) ? principal.getName() : null;
    boolean isAdmin = request.isUserInRole("ROLE_ADMIN");
    String boardWriterId = eCommentService.getBoardWriterId(boardNo);
    searchVO.setBoardNo(boardNo);

    int total = eCommentService.selectTotal(searchVO);
    
    PagingUtil paging = new PagingUtil(cnowpage, total, 5);
    searchVO.setStart(paging.getStart());
    searchVO.setPerPage(paging.getPerPage());

    List<ECommentVO> clist = eCommentService.clist(searchVO);

    int displayNo = total - (cnowpage - 1) * paging.getPerPage();
    
    for(ECommentVO ecvo : clist){
      ecvo.setDisplayNo(displayNo--);

      System.out.println("loginUserId: " + loginUserId);
      System.out.println("boardWriterId: " + boardWriterId);
      System.out.println("commentUserId: " + ecvo.getUserId());

      boolean canView = loginUserId != null && (loginUserId.equals(boardWriterId) ||loginUserId.equals(ecvo.getUserId()) ||isAdmin);
    }
    
    Map<String, Object> map = new HashedMap<>();
    map.put("clist", clist);
    map.put("cpaging", paging);
    map.put("boardType", searchVO.getBoardType());

    return map;
  }
  
  /* write POST */
  
  @ResponseBody
  @RequestMapping(value="/write.do",method=RequestMethod.POST)
  public String write(ECommentVO vo,HttpServletRequest request,Principal principal,
                      @RequestParam("boardType") int boardType){
  
    String loginUserId = principal.getName(); 

    vo.setUserId(loginUserId);
    
    if(request.getParameter("eCommentContent") != null && !request.getParameter("eCommentContent").isEmpty()){
      vo.seteCommentContent(request.getParameter("eCommentContent"));
    }

    int result = eCommentService.insert(vo);
    
    return result > 0 ? "Success" : "Fail";
  }
  
  /* modify POST */
  
  @ResponseBody
  @RequestMapping(value="/modify.do", method=RequestMethod.POST)
  public String modify(ECommentVO vo,HttpServletRequest request){
      
    if(request.getParameter("eCommentContent") != null && !request.getParameter("eCommentContent").equals("")){
      vo.seteCommentContent(request.getParameter("eCommentContent"));
    }
      
    int result = eCommentService.update(vo);
        
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
  public String delete(int eCommentNo){
    
  int result = eCommentService.changeState(eCommentNo);
  
    if(result > 0){
      System.out.println("삭제성공");
      return "Success";
    }else{
      System.out.println("삭제실패");
      return "Fail";
    }
  }
  
}
