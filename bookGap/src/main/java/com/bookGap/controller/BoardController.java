package com.bookGap.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.BoardService;
import com.bookGap.service.BookService;
import com.bookGap.util.PagingUtil;
import com.bookGap.vo.BoardVO;
import com.bookGap.vo.SearchVO;

@Controller
public class BoardController {

	@Autowired private BoardService boardService;
	@Autowired private BookService bookService;
	
	/*-----------------------------------------------------------------------------------------------------*/
	/* GET noticeList */
	@RequestMapping(value="/noticeList.do", method = RequestMethod.GET)
	public String noticeList(Model model, SearchVO searchVO,
							             @RequestParam(value="nowpage",required = false,defaultValue="1")int nowpage) {
	  
	  if(searchVO.getBoardType()== null){ searchVO.setBoardType(1); }
	  
	  int total = boardService.boardListSearch(searchVO);
	  
	  System.out.println("전체 게시글 수: " + total);
		
	  PagingUtil paging = new PagingUtil(nowpage, total, 5);
		
	  searchVO.setStart(paging.getStart());
	  searchVO.setPerPage(paging.getPerPage());
		
	  List<BoardVO> list=boardService.list(searchVO);
		
	  // 번호 계산 및 설정
	  int displayNo = total - (nowpage - 1) * paging.getPerPage();
	  for(BoardVO vo : list){
	    vo.setDisplayNo(displayNo--); // 각 게시물 번호 설정
	    vo.setBoardTitle(restoreSanitizedInput(vo.getBoardTitle()));
	    vo.setBoardContent(restoreSanitizedInput(vo.getBoardContent()));		
	  }
	  
	  model.addAttribute("list",list);
	  model.addAttribute("paging",paging);
		
	  System.out.println("받은 검색어: " + searchVO.getSearchValue());
	  System.out.println("게시글 개수: " + list.size());
    return "board/noticeList";
	}
	
	/* GET noticeWrite */
	@RequestMapping(value="/noticeWrite.do", method = RequestMethod.GET)
	public String noticeWrite() {
	  System.out.println("methodGET : board/noticeWrite.do");
	  return "board/noticeWrite";
	}
	
	/* POST noticeWriteOk */
	@RequestMapping(value = "/noticeWriteOk.do", method = RequestMethod.POST)
	public String noticeWriteOk(BoardVO boardVO, Principal principal,
	                            @RequestParam("boardTitle") String boardTitle,
	                            @RequestParam("boardContent") String boardContent,
	                            @RequestParam("boardType") int boardType) {
	    
	  boardVO.setUserId(principal.getName());  // 로그인 사용자 설정
	  boardVO.setBoardTitle(boardTitle);
	  boardVO.setBoardContent(boardContent);
	  boardVO.setBoardType(boardType); // 정수형으로 바인딩

	  int result = boardService.insert(boardVO);
	  
	  if(result > 0){
	    return "redirect:noticeList.do?boardNo=" + boardVO.getBoardNo() + "&boardType=" + boardVO.getBoardType();
	  }else{
	    return "redirect:noticeWrite.do?boardType=" + boardVO.getBoardType();
	  }
	}
	
	/* GET noticeView */
	@RequestMapping(value="/noticeView.do", method = RequestMethod.GET)
	public String noticeView(Model model, @RequestParam("boardNo") int boardNo) {
	  
	  boardService.updateHit(boardNo); // 조회수 증가
	  BoardVO vo = boardService.selectOne(boardNo);

	  if(vo == null){ return "redirect:/noticeList.do"; }

	  model.addAttribute("vo", vo);
	  
	  return "board/noticeView";
	}
	
	/* GET noticeModify */
	@RequestMapping(value="/noticeModify.do", method=RequestMethod.GET)
	public String noticeModify(Principal principal, Model model, @RequestParam("boardNo") int boardNo) {
	  String loginUser = principal.getName(); // 로그인 사용자 ID
	  BoardVO vo = boardService.selectOne(boardNo); // 게시글 조회

	  if(vo == null){ return "redirect:noticeList.do"; }// 게시글이 존재하지 않을 경우 목록으로 리디렉트
	  if(!loginUser.equals(vo.getUserId())){ return "redirect:noticeList.do?BoardType=" + vo.getBoardType(); }// 작성자와 로그인 사용자가 다르면 리디렉트

	  model.addAttribute("vo", vo); // 뷰에 게시글 정보 전달
	  return "board/noticeModify"; // 수정 폼 JSP
	}
	
	/* POST noticeModifyOk */
	@RequestMapping(value="/noticeModifyOk.do", method=RequestMethod.POST)
	public String noticeModifyOk(BoardVO boardVO) {
	  int result = boardService.update(boardVO);

	  if(result > 0){
	    System.out.println("수정성공");
	  }else{
	    System.out.println("수정실패");
	  }
	  
	  return "redirect:noticeList.do?boardType=" + boardVO.getBoardType();
	}
	
