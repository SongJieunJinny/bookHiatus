package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.AdminBookService;
import com.bookGap.service.AdminUserOrderInfoService;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;

@Controller
public class AdminOrderController {
	@Autowired
    private AdminUserOrderInfoService adminUserOrderInfoService;
	
	@GetMapping( "/admin/adminUserOrderInfo.do")
	public String adminOrder(Model model) {
		
		    List<OrderVO> orderList = adminUserOrderInfoService.getAllUserOrders();
		    model.addAttribute("orderList", orderList);
		return "admin/adminUserOrderInfo";
	}
	
	@GetMapping("/admin/adminUserOrderInfo/getOrderDetail.do")
	@ResponseBody
	public OrderVO getOrderDetail(@RequestParam("orderId") int orderId) {
		OrderVO order = adminUserOrderInfoService.getOrderDetail(orderId);

	    System.out.println("== 주문 상세 요청 ==");
	    System.out.println("orderId: " + orderId);
	    
	    if (order != null) {
	        System.out.println("주문 정보: " + order);
	        if (order.getOrderDetails() != null) {
	            System.out.println("주문 상세 항목 수: " + order.getOrderDetails().size());
	            for (OrderDetailVO detail : order.getOrderDetails()) {
	                System.out.println("상세 항목: " + detail);
	                if (detail.getBook() != null) {
	                    System.out.println("도서 정보: " + detail.getBook().getTitle());
	                }
	            }
	        } else {
	            System.out.println("주문 상세 항목이 null입니다.");
	        }
	    } else {
	        System.out.println("해당 주문이 존재하지 않습니다.");
	    }

	    return order;
	}

}
