package com.bookGap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.bookGap.service.AdminRefundService;



@Controller
public class adminRefundController {
	
	@Autowired
    private AdminRefundService adminRefundService;
}
