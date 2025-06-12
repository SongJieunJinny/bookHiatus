package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.ProductApiVO;
import com.bookGap.vo.SearchVO;

public interface BookService {
	 List<ProductApiVO> getBooksWithProductInfo();
	 List<String> getDistinctCategories();
	 List<ProductApiVO> getBooksByCategory(String category);
	 List<ProductApiVO> getBooksPaging(SearchVO searchVO);
	 List<ProductApiVO> getBooksByCategoryPaging(SearchVO searchVO);

	 int getTotalBookCount(SearchVO searchVO);
	 int getTotalByCategory(SearchVO searchVO);

}
