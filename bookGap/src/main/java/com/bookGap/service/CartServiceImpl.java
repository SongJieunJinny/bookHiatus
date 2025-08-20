package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.CartDAO;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.CartVO;
@Service
public class CartServiceImpl implements CartService {
	@Autowired
    private CartDAO cartDAO;

	@Override
    public List<CartVO> getCartByUser(String userId) {
        return cartDAO.getCartByUser(userId);
    }

    @Override 
    public boolean addCartItem(CartVO vo) {
        return cartDAO.insertCartItem(vo) > 0;
    }

    @Override
    public boolean updateCartCount(int cartNo, int count) {
        return cartDAO.updateCartCount(cartNo, count) > 0;
    }

    @Override
    public boolean deleteCartItem(int cartNo) {
        return cartDAO.deleteCartItem(cartNo) > 0;
    }

    @Override
    public String addOrUpdateCartItem(CartVO vo) {
        return cartDAO.addOrUpdateCart(vo);  // DB_OK 또는 EXISTING_UPDATED 반환
    }
    
    @Override
    public Integer getCartCountByUserAndBook(String userId, int bookNo) {
        return cartDAO.getCartCountByUserAndBook(userId, bookNo);
    }
    
    @Override
   public   BookVO findByIsbn(String isbn) {
    	 return cartDAO.findByIsbn(isbn);
    }

}
