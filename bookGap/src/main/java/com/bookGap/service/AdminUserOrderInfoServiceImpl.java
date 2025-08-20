package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.AdminOrderDAO;
import com.bookGap.dao.UserDAO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.UserInfoVO;



@Service
public class AdminUserOrderInfoServiceImpl  implements  AdminUserOrderInfoService {
	 @Autowired
	 private AdminOrderDAO adminOrderDAO;
	 
	 @Override
	 public List<OrderVO> getAllUserOrders() {
	     return adminOrderDAO.selectAllUserOrders();
	 }
	 
	 @Override
	    public OrderVO getOrderDetail(int orderId) {
			OrderVO order = adminOrderDAO.getOrderInfoWithPayment(orderId);
	        if (order != null) {
	            List<OrderDetailVO> details = adminOrderDAO.getOrderDetailsByOrderId(orderId);
	            order.setOrderDetails(details);
	        }
	        return order;
	    }
	 
	


	
}
