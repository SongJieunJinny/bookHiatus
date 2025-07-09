package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.AdminBookDAO;
import com.bookGap.vo.BookVO;

@Service
public class AdminBookServiceImpl  implements AdminBookService {
	 @Autowired
	    private AdminBookDAO adminBookDAO;

	    @Override
	    public int insertBook(BookVO bookVO) {
	        return adminBookDAO.insertBook(bookVO);
	    }

	    @Override
	    public BookVO getBookByNo(int bookNo) {
	        return adminBookDAO.selectBookByNo(bookNo);
	    }

	    @Override
	    public int updateBook(BookVO bookVO) {
	        return adminBookDAO.updateBook(bookVO);
	    }

	    @Override
	    public int deleteBook(int bookNo) {
	        return adminBookDAO.deleteBook(bookNo);
	    }
	    
	    @Override
	    public boolean isIsbnExists(String isbn) {
	        return adminBookDAO.isIsbnExists(isbn);
	    }
	    
	    @Override
	    public List<BookVO> getAllBooks() {
	        return adminBookDAO.selectAllBooks();
	    }
	    
	    @Override
	    public int updateInventory(BookVO bookVO) {
	        return adminBookDAO.updateInventory(bookVO);  // DAO의 updateInventory 호출
	    }

}
