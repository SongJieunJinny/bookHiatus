package com.bookGap.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.OrderDAO;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.OrderVO;
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
  public List<BookVO> getBooksByIsbnList(List<String> isbns) {
    if (isbns == null || isbns.isEmpty()) {
      return new ArrayList<>(); // 비어있는 리스트는 DB 조회 없이 바로 반환
    }
    return orderDAO.selectBooksByIsbnList(isbns);
  }

  @Override
  public UserAddressVO getDefaultAddress(String userId) {
    return orderDAO.findDefaultAddressByUserId(userId);
  }

  @Override
  public List<UserAddressVO> getAddressListByUserId(String userId) {
    return orderDAO.findAddressListByUserId(userId);
  }

  @Override
  public void addAddress(UserAddressVO address) {
    orderDAO.addAddress(address);
  }
  
  @Override
  public void deleteAddress(int userAddressId) {
    orderDAO.deleteAddress(userAddressId);
  }

  @Override
  public List<OrderVO> getOrdersByUserId(String userId) {
    return orderDAO.getOrdersByUserId(userId);
  }

}