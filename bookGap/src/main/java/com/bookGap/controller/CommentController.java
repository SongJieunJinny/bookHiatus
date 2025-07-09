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

import com.bookGap.service.BookService;
import com.bookGap.service.CommentService;
import com.bookGap.util.PagingUtil;
import com.bookGap.vo.CommentVO;
import com.bookGap.vo.SearchVO;

@RequestMapping(value="/comment")
@Controller
public class CommentController {
  
	@Autowired
	public CommentService commentService;
	
	@Autowired
  public BookService bookService;

	@ResponseBody
	@RequestMapping(value="/loadComment.do",method=RequestMethod.GET, produces = "application/json; charset=utf-8")
	public Map<String,Object> loadComment(@RequestParam("isbn") String isbn, Model model, Principal principal, HttpServletRequest request,
	                                      @RequestParam(value="cnowpage",required = false, defaultValue="1")int cnowpage){
    
    String loginUserId = (principal != null) ? principal.getName() : null;
    boolean isAdmin = request.isUserInRole("ROLE_ADMIN");
    
    SearchVO searchVO = new SearchVO();
    searchVO.setIsbn(isbn);
    
    // 총 댓글 수 조회
    int total = commentService.selectTotal(searchVO);
    
    // 페이징 처리
    PagingUtil paging = new PagingUtil(cnowpage, total, 5);
    searchVO.setStart(paging.getStart());
    searchVO.setPerPage(paging.getPerPage());
    
    // 댓글 리스트 조회
    List<CommentVO> clist = commentService.clist(searchVO);
    
    int displayNo = total - (cnowpage - 1) * paging.getPerPage();
    for (CommentVO cvo : clist) {
      cvo.setDisplayNo(displayNo--);
    
      //권한에 따라 댓글 출력 제어 (옵션 처리 가능)
      boolean canView = loginUserId != null && (loginUserId.equals(cvo.getUserId()) || isAdmin);
    }
    
    Map<String, Object> map = new HashedMap<>();
    map.put("clist", clist);
    map.put("cpaging", paging);
 
    System.out.println("searchVO.isbn = " + searchVO.getIsbn());
    System.out.println("댓글 개수 = " + total);

    return map;

	}
	
	/* write POST */
	
	@ResponseBody
	@RequestMapping(value="/write.do", method=RequestMethod.POST)
	public String write(CommentVO vo, HttpServletRequest request, Principal principal) {
	  if (principal == null) return "Fail";

    vo.setUserId(principal.getName());
    vo.setCommentContent(request.getParameter("commentContent"));

    String ratingStr = request.getParameter("commentRating");
    vo.setCommentRating(ratingStr != null ? Integer.parseInt(ratingStr) : 0);

    vo.setIsbn(request.getParameter("isbn"));
    vo.setCommentState("1");

    int bookNo = bookService.getBookNoByIsbn(vo.getIsbn());
    if (bookNo <= 0) return "Fail";
    vo.setBookNo(bookNo);

    return commentService.insert(vo) > 0 ? "Success" : "Fail";

	}

	/* modify POST */
	
	@ResponseBody
	@RequestMapping(value="/modify.do", method=RequestMethod.POST)
	public String modify(CommentVO vo, HttpServletRequest request, Principal principal) {
    if (principal == null) return "Fail";

    vo.setUserId(principal.getName());
    vo.setCommentContent(request.getParameter("commentContent"));

    String ratingStr = request.getParameter("commentRating");
    vo.setCommentRating(ratingStr != null && !ratingStr.trim().isEmpty() ? Integer.parseInt(ratingStr) : 1);

    vo.setIsbn(request.getParameter("isbn"));

    int bookNo = bookService.getBookNoByIsbn(vo.getIsbn());
    if (bookNo <= 0) return "Fail";
    vo.setBookNo(bookNo);

    return commentService.update(vo) > 0 ? "Success" : "Fail";
	}
	
	/* delete POST */
	
	@ResponseBody
	@RequestMapping(value="/delete.do",method=RequestMethod.POST)
  public String delete(@RequestParam("commentNo") int commentNo,
                       Principal principal, HttpServletRequest request) {

    if (principal == null) return "Fail";
    String loginUserId = principal.getName();
    boolean isAdmin = request.isUserInRole("ROLE_ADMIN");
    
    CommentVO cvo = commentService.selectOne(commentNo);
    if (cvo == null) return "Fail";
    
    boolean canDelete = loginUserId.equals(cvo.getUserId()) || isAdmin;
    if (!canDelete) return "Fail";
    
    return commentService.changeState(commentNo) > 0 ? "Success" : "Fail";
  }

}