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
import com.bookGap.util.PagingUtil;
import com.bookGap.vo.BoardVO;
import com.bookGap.vo.SearchVO;

@Controller
public class BoardController {

	@Autowired 
    private BoardService boardService;
	
	/* GET noticeList */
	@RequestMapping(value="/noticeList.do", method = RequestMethod.GET)
	public String noticeList(Model model, SearchVO searchVO
							,@RequestParam(value="nowpage"
							,required = false
							,defaultValue="1")int nowpage) {
	  
	  if (searchVO.getBoardType()== null) {
		searchVO.setBoardType(1); // 공지사항 타입 기본값
	  }
	  
	  int total = boardService.boardListSearch(searchVO);
	  
	  System.out.println("전체 게시글 수: " + total);
		
	  PagingUtil paging = new PagingUtil(nowpage, total, 5);
		
	  searchVO.setStart(paging.getStart());
	  searchVO.setPerPage(paging.getPerPage());
		
	  List<BoardVO> list=boardService.list(searchVO);
		
	  // 번호 계산 및 설정
	  int displayNo = total - (nowpage - 1) * paging.getPerPage();
	  for(BoardVO vo : list) {
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
	public String noticeWriteOk(BoardVO boardVO,
	                            Principal principal,
	                            @RequestParam("boardTitle") String boardTitle,
	                            @RequestParam("boardContent") String boardContent,
	                            @RequestParam("boardType") int boardType) {
	    
	  boardVO.setUserId(principal.getName());  // 로그인 사용자 설정
	  boardVO.setBoardTitle(boardTitle);
	  boardVO.setBoardContent(boardContent);
	  boardVO.setBoardType(boardType); // 정수형으로 바인딩

	  int result = boardService.insert(boardVO);
	  if (result > 0) {
	    return "redirect:noticeList.do?boardNo=" + boardVO.getBoardNo() + "&boardType=" + boardVO.getBoardType();
	  } else {
	    return "redirect:noticeWrite.do?boardType=" + boardVO.getBoardType();
	  }
	}
	
	/* GET noticeView */
	@RequestMapping(value="/noticeView.do", method = RequestMethod.GET)
	public String noticeView(@RequestParam("boardNo") int boardNo, Model model) {
	  
	  boardService.updateHit(boardNo); // 조회수 증가
	  BoardVO vo = boardService.selectOne(boardNo);

	  if (vo == null) {
        System.out.println("해당 게시글이 없습니다. boardNo=" + boardNo);
        return "redirect:/noticeList.do";
	  }

	  model.addAttribute("vo", vo);
	  return "board/noticeView";
	}
	
	/* GET noticeModify */
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
	
	/* POST noticeModifyOk */
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
	
	/* GET noticeDelete */
	@RequestMapping(value="/noticeDelete.do",method=RequestMethod.POST)
	public String noticeDelete(int boardNo) {
		
	  int result = boardService.changeState(boardNo);
		
	  return "redirect:noticeList.do";
	}

	/*-----------------------------------------------------------------------------------------------------*/
	
	/* GET qnaList */
	@RequestMapping(value="/qnaList.do", method = RequestMethod.GET)
	public String qnaList(Model model,SearchVO searchVO
						 ,@RequestParam(value="nowpage"
						 ,required = false
						 ,defaultValue="1")int nowpage) { 

	  int total = boardService.boardListSearch(searchVO);
		
	  PagingUtil paging = new PagingUtil(nowpage, total, 5);
		
	  searchVO.setStart(paging.getStart());
	  searchVO.setPerPage(paging.getPerPage());
	  
	  System.out.println("🚀 최종적으로 MyBatis에 전달하는 boardType: " + searchVO.getBoardType());

	  List<BoardVO> qanList = boardService.qnaList(searchVO);
	  
	  System.out.println("💡 DB에서 가져온 리스트:");
	  for (BoardVO vo : qanList) {
	      System.out.println("게시글 번호: " + vo.getBoardNo() + ", 제목: " + vo.getBoardTitle() + ", boardType: " + vo.getBoardType());
	  }
		
	  // 번호 계산 및 설정
	  int displayNo = total - (nowpage - 1) * paging.getPerPage();
	  for(BoardVO vo : qanList) {
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
	public String qnaWrite(@RequestParam("boardType") int boardType, Model model) {
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
	  if (result > 0) {
	    return "redirect:qnaList.do?boardNo=" + boardVO.getBoardNo() + "&boardType=" + boardVO.getBoardType();
	  } else {
	    return "redirect:qnaWrite.do?boardType=" + boardVO.getBoardType();
	  }
	}
	
	/* GET qnaModify */
	@RequestMapping(value="/qnaModify.do", method=RequestMethod.GET)
	public String qnaModify(@RequestParam("boardNo") int boardNo, Principal principal, Model model) {
	  String loginUser = principal.getName(); // 로그인 사용자 ID
	  BoardVO vo = boardService.selectOne(boardNo); // 게시글 조회

	  if (vo == null) {
		// 게시글이 존재하지 않을 경우 목록으로 리디렉트
	    return "redirect:qnaList.do";
	  }

	  if (!loginUser.equals(vo.getUserId())) {
	    // 작성자와 로그인 사용자가 다르면 리디렉트
	    return "redirect:qnaList.do?BoardType=" + vo.getBoardType();
	  }

	  model.addAttribute("vo", vo); // 뷰에 게시글 정보 전달
	  return "board/qnaModify"; // 수정 폼 JSP
	}
	
	/* POST qnaModifyOk */
	@RequestMapping(value="/qnaModifyOk.do", method=RequestMethod.POST)
	public String qnaModifyOk(BoardVO boardVO) {
	  int result = boardService.update(boardVO);

	  if(result > 0) {
	    System.out.println("수정성공");
	  } else {
	    System.out.println("수정실패");
	  }

	  return "redirect:qnaList.do?boardType=" + boardVO.getBoardType();
	}
	
	/* GET qnaView */
	@RequestMapping(value="/qnaView.do", method = RequestMethod.GET)
	public String qnaView(@RequestParam("boardNo") int boardNo, Model model) {
	  
	  BoardVO vo = boardService.selectOne(boardNo);

	  if (vo == null) {
        System.out.println("해당 게시글이 없습니다. boardNo=" + boardNo);
        return "redirect:/qnaList.do";
	  }

	  model.addAttribute("vo", vo);
	  return "board/qnaView";
	}
	
	/* GET qnaDelete */
	@RequestMapping(value="/qnaDelete.do",method=RequestMethod.POST)
	public String qnaDelete(int boardNo) {
		
	  int result = boardService.changeState(boardNo);
		
	  return "redirect:qnaList.do";
	}
	
	
	
	/* 특수문자 input */
	private String restoreSanitizedInput(String input) {
      if(input == null) {
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
