package com.bookGap.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookGap.service.BoardService;
import com.bookGap.vo.BoardVO;
import com.bookGap.vo.SearchVO;

@Controller
public class BoardController {

	@Autowired
    private BoardService boardService;
	
	/* GET List */
	@RequestMapping(value="/noticeList.do", method = RequestMethod.GET)
	public String noticeList(Model model, SearchVO searchVO) {
		List<BoardVO> list=boardService.list(searchVO);
		model.addAttribute("list",list);
		
		System.out.println("받은 검색어: " + searchVO.getSearch_value());
		System.out.println("게시글 개수: " + list.size());
		return "board/noticeList";
	}
	
	/* GET Write */
	@RequestMapping(value="/noticeWrite.do", method = RequestMethod.GET)
	public String noticeWrite() {
		System.out.println("methodGET : board/noticeWrite.do");
		return "board/noticeWrite";
	}
	
	/* POST Write */
	@RequestMapping(value = "/noticeWriteOk.do", method = RequestMethod.POST)
	public String noticeWriteOk(BoardVO boardVO,
	                            Principal principal,
	                            @RequestParam("boardTitle") String boardTitle,
	                            @RequestParam("boardContent") String boardContent,
	                            @RequestParam("boardType") int boardType) {
	    
	  boardVO.setUserId(principal.getName());  // 로그인 사용자 설정
	  boardVO.setBoardTitle(boardTitle);
	  boardVO.setBoardContent(boardContent);
	  boardVO.setBoardType(boardType); // 정수형으로 바인딩

	  int result = boardService.noticeInsert(boardVO);
	  if (result > 0) {
	    return "redirect:noticeList.do?boardNo=" + boardVO.getBoardNo() + "&boardType=" + boardVO.getBoardType();
	  } else {
	    return "redirect:noticeWrite.do?boardType=" + boardVO.getBoardType();
	  }
	}
	
	/* GET View */
	@RequestMapping(value="/noticeView.do", method = RequestMethod.GET)
	public String noticeView(@RequestParam("boardNo") int boardNo, Model model) {
	    
	  BoardVO vo = boardService.selectOne(boardNo);

	  if (vo == null) {
        System.out.println("해당 게시글이 없습니다. boardNo=" + boardNo);
        return "redirect:/noticeList.do";
	  }

	  model.addAttribute("vo", vo);
	  return "board/noticeView";
	}
	
	/* GET Modify */
	@RequestMapping(value="/noticeModify.do", method=RequestMethod.GET)
	public String noticeModify(@RequestParam("boardNo") int boardNo, Principal principal, Model model) {
	  String loginUser = principal.getName(); // 로그인 사용자 ID
	  BoardVO vo = boardService.selectOne(boardNo); // 게시글 조회

	  if (vo == null) {
		  // 게시글이 존재하지 않을 경우 목록으로 리디렉트
	      return "redirect:noticeList.do";
	  }

	  if (!loginUser.equals(vo.getUserId())) {
	    // 작성자와 로그인 사용자가 다르면 리디렉트
	    return "redirect:noticeList.do?BoardType=" + vo.getBoardType();
	  }

	  model.addAttribute("vo", vo); // 뷰에 게시글 정보 전달
	  return "board/noticeModify"; // 수정 폼 JSP
	}
	
	/* POST Modify */
	@RequestMapping(value="/noticeModifyOk.do", method=RequestMethod.POST)
	public String noticeModifyOk(BoardVO boardVO) {
	    int result = boardService.update(boardVO);

	    if(result > 0) {
	        System.out.println("수정성공");
	    } else {
	        System.out.println("수정실패");
	    }

	    return "redirect:noticeList.do?boardType=" + boardVO.getBoardType();
	}
	
	/* GET Delete */
	@RequestMapping(value="/noticeDelete.do",method=RequestMethod.POST)
	public String noticeDelete(int boardNo) {
		
		int result = boardService.changeState(boardNo);
		
		return "redirect:noticeList.do";
	}


	
}
