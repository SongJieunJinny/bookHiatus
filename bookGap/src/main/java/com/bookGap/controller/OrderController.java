package com.bookGap.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bookGap.vo.BookVO;

@Controller
public class OrderController {
	
	@RequestMapping(value = "/order/orderDetails.do", method = RequestMethod.GET)
	public String orderDetails() {


		return "order/orderDetails";
	}

}
