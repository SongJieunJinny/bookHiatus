package com.bookGap.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.CartVO;
import com.bookGap.vo.MypageVO;

@Repository
public class CartDAO {
	
	@Autowired
	private SqlSession sqlSession;
	
	 private final String namespace = "com.bookGap.mapper.CartMapper.";

	 public List<CartVO> getCartByUser(String userId) {
	        return sqlSession.selectList(namespace + "getCartByUser", userId); 
	    }

	    public int insertCartItem(CartVO vo) {
	        return sqlSession.insert(namespace + "insertCartItem", vo);
	    }

	    public int updateCartCount(int cartNo, int count) {
	        CartVO vo = new CartVO();
	        vo.setCartNo(cartNo);
	        vo.setCount(count);
	        return sqlSession.update(namespace + "updateCartCount", vo);
	    }

	    public int deleteCartItem(int cartNo) {
	        return sqlSession.delete(namespace + "deleteCartItem", cartNo);
	    }

	 // 중복 ISBN/bookNo 있는지 확인
	    public Integer findCartNoByUserAndBook(String userId, int bookNo) {
	        return sqlSession.selectOne(namespace + "findCartNoByUserAndBook",
	                Map.of("userId", userId, "bookNo", bookNo));
	    }

	    // 기존 항목 수량 증가
	    public int incrementCartCount(int cartNo, int addCount) {
	        return sqlSession.update(namespace + "incrementCartCount",
	                Map.of("cartNo", cartNo, "addCount", addCount));
	    }

	    public String addOrUpdateCart(CartVO vo) {
	        Integer existingCartNo = findCartNoByUserAndBook(vo.getUserId(), vo.getBookNo());
	        if (existingCartNo != null) {
	            updateCartCount(existingCartNo, vo.getCount()); // 덮어쓰기
	            return "EXISTING_UPDATED";
	        } else {
	            insertCartItem(vo);
	            return "DB_OK";
	        }
	    }
	    
	    public Integer getCartCountByUserAndBook(String userId, int bookNo) {
	        return sqlSession.selectOne(namespace + "getCartCountByUserAndBook", 
	            Map.of("userId", userId, "bookNo", bookNo));
	    }
	    
	
}
