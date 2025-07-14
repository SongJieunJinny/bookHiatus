package com.bookGap.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.CommentRatingService;
import com.bookGap.vo.CommentRatingVO;

@RequestMapping(value="/comment")
@Controller
public class CommentRatingController {
  
  @Autowired
  private CommentRatingService commentRatingService;
  
  /* Rating 저장 POST */
  @ResponseBody
  @RequestMapping(value = "/saveRating.do", method = RequestMethod.POST)
  public String saveRating(CommentRatingVO vo, Principal principal) {
    vo.setUserId(principal.getName());
    return commentRatingService.upsertRating(vo); // INSERT or UPDATE 자동 처리
  }

  /* Rating 수정 POST */
  @ResponseBody
  @RequestMapping(value = "/updateRating.do", method = RequestMethod.POST)
    public String updateRating(CommentRatingVO vo, Principal principal) {
      vo.setUserId(principal.getName());
      return commentRatingService.updateRating(vo);
  }

  /* Rating 조회 POST */
  @ResponseBody
  @RequestMapping(value = "/getUserRating.do", method = RequestMethod.GET)
  public CommentRatingVO getUserRating(@RequestParam("commentNo") int commentNo,
                                       @RequestParam("isbn") String isbn,
                                       Principal principal) {
    String userId = principal.getName();
    return commentRatingService.getUserRating(commentNo, isbn, userId);
  }

}