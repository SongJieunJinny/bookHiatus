package com.bookGap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.bookGap.service.AdminSalesService;

@Controller
public class AdminSalesController {
	
	@Autowired
    private AdminSalesService adminSalesService;
	
	@GetMapping("admin/adminSales.do")
	public String adminSales(Model model) {
		 
	    model.addAttribute("dailyStats", adminSalesService.getDailySales());
        model.addAttribute("bookStats", adminSalesService.getBookSales());
        model.addAttribute("salesLogs", adminSalesService.getSalesLog());
	
		return "admin/adminSales";
	}

}
