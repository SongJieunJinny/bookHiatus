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
import org.springframework.web.multipart.MultipartFile;

import com.bookGap.service.RefundService;
import com.bookGap.vo.RefundVO;

@Controller
@RequestMapping("/refund")
public class RefundController {
  
  @Autowired private RefundService refundService;
  
  /* 환불 신청 */
  @PostMapping("/apply.do")
  @ResponseBody
  public ResponseEntity<String> applyRefund(RefundVO refundVO, @RequestParam(value="refundImage", required=false) MultipartFile refundImage) {
    try {
        if (refundImage != null && !refundImage.isEmpty()) {
          refundVO.setRefundImage(refundImage.getOriginalFilename());
        }
        refundService.applyRefundAndUpdateStatus(refundVO);
    
        return ResponseEntity.ok("success");

    } catch (Exception e) {
        // 서비스에서 예외가 터지면 이곳에서 잡아 실패 응답을 보냅니다.
        // 로그를 남기는 것이 좋습니다: log.error("환불 신청 실패", e);
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