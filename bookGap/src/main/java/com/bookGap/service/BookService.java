package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.BookVO;
import com.bookGap.vo.ProductApiVO;
import com.bookGap.vo.SearchVO;

public interface BookService {
	 List<ProductApiVO> getBooksWithProductInfo();
	 List<String> getDistinctCategories();
	 List<ProductApiVO> getBooksByCategory(String category);
	 List<ProductApiVO> getBooksPaging(SearchVO searchVO);
	 List<ProductApiVO> getBooksByCategoryPaging(SearchVO searchVO);
	 BookVO getBookDetailByIsbn(String isbn);
	

	 int getTotalBookCount(SearchVO searchVO);
	 int getTotalByCategory(SearchVO searchVO);
	
	 public int getBookNoByIsbn(String isbn);
	 
	 List<ProductApiVO> getNewBooks();
	 
  //제목 또는 저자명으로 도서 검색
   List<ProductApiVO> searchBooksByKeyword(SearchVO searchVO);
   // 제목 또는 저자명으로 검색된 도서의 전체 개수 조회
   int getBookTotalCountByKeyword(SearchVO searchVO);

}