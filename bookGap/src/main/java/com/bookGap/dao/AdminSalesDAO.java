package com.bookGap.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.SalesVO;

@Repository
public class AdminSalesDAO {
	@Autowired
	private SqlSession sqlSession;
	
	 private final String namespace = "com.bookGap.mapper.SalesMapper.";
	 
	 public List<Map<String, Object>> getDailySales() {
	        return sqlSession.selectList(namespace + "getDailySales");
	    }

	    public List<Map<String, Object>> getBookSales() {
	        return sqlSession.selectList(namespace + "getBookSales");
	    }

	    public List<SalesVO> getSalesLog() {
	        return sqlSession.selectList(namespace + "getSalesLog");
	    }
}
