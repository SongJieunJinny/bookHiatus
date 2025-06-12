package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.ProductApiVO;

public interface ProductApiService {

	ProductApiVO fetchAndStoreBooksByCategory(String title);
	//List<ProductApiVO> selectBookImg();

}
