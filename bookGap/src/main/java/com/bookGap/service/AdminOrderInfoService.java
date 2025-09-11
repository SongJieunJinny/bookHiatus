package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.OrderVO;

public interface AdminOrderInfoService {
	List<OrderVO> getAllUserOrders();
	OrderVO getOrderDetail(int orderId);
	int updateUserOrderAndPayment(int orderId, int orderStatus, int paymentStatus, String courier, String invoice);
	List<OrderVO> getAllGuestOrders();
	OrderVO getGuestOrderDetail(int orderId);
	int updateGuestOrderAndPayment(int orderId, int orderStatus, int paymentStatus, String courier, String invoice);
	

}
