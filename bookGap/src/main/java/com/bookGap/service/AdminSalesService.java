package com.bookGap.service;

import java.util.List;
import java.util.Map;

import com.bookGap.vo.SalesVO;

public interface AdminSalesService {
	
	public List<Map<String, Object>> getDailySales();  
	public List<Map<String, Object>> getBookSales();  
	public List<SalesVO> getSalesLog();

}
