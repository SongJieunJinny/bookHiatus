package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.CartVO;

public interface CartService {
	List<CartVO> getCartByUser(String userId);             // 회원 장바구니 조회
    boolean addCartItem(CartVO vo);                        // 장바구니 추가 (단순)
    boolean updateCartCount(int cartNo, int count);        // 수량 수정
    boolean deleteCartItem(int cartNo);                    // 삭제
    String  addOrUpdateCartItem(CartVO vo);                // 중복 ISBN 자동 합산 + 삽입
    
}
