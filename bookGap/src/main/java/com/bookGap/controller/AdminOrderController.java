package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.AdminBookService;
import com.bookGap.service.AdminOrderInfoService;
import com.bookGap.util.StringUtils;
import com.bookGap.vo.AdminOrderUpdateRequestVO;
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;

import lombok.Data;

@Controller
public class AdminOrderController {
	@Autowired
    private AdminOrderInfoService adminOrderInfoService;
	
	@GetMapping( "/admin/adminUserOrderInfo.do")
	public String adminOrder(Model model) {
		
		    List<OrderVO> orderList = adminOrderInfoService.getAllUserOrders();
		    model.addAttribute("orderList", orderList);
		return "admin/adminUserOrderInfo";
	}
	
	@GetMapping("/admin/adminUserOrderInfo/getOrderDetail.do")
	@ResponseBody
	public OrderVO getOrderDetail(@RequestParam("orderId") int orderId) {
		OrderVO order = adminOrderInfoService.getOrderDetail(orderId);

	   // System.out.println("== 주문 상세 요청 ==");
	    //System.out.println("orderId: " + orderId);
	    
	    if (order != null) {
	        //System.out.println("주문 정보: " + order);
	        if (order.getOrderDetails() != null) {
	            //System.out.println("주문 상세 항목 수: " + order.getOrderDetails().size());
	            for (OrderDetailVO detail : order.getOrderDetails()) {
	                //System.out.println("상세 항목: " + detail);
	                if (detail.getBook() != null) {
	                    //System.out.println("도서 정보: " + detail.getBook().getTitle());
	                }
	            }
	        } else {
	            //System.out.println("주문 상세 항목이 null입니다.");
	        }
	    } else {
	        //System.out.println("해당 주문이 존재하지 않습니다.");
	    }

	    return order;
	}
	


	
	 @PostMapping(value = "/admin/adminUserOrderInfo/updateUserOrder.do", consumes = "application/json", produces = "application/json")
	 @ResponseBody
	 public ResponseEntity<?> updateUserOrder(@RequestBody AdminOrderUpdateRequestVO req) {

		    // 1) 기본 검증
		    if (req.getOrderId() <= 0) {
		        return ResponseEntity.badRequest().body("{\"success\":false,\"message\":\"invalid orderId\"}");
		    }
		    if (req.getOrderStatus() < 1 || req.getOrderStatus() > 5) {
		        return ResponseEntity.badRequest().body("{\"success\":false,\"message\":\"invalid orderStatus\"}");
		    }
		    if (req.getPaymentStatus() < 1 || req.getPaymentStatus() > 3) {
		        return ResponseEntity.badRequest().body("{\"success\":false,\"message\":\"invalid paymentStatus\"}");
		    }

		    // 2) 비즈니스 규칙(예시): 배송중/완료면 송장 필수
		    if ((req.getOrderStatus() == 2 || req.getOrderStatus() == 3)
		        && (StringUtils.isBlank(req.getCourier()) || StringUtils.isBlank(req.getInvoice()))) {
		        return ResponseEntity.badRequest().body("{\"success\":false,\"message\":\"courier/invoice required when shipping or completed\"}");
		    }

		    try {
		        // 3) 서비스 호출(트랜잭션 내 일괄 처리)
		        int updated = adminOrderInfoService.updateUserOrderAndPayment(
		                req.getOrderId(),
		                req.getOrderStatus(),
		                req.getPaymentStatus(),
		                StringUtils.emptyToNull(req.getCourier()),
		                StringUtils.emptyToNull(req.getInvoice())
		        );

		        if (updated <= 0) {
		            return ResponseEntity.status(500).body("{\"success\":false,\"message\":\"no rows updated\"}");
		        }
		        return ResponseEntity.ok("{\"success\":true}");
		    } catch (Exception e) {
		        // 로그 찍기 권장
		        e.printStackTrace();
		        return ResponseEntity.status(500).body("{\"success\":false,\"message\":\"server error\"}");
		    }
		}

	// 1. 비회원 주문 목록 페이지
	    @GetMapping("/admin/adminGuestOrderInfo.do")
	    public String guestOrderPage(Model model) {
	        List<OrderVO> guestOrderList = adminOrderInfoService.getAllGuestOrders();
	        model.addAttribute("guestOrderList", guestOrderList);
	        return "admin/adminGuestOrderInfo"; // JSP 위치
	    }

	    // 2. 비회원 주문 상세 조회 (AJAX)
	    @GetMapping("/admin/adminGuestOrderInfo/getGuestOrderDetail.do")
	    @ResponseBody
	    public OrderVO getGuestOrderDetail(@RequestParam("orderId") int orderId) {
	        return adminOrderInfoService.getGuestOrderDetail(orderId);
	    }

	    // 3. 비회원 주문 업데이트 (AJAX 저장)
	    @PostMapping(value = "/admin/adminGuestOrderInfo/updateGuestOrder.do", consumes = "application/json", produces = "application/json")
	    @ResponseBody
	    public ResponseEntity<?> updateGuestOrder(@RequestBody AdminOrderUpdateRequestVO req) {

	        if (req.getOrderId() <= 0) {
	            return ResponseEntity.badRequest().body("{\"success\":false,\"message\":\"invalid orderId\"}");
	        }
	        if (req.getOrderStatus() < 1 || req.getOrderStatus() > 5) {
	            return ResponseEntity.badRequest().body("{\"success\":false,\"message\":\"invalid orderStatus\"}");
	        }

	        // 송장 필수 조건
	        if ((req.getOrderStatus() == 2 || req.getOrderStatus() == 3) &&
	            (StringUtils.isBlank(req.getCourier()) || StringUtils.isBlank(req.getInvoice()))) {
	            return ResponseEntity.badRequest().body("{\"success\":false,\"message\":\"courier/invoice required\"}");
	        }

	        try {
	            int updated = adminOrderInfoService.updateGuestOrderAndPayment(
	                    req.getOrderId(),
	                    req.getOrderStatus(),
	                    req.getPaymentStatus(),
	                    StringUtils.emptyToNull(req.getCourier()),
	                    StringUtils.emptyToNull(req.getInvoice())
	            );

	            if (updated <= 0) {
	                return ResponseEntity.status(500).body("{\"success\":false,\"message\":\"update failed\"}");
	            }
	            return ResponseEntity.ok("{\"success\":true}");

	        } catch (Exception e) {
	            e.printStackTrace();
	            return ResponseEntity.status(500).body("{\"success\":false,\"message\":\"server error\"}");
	        }
	    }

}
