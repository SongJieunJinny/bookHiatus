package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.BookVO;
import com.bookGap.vo.ProductApiVO;
import com.bookGap.vo.SearchVO;

@Repository
public class BookDAO {
	
	@Autowired
	private SqlSession sqlSession;
	private final String namespace = "com.bookGap.mapper.bookMapper.";
	
	public List<ProductApiVO> selectBooksWithProductInfo() {
	    return sqlSession.selectList(namespace + "selectBooksWithProductInfo");
	}
	
	public List<String> selectDistinctCategories() {
	    return sqlSession.selectList(namespace + "selectDistinctCategories");
	}
	
	public List<ProductApiVO> selectBooksByCategory(String category) {
	    return sqlSession.selectList(namespace + "selectBooksByCategory", category);
	}
	
	public List<ProductApiVO> selectBooksPaging(SearchVO vo) {
	    return sqlSession.selectList(namespace + "selectBooksPaging", vo);
	}

	public List<ProductApiVO> selectBooksByCategoryPaging(SearchVO vo) {
	    return sqlSession.selectList(namespace + "selectBooksByCategoryPaging", vo);
	}

	public int getBookTotalCount(SearchVO vo) {
	    return sqlSession.selectOne(namespace + "getBookTotalCount", vo);
	}

	public int getBookTotalCountByCategory(SearchVO vo) {
	    return sqlSession.selectOne(namespace + "getBookTotalCountByCategory", vo);
	}
	
	public BookVO selectBookDetailByIsbn(String isbn) {
	    return sqlSession.selectOne(namespace + "selectBookDetailByIsbn", isbn);
	}
}
