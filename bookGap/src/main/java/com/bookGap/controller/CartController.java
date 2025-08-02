package com.bookGap.controller;


import java.security.Principal;
import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import com.bookGap.service.BookService;

import com.bookGap.service.CartService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.CartVO;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;


@Controller
public class CartController {

	
	@Autowired
    private CartService  cartService;

	@Autowired
	public BookService bookService;
	
	// 장바구니 페이지
	@RequestMapping(value = "/product/cart.do", method = RequestMethod.GET)
	public String cartPage(Model model, Principal principal) {
	    if (principal != null) {
	        String userId = principal.getName();
	        List<CartVO> cartItems = cartService.getCartByUser(userId);
	        //System.out.println("[디버그] cartPage() 호출: userId=" + userId + ", cartItems=" + cartItems);

	        String cartItemsJson = "[]";
	        try {
	            cartItemsJson = new ObjectMapper().writeValueAsString(cartItems);
	        } catch (JsonProcessingException e) {
	            e.printStackTrace();
	        }

	        //System.out.println("[디버그] cartItemsJson=" + cartItemsJson);
	        model.addAttribute("cartItemsJson", cartItemsJson);
	    } else {
	       // System.out.println("[디버그] 비로그인 사용자, 빈 장바구니");
	        model.addAttribute("cartItemsJson", "[]");
	    }
	    return "product/cart";
	}

    // 비회원 → 로그인 시 LocalStorage → DB 마이그레이션
    @PostMapping("/product/syncCart.do")
    @ResponseBody
    public String syncCart(@RequestBody List<CartVO> items, Principal principal) {
    	 if (principal == null) return "NOT_LOGGED_IN";

    	    String userId = principal.getName();
    	    for (CartVO vo : items) {
    	        if (vo.getCount() <= 0) continue;  // 0개는 무시
    	        vo.setUserId(userId);
    	        cartService.addOrUpdateCartItem(vo);
    	    }
    	    return "SYNC_OK";
    }

    // 회원 장바구니 수량 업데이트
    @ResponseBody
    @RequestMapping(value = "/product/updateCart.do", method = RequestMethod.POST)
    public String updateCart(@RequestParam int cartNo, @RequestParam int count) {
        boolean result = cartService.updateCartCount(cartNo, count);
        return result ? "DB_UPDATED" : "DB_FAIL";
    }

    // 회원 장바구니 삭제
    @ResponseBody
    @RequestMapping(value = "/product/deleteCart.do", method = RequestMethod.POST)
    public String deleteCart(@RequestParam int cartNo) {
        boolean result = cartService.deleteCartItem(cartNo);
        return result ? "DB_DELETED" : "DB_FAIL";
    }

    // 로그인한 유저의 장바구니 개수 반환
    @ResponseBody
    @RequestMapping(value = "/product/getCartCount.do", method = RequestMethod.GET)
    public int getCartCount(Principal principal) {
        if (principal == null) {
            return 0;
        }
        return cartService.getCartByUser(principal.getName()).size();
    }

    // 최신 DB 장바구니 조회 (cartNo 포함)
    @ResponseBody
    @RequestMapping(value = "/product/getCartByUser.do", method = RequestMethod.GET)
    public List<CartVO> getCartByUserAjax(Principal principal) {
        if (principal == null) {
            return List.of();
        }
        return cartService.getCartByUser(principal.getName());
    }
    
    @PostMapping("/product/addOrUpdateCart.do")
    @ResponseBody
    public String addOrUpdateCart(@RequestBody CartVO vo, Principal principal) {
        if (principal == null) return "NOT_LOGGED_IN";
        vo.setUserId(principal.getName());
        return cartService.addOrUpdateCartItem(vo); // DB_OK 또는 EXISTING_UPDATED 반환
    }
    
    
    
    
    
}



