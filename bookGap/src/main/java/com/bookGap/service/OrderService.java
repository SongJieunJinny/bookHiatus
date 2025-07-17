package com.bookGap.service;

import com.bookGap.vo.BookVO;
import com.bookGap.vo.UserAddressVO;

public interface OrderService {
  public BookVO getBookByIsbn(String isbn);
  
  public UserAddressVO getDefaultAddress(String userId);

}