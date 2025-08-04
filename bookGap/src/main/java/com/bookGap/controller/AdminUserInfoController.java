package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.AdminUserInfoService;
import com.bookGap.vo.UserInfoVO;

@Controller 
public class AdminUserInfoController {
	
	@Autowired
	private AdminUserInfoService adminUserInfoService;
	
	@GetMapping("admin/adminUserInfo.do")
	public String adminUserInfo(Model model) {
	    List<UserInfoVO> getAllUser = adminUserInfoService.getAllUser();
	    model.addAttribute("getAllUser", getAllUser);

	    return "admin/adminUserInfo";
	}
	
	@PostMapping("/admin/updateUser")
	@ResponseBody
	public ResponseEntity<String> updateUser(@RequestBody UserInfoVO user) {
	    try {
	    	adminUserInfoService.updateUser(user);
	        return ResponseEntity.ok("success");
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
	    }
	}

}
