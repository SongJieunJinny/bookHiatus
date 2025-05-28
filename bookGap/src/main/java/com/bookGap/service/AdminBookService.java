package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.BookVO;

public interface AdminBookService {
	 	int insertBook(BookVO bookVO);
	    BookVO getBookByNo(int bookNo);
	    int updateBook(BookVO bookVO);
	    int deleteBook(int bookNo);
	    
	    boolean isIsbnExists(String isbn);
	    List<BookVO> getAllBooks();

}
