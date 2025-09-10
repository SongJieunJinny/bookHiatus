package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookGap.dao.AdminOrderDAO;
import com.bookGap.vo.AdminOrderUpdateRequestVO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;

@Service
public class AdminOrderInfoServiceImpl  implements  AdminOrderInfoService {
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
	 
	 @Override
	 @Transactional
	 public int updateUserOrderAndPayment(int orderId, int orderStatus, int paymentStatus, String courier, String invoice) {
	     AdminOrderUpdateRequestVO vo = new AdminOrderUpdateRequestVO();
	     vo.setOrderId(orderId);
	     vo.setOrderStatus(orderStatus);
	     vo.setPaymentStatus(paymentStatus);
	     vo.setCourier(courier);
	     vo.setInvoice(invoice);

	     int updatedOrder = adminOrderDAO.updateUserOrder(vo);
	     int updatedPayment = adminOrderDAO.updateUserPaymentStatus(vo);

	     return (updatedOrder > 0 || updatedPayment > 0) ? 1 : 0;
	 }
	 
	 @Override
	 public List<OrderVO> getAllGuestOrders() {
	     return adminOrderDAO.selectAllGuestOrders();
	 }

	 @Override
	 public OrderVO getGuestOrderDetail(int orderId) {
	     OrderVO order = adminOrderDAO.getGuestOrderInfoWithPayment(orderId);
	     if (order != null) {
	         List<OrderDetailVO> details = adminOrderDAO.getOrderDetailsByOrderId(orderId);
	         order.setOrderDetails(details);
	     }
	     return order;
	 }

	 @Override
	 @Transactional
	 public int updateGuestOrderAndPayment(int orderId, int orderStatus, int paymentStatus, String courier, String invoice) {
	     AdminOrderUpdateRequestVO vo = new AdminOrderUpdateRequestVO();
	     vo.setOrderId(orderId);
	     vo.setOrderStatus(orderStatus);
	     vo.setPaymentStatus(paymentStatus);
	     vo.setCourier(courier);
	     vo.setInvoice(invoice);

	     int updatedOrder = adminOrderDAO.updateGuestOrder(vo);
	     int updatedPayment = adminOrderDAO.updateGuestPaymentStatus(vo);

	     return (updatedOrder > 0 || updatedPayment > 0) ? 1 : 0;
	 }


	
}
