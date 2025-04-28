package com.bookGap.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.ProductApiVO;

@Repository
public class ProductApiDAO {
	
	@Autowired
	 private SqlSession sqlSession;
	  
	 public void insertProductApi(ProductApiVO book) {
	        sqlSession.insert("ProductApiMapper.insertProductApi", book);
	    }

	    public boolean existsByIsbn(String isbn) {
	        ProductApiVO result = sqlSession.selectOne("ProductApiMapper.selectProductApiByIsbn", isbn);
	        return result != null;
	    }
}