	/* GET noticeDelete */
	@RequestMapping(value="/noticeDelete.do",method=RequestMethod.POST)
	public String noticeDelete(int boardNo) {
		
	  int result = boardService.changeState(boardNo);
		
	  return "redirect:noticeList.do";
	}

	/*-----------------------------------------------------------------------------------------------------*/
	
	/* GET qnaList */
	@RequestMapping(value="/qnaList.do", method = RequestMethod.GET)
	public String qnaList(Model model,SearchVO searchVO,
						            @RequestParam(value="nowpage",required = false,defaultValue="1")int nowpage) { 

	  int total = boardService.boardListSearch(searchVO);
		
	  PagingUtil paging = new PagingUtil(nowpage, total, 5);
		
	  searchVO.setStart(paging.getStart());
	  searchVO.setPerPage(paging.getPerPage());

	  List<BoardVO> qanList = boardService.qnaList(searchVO);
		
	  // 번호 계산 및 설정
	  int displayNo = total - (nowpage - 1) * paging.getPerPage();
	  for(BoardVO vo : qanList){
	    vo.setDisplayNo(displayNo--); // 각 게시물 번호 설정
      vo.setBoardTitle(restoreSanitizedInput(vo.getBoardTitle()));
      vo.setBoardContent(restoreSanitizedInput(vo.getBoardContent()));
	  }
		
	  model.addAttribute("qanList",qanList);
	  model.addAttribute("paging",paging);
	  
	  System.out.println("넘어온 boardType: " + searchVO.getBoardType());
		
	  return "board/qnaList";
	}
	
	/* GET qnaWrite */
	@RequestMapping(value="/qnaWrite.do", method = RequestMethod.GET)
	public String qnaWrite(Model model, @RequestParam("boardType") int boardType) {
	  model.addAttribute("boardType", boardType);
	  return "board/qnaWrite";
	}
	
	/* POST qnaWriteOk */
	@RequestMapping(value = "/qnaWriteOk.do", method = RequestMethod.POST)
	public String qnaWriteOk(BoardVO boardVO, Principal principal,
	                         @RequestParam("boardTitle") String boardTitle,
	                         @RequestParam("boardContent") String boardContent,
	                         @RequestParam("boardType") int boardType) {
	    
	  boardVO.setUserId(principal.getName());  // 로그인 사용자 설정
	  boardVO.setBoardTitle(boardTitle);
	  boardVO.setBoardContent(boardContent);
	  boardVO.setBoardType(boardType); // 정수형으로 바인딩

	  int result = boardService.insert(boardVO);
	  
	  if(result > 0){
	    return "redirect:qnaList.do?boardNo=" + boardVO.getBoardNo() + "&boardType=" + boardVO.getBoardType();
	  }else{
	    return "redirect:qnaWrite.do?boardType=" + boardVO.getBoardType();
	  }
	}
	
	/* GET qnaModify */
	@RequestMapping(value="/qnaModify.do", method=RequestMethod.GET)
	public String qnaModify(Principal principal, Model model, @RequestParam("boardNo") int boardNo) {
	  String loginUser = principal.getName(); // 로그인 사용자 ID
	  BoardVO vo = boardService.selectOne(boardNo); // 게시글 조회

	  if(vo == null){ return "redirect:qnaList.do"; }// 게시글이 존재하지 않을 경우 목록으로 리디렉트
	  if(!loginUser.equals(vo.getUserId())){ return "redirect:qnaList.do?BoardType=" + vo.getBoardType(); }// 작성자와 로그인 사용자가 다르면 리디렉트

	  model.addAttribute("vo", vo); // 뷰에 게시글 정보 전달
	  return "board/qnaModify"; // 수정 폼 JSP
	}
	
	/* POST qnaModifyOk */
	@RequestMapping(value="/qnaModifyOk.do", method=RequestMethod.POST)
	public String qnaModifyOk(BoardVO boardVO) {
	  int result = boardService.update(boardVO);

	  if(result > 0){
	    System.out.println("수정성공");
	  }else{
	    System.out.println("수정실패");
	  }

	  return "redirect:qnaList.do?boardType=" + boardVO.getBoardType();
	}
	
	/* GET qnaView */
	@RequestMapping(value="/qnaView.do", method = RequestMethod.GET)
	public String qnaView(Model model, @RequestParam("boardNo") int boardNo) {
	  
	  BoardVO vo = boardService.selectOne(boardNo);

	  if(vo == null){ return "redirect:/qnaList.do"; }// 게시글이 존재하지 않을 경우 목록으로 리디렉트

	  model.addAttribute("vo", vo);
	  return "board/qnaView";
	}
	
	/* GET qnaDelete */
	@RequestMapping(value="/qnaDelete.do",method=RequestMethod.POST)
	public String qnaDelete(int boardNo) {
		
	  int result = boardService.changeState(boardNo);
		
	  return "redirect:qnaList.do";
	}
	
	/*-----------------------------------------------------------------------------------------------------*/
	
