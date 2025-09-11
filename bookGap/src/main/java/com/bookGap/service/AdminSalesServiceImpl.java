package com.bookGap.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.AdminSalesDAO;
import com.bookGap.vo.SalesVO;

@Service
public class AdminSalesServiceImpl implements  AdminSalesService {
	
	@Autowired
    private AdminSalesDAO adminSalesDAO;
	
	@Override
    public List<Map<String, Object>> getDailySales() {
        return adminSalesDAO.getDailySales();
    }

    @Override
    public List<Map<String, Object>> getBookSales() {
        return adminSalesDAO.getBookSales();
    }

    @Override
    public List<SalesVO> getSalesLog() {
        return adminSalesDAO.getSalesLog();
    }

}
