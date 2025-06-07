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
										@RequestParam(value="cnowpage",required = false,defaultValue="1")int cnowpage){
	  
	searchVO.setBoardNo(boardNo); 
		
    int total = qCommentService.selectTotal(searchVO);
		
	PagingUtil paging = new PagingUtil(cnowpage, total, 5);
		
	searchVO.setStart(paging.getStart());
	searchVO.setPerPage(paging.getPerPage());
		
	List<QCommentVO> clist = qCommentService.clist(searchVO);
		
	// 번호 계산 및 설정
	int displayNo = total - (cnowpage - 1) * paging.getPerPage();
	
	for(QCommentVO qcvo : clist){
	    System.out.println("댓글 작성자: " + qcvo.getUserId());
	}
	for(QCommentVO qcvo : clist){
	    qcvo.setDisplayNo(displayNo--); // 각 게시물 번호 설정
	    qcvo.setqCommentContent(restoreSanitizedInput(qcvo.getqCommentContent()));
	}
	    
	Map<String,Object> map = new HashedMap<String, Object>();
	map.put("clist",clist);
	map.put("cpaging",paging);
	map.put("boardType",searchVO.getBoardType());
	
	return map;
  }
  
  @ResponseBody
  @RequestMapping(value="/write.do",method=RequestMethod.POST)
  public String write(QCommentVO vo,HttpServletRequest request,Principal principal,
					  @RequestParam("boardType") int boardType){
	
	vo.setUserId(principal.getName());
		
	if(request.getParameter("qCommentContent") != null && !request.getParameter("qCommentContent").equals("")){
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