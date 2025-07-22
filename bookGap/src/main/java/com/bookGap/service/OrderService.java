package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.BookVO;
import com.bookGap.vo.UserAddressVO;

public interface OrderService {
  public BookVO getBookByIsbn(String isbn);
  
  public UserAddressVO getDefaultAddress(String userId);
  
  public List<UserAddressVO> getAddressListByUserId(String userId);
  
  public void addAddress(UserAddressVO address);
  
  public void deleteAddress(int userAddressId);


}