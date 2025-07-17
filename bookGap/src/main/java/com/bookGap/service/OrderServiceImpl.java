package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.OrderDAO;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.UserAddressVO;

@Service
public class OrderServiceImpl implements OrderService {
  
  @Autowired
  private OrderDAO orderDAO;

  @Override
  public BookVO getBookByIsbn(String isbn) {
    return orderDAO.findBookByIsbn(isbn);
  }

  @Override
  public UserAddressVO getDefaultAddress(String userId) {
    return orderDAO.findDefaultAddressByUserId(userId);
  }

}