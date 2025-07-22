package com.bookGap.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class FaviconController {

	@RequestMapping("/favicon.ico")
    @ResponseBody
    public ResponseEntity<Void> disableFavicon() {
        // 내용 없이 204 No Content 응답
        return ResponseEntity.noContent().build();
    }
}