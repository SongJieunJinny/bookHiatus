package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.RefundService;
import com.bookGap.vo.RefundVO;

@Controller
@RequestMapping("/refund")
public class RefundController {
  
  @Autowired private RefundService refundService;
  
  /* 환불 신청 */
  @PostMapping("/apply.do")
  @ResponseBody
  public ResponseEntity<String> applyRefund(RefundVO refundVO) {
    try {
      if (refundVO.getOrderId() == null || refundVO.getPaymentNo() == null) {
        return ResponseEntity.badRequest().body("필수 데이터 누락");
      }
      if (refundVO.getRefundMail() == null || refundVO.getRefundMail().trim().isEmpty()) {
        return ResponseEntity.badRequest().body("메일 주소 누락");
      }

      refundService.applyRefundAndUpdateStatus(refundVO);
        return ResponseEntity.ok("success");
    } catch (Exception e) {
      e.printStackTrace(); // 서버 콘솔에 상세 로그 출력
      return ResponseEntity.status(500).body("fail");
    }
  }

  /* 환불 신청 내역을 고객 화면에서 조회 */
  @GetMapping("/list.do")
  @ResponseBody
  public List<RefundVO> getRefundList(@RequestParam("orderId") int orderId) {
    return refundService.getRefundListByOrderId(orderId);
  }
  
  /* 환불 단일 조회 (회원/비회원 공통) */
  @GetMapping("/status.do")
  @ResponseBody
  public RefundVO getRefundStatus(@RequestParam("orderId") int orderId,
                                  @RequestParam("paymentNo") int paymentNo) {
    return refundService.getRefundByOrderAndPayment(orderId, paymentNo);
  }


}