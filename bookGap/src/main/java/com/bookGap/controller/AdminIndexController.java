package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.bookGap.service.AdminBookService;
import com.bookGap.service.AdminSalesService;
import com.bookGap.service.AdminScheduleService;
import com.bookGap.service.AdminUserInfoService;
import com.bookGap.service.BookService;
import com.bookGap.service.ProductApiService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.UserInfoVO;

@Controller
public class AdminIndexController {
    @Autowired
    private AdminSalesService adminSalesService;

    @Autowired
    private AdminScheduleService adminScheduleService;
	
	@GetMapping("admin/adminIndex.do")
	public String adminIndex(Model model) {
		model.addAttribute("dailyStats", adminSalesService.getDailySales());
        model.addAttribute("scheduleStats", adminScheduleService.getScheduleCountByWeekday());
		return "admin/adminIndex";
	}
	
	@GetMapping("admin/err401.do")
	public String err401() {
	
		return "admin/err401";
	}
	
	@GetMapping("admin/err404.do")
	public String err404() {
	
		return "admin/err404";
	}
	
	@GetMapping("admin/err500.do")
	public String err500() {
	
		return "admin/err500";
	}
	
	
} 
