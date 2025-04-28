package com.bookGap.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class adminIndexHeaderController {
	
	 @GetMapping("/include/adminHeader")
	    public String adminHeader() {
	        return "include/adminHeader";  // /WEB-INF/views/include/header.jsp
	    }

	    @GetMapping("/include/adminFooter")
	    public String adminFooter() {
	        return "include/adminFooter";
	    }
	    
	    @GetMapping("/include/adminNav")
	    public String adminNav() {
	        return "include/adminNav";  // /WEB-INF/views/include/header.jsp
	    }

	
}
