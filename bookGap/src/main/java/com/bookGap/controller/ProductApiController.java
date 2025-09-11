package com.bookGap.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bookGap.service.ProductApiService;
import com.bookGap.vo.ProductApiVO;

import lombok.RequiredArgsConstructor;
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/books")
public class ProductApiController {
	
	@Autowired
	public ProductApiService productApiService;
	
	@PostMapping("/search")
    public ResponseEntity<?> searchAndSave(@RequestParam("title") String title) {
        ProductApiVO book = productApiService.fetchAndStoreBooksByCategory(title);

        if (book != null) {
            return ResponseEntity.ok(book);
        } else {
            // 항상 JSON으로 응답
            Map<String, Object> response = new HashMap<>();
            response.put("error", "no_result");
            return ResponseEntity.ok(response);
        }
    }

    // 예외 처리 핸들러
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleError(Exception e) {
        e.printStackTrace(); // 로그 찍기
        Map<String, String> error = new HashMap<>();
        error.put("error", "server_error");
        return ResponseEntity.status(500).body(error);
    }
	

}
