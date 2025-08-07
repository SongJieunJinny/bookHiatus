package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.BookVO;

@Repository
public class AdminBookDAO {
	@Autowired
	private SqlSession sqlSession;
	
	private final String namespace = "com.bookGap.mapper.bookMapper.";
	    
	 public int insertBook(BookVO bookVO) {
	        return sqlSession.insert(namespace + "insertBook", bookVO);
	    }

	    public BookVO selectBookByNo(int bookNo) {
	        return sqlSession.selectOne(namespace + "selectBookByNo", bookNo);
	    }

	    public int updateBook(BookVO bookVO) {
	        return sqlSession.update(namespace + "updateBook", bookVO);
	    }

	    public int deleteBook(int bookNo) {
	        return sqlSession.delete(namespace + "deleteBook", bookNo);
	    }
	    
	    public boolean isIsbnExists(String isbn) {
	        Integer count = sqlSession.selectOne(namespace + "isIsbnExists", isbn);
	        return count != null && count > 0;
	    }
	    
	    public List<BookVO> selectAllBooks() {
	        return sqlSession.selectList(namespace + "selectAllBooks");
	    }
	    
	    
	    public int updateInventory(BookVO bookVO) {
	        return sqlSession.update(namespace +"updateInventory", bookVO);
	    }
	    
		public List<BookVO> adminInventoryManagementSelectAll() {
		    return sqlSession.selectList(namespace + "adminInventoryManagementSelectAll");
		}

}
