package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bookGap.service.AdminBookService;
import com.bookGap.service.AdminUserInfoService;
import com.bookGap.service.ProductApiService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.UserInfoVO;

@Controller
public class adminIndexController {
	
	@Autowired
	private ProductApiService productApiService;
	@Autowired
    private AdminBookService adminBookService;
	@Autowired
	private AdminUserInfoService adminUserInfoService;
	
	
	@RequestMapping(value = "admin/adminIndex.do", method = RequestMethod.GET)
	public String adminIndex() {
	
		return "admin/adminIndex";
	}
	
	@RequestMapping(value = "admin/adminBook.do", method = RequestMethod.GET)
	public String adminBook(Model model) {
		
		List<BookVO> getAllBooks = adminBookService.getAllBooks();
		
		model.addAttribute("getAllBooks",getAllBooks);
	
		return "admin/adminBook";
	}
	@RequestMapping(value = "admin/adminOrder.do", method = RequestMethod.GET)
	public String adminOrder() {
	
		return "admin/adminOrder";
	}
	@RequestMapping(value = "admin/adminSchedule.do", method = RequestMethod.GET)
	public String adminSchedule() {
	
		return "admin/adminSchedule";
	}
	@RequestMapping(value = "admin/adminSales.do", method = RequestMethod.GET)
	public String adminSales() {
	
		return "admin/adminSales";
	}
	@RequestMapping(value = "admin/adminUserInfo.do", method = RequestMethod.GET)
	public String adminUserInfo(Model model) {
		List<UserInfoVO> getAllUser = adminUserInfoService.getAllUser();
		model.addAttribute("getAllUser",getAllUser);
	
		return "admin/adminUserInfo";
	}
	@RequestMapping(value = "admin/adminGuestOrderInfo.do", method = RequestMethod.GET)
	public String adminGuestOrderInfo() {
	
		return "admin/adminGuestOrderInfo";
	}
	
} 
