package com.bookGap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.CommentLoveService;
import com.bookGap.vo.CommentLoveVO;

@RequestMapping(value="/comment")
@Controller
public class CommentLoveController {
  
  @Autowired
  private CommentLoveService commentLoveService;
  
/* toggleLove 좋아요 POST */
  
  @ResponseBody
  @RequestMapping(value = "/toggleLove.do", method = RequestMethod.POST)
    public String toggleLove(@RequestParam int commentNo,
                             @RequestParam String userId,
                             @RequestParam String isbn) {
      CommentLoveVO vo = new CommentLoveVO();
      vo.setCommentNo(commentNo);
      vo.setUserId(userId);
      vo.setIsbn(isbn);
  
      boolean liked = commentLoveService.isLovedByUser(vo);
      int result;
  
      if(liked){
        result = commentLoveService.deleteLove(vo);
        return result > 0 ? "unliked" : "fail";
      }else{
        result = commentLoveService.insertLove(vo);
        return result > 0 ? "liked" : "fail";
      }
    }

}
