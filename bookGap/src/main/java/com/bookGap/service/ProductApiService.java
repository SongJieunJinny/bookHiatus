package com.bookGap.service;

import com.bookGap.vo.ProductApiVO;

public interface ProductApiService {

	ProductApiVO fetchAndStoreBooksByCategory(String title);

}
