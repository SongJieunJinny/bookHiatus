package com.bookGap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bookGap.service.GuestService;

@RequestMapping(value="/guest")
@Controller 
public class GuestController {

  @Autowired
  private GuestService guestService;
  
  @RequestMapping(value="/guestOrder.do", method = RequestMethod.GET)
  public String guestOrder() {
    //System.out.println("GET /mypage.do");
    return "guest/guestOrder";
  }
}
