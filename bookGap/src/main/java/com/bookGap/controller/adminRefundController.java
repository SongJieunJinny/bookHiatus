package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.AdminRefundService;
import com.bookGap.vo.RefundVO;



@Controller
public class adminRefundController {
	
	@Autowired
    private AdminRefundService adminRefundService;
	
	// 목록 페이지
	  @GetMapping("/admin/adminRefund.do")
	  public String refundListPage(Model model) {
	    List<RefundVO> list = adminRefundService.getAllRefunds();
	    model.addAttribute("orderList", list); // JSP에서 orderList 사용 중이므로 맞춰줌
	    return "admin/adminRefund";
	  }

	  // 상세
	  @GetMapping("/admin/adminRefund/getRefundDetail.do")
	  @ResponseBody
	  public RefundVO getRefundDetail(@RequestParam("refundNo") int refundNo) {
	    return adminRefundService.getRefundDetail(refundNo);
	  }

	  // 상태 업데이트
	  @PostMapping(value = "/admin/adminRefund/updateRefundStatus.do",
	               consumes = "application/json", produces = "application/json")
	  @ResponseBody
	  public ResponseEntity<?> updateRefundStatus(@RequestBody RefundVO body) {
	    if (body.getRefundNo() <= 0) {
	      return ResponseEntity.badRequest().body("{\"success\":false,\"message\":\"invalid refundNo\"}");
	    }
	    int status = body.getRefundStatus();
	    if (status < 1 || status > 4) {
	      return ResponseEntity.badRequest().body("{\"success\":false,\"message\":\"invalid refundStatus\"}");
	    }

	    try {
	      int updated = adminRefundService.updateRefundStatusAndSyncOrder(body.getRefundNo(), status);
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
