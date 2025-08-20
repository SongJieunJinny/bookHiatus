package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.OrderVO;
import com.bookGap.vo.UserInfoVO;

public interface AdminUserOrderInfoService {
	List<OrderVO> getAllUserOrders();
	OrderVO getOrderDetail(int orderId);
	
	

}
