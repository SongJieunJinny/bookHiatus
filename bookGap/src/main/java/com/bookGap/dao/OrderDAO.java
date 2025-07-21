package com.bookGap.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.BookVO;
import com.bookGap.vo.UserAddressVO;

@Repository
public class OrderDAO {
  
  @Autowired
  private SqlSession sqlSession;
  
  private final String name_space = "com.bookGap.mapper.orderMapper.";
  
  public BookVO findBookByIsbn(String isbn) {
    return sqlSession.selectOne(name_space + "findBookByIsbn", isbn);
  }

  public UserAddressVO findDefaultAddressByUserId(String userId) {
    return sqlSession.selectOne(name_space + "findDefaultAddressByUserId", userId);
  }
  
  public List<UserAddressVO> findAddressListByUserId(String userId) {
    return sqlSession.selectList(name_space + "findAddressListByUserId", userId);
  }

}