	/* GET eventList */
	@RequestMapping(value="/eventList.do", method = RequestMethod.GET)
	public String eventList(Model model, SearchVO searchVO,
							            @RequestParam(value="nowpage",required = false,defaultValue="1")int nowpage) {
	  
	  if(searchVO.getBoardType()== null){ searchVO.setBoardType(3); }
	  
	  int total = boardService.boardListSearch(searchVO);
	  
	  System.out.println("전체 게시글 수: " + total);
		
	  PagingUtil paging = new PagingUtil(nowpage, total, 5);
	
	  searchVO.setStart(paging.getStart());
	  searchVO.setPerPage(paging.getPerPage());

	  List<BoardVO> eventList = boardService.eventList(searchVO);
		
	  // 번호 계산 및 설정
	  int displayNo = total - (nowpage - 1) * paging.getPerPage();
	  for(BoardVO vo : eventList){
	    vo.setDisplayNo(displayNo--); // 각 게시물 번호 설정
      vo.setBoardTitle(restoreSanitizedInput(vo.getBoardTitle()));
      vo.setBoardContent(restoreSanitizedInput(vo.getBoardContent()));
	  }
		
	  model.addAttribute("eventList",eventList);
	  model.addAttribute("paging",paging);
	  
	  System.out.println("넘어온 boardType: " + searchVO.getBoardType());

    return "board/eventList";
	}
	
	/* GET eventWrite */
	@RequestMapping(value="/eventWrite.do", method = RequestMethod.GET)
	public String eventWrite() {
	  return "board/eventWrite";
	}
	
	/* POST eventWriteOk */
	@RequestMapping(value = "/eventWriteOk.do", method = RequestMethod.POST)
	public String eventWriteOk(BoardVO boardVO, Principal principal) {

	  boardVO.setUserId(principal.getName());

	  int result = boardService.insert(boardVO);

	  if(result > 0){
      return "redirect:eventList.do";
    }else{
      return "redirect:eventWrite.do?boardType=3";
    }
	}

	/* GET qnaModify */
	@RequestMapping(value="/eventModify.do", method=RequestMethod.GET)
	public String eventModify(Principal principal, Model model, @RequestParam("boardNo") int boardNo) {
	  String loginUser = principal.getName(); // 로그인 사용자 ID
	  BoardVO vo = boardService.selectOne(boardNo); // 게시글 조회

	  if(vo == null){ return "redirect:eventList.do"; }// 게시글이 존재하지 않을 경우 목록으로 리디렉트
	  if(!loginUser.equals(vo.getUserId())){ return "redirect:eventList.do?BoardType=" + vo.getBoardType(); }// 작성자와 로그인 사용자가 다르면 리디렉트

	  model.addAttribute("vo", vo); // 뷰에 게시글 정보 전달
	  return "board/eventModify"; // 수정 폼 JSP
	}
	
	/* POST eventModifyOk */
	@RequestMapping(value="/eventModifyOk.do", method=RequestMethod.POST)
	public String eventModifyOk(BoardVO boardVO) {
	  int result = boardService.update(boardVO);

	  if(result > 0){
	    System.out.println("수정성공");
	  }else{
	    System.out.println("수정실패");
	  }

	  return "redirect:eventList.do?boardType=" + boardVO.getBoardType();
	}
	
	 /* GET eventView */
  @RequestMapping(value="/eventView.do", method = RequestMethod.GET)
  public String eventView(Model model, @RequestParam("boardNo") int boardNo) {
    
	  boardService.updateHit(boardNo); // 조회수 증가
    BoardVO vo = boardService.selectOne(boardNo);

    if(vo == null){ return "redirect:/eventList.do"; }// 게시글이 존재하지 않을 경우 목록으로 리디렉트

    model.addAttribute("vo", vo);
    return "board/eventView";
  }
  
  /* GET eventDelete */
  @RequestMapping(value="/eventDelete.do",method=RequestMethod.POST)
  public String eventDelete(int boardNo) {
    
    int result = boardService.changeState(boardNo);
    
    return "redirect:eventList.do";
  }
	
  /*-----------------------------------------------------------------------------------------------------*/
  
  /* GET showSearchBookPopup */
  @GetMapping("/popup/bookPopup.do")
  public String showSearchBookPopup() {
      return "popup/bookPopup";
  }

  /* GET searchBooks */
  @GetMapping("/api/searchBooks.do")
  @ResponseBody
  public List<Map<String, Object>> searchBooks(@RequestParam("keyword") String keyword) {
    List<Map<String, Object>> bookList = bookService.searchBooksForPopup(keyword); 
    return bookList;
}
  
	/* 특수문자 input */
	private String restoreSanitizedInput(String input){
	  
    if(input == null){ return null; }
    input = input
      .replaceAll("&lt;", "<")
      .replaceAll("&gt;", ">")
      .replaceAll("&quot;", "\"")
      .replaceAll("&#x27;", "'")
      .replaceAll("&amp;", "&")
      .replaceAll("<br>", "\n");
      
    return input;
  }
}