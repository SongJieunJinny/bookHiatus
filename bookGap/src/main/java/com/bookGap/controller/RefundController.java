package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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
  public String applyRefund(@RequestParam("orderId") int orderId,
                            @RequestParam("paymentNo") int paymentNo,
                            @RequestParam("refundReason") String refundReason,
                            @RequestParam(value="refundImage", required=false) MultipartFile refundImage,
                            @RequestParam("refundMail") String refundMail) {

    RefundVO refundVO = new RefundVO();
    refundVO.setOrderId(orderId);
    refundVO.setPaymentNo(paymentNo);
    refundVO.setRefundReason(refundReason);
    refundVO.setRefundMail(refundMail);

    // 첨부 이미지 파일명 저장 (실제 파일 저장 로직은 별도 구현 필요)
    if(refundImage != null && !refundImage.isEmpty()){
      refundVO.setRefundImage(refundImage.getOriginalFilename());
    }

    int result = refundService.applyRefund(refundVO);

    return result > 0 ? "success" : "fail";
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