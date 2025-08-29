package com.bookGap.controller;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.bookGap.service.OrderService;
import com.bookGap.service.PaymentService;
import com.bookGap.vo.KakaoPayCancelVO;
import com.bookGap.vo.KakaoPayRequestVO;
import com.bookGap.vo.PaymentVO;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
@RequestMapping("/payment")
public class PaymentController {
	private static final Logger log = LoggerFactory.getLogger(PaymentController.class);
  @Autowired private PaymentService paymentService;
  @Autowired private OrderService orderService;

  @Autowired private RestTemplate restTemplate;
  @Autowired private ObjectMapper objectMapper;
  
  //카카오페이 서버와 통신하기 위한 고정 값들
  private static final String KAKAO_OPEN_API_URL = "https://open-api.kakaopay.com/online/v1/payment";
  private static final String KAKAO_SECRET_KEY = "DEVCE7E1EDE6956AA24B1D1393F4F22F917E4725"; // [중요] 본인의 카카오 Admin 키를 넣으세요
  private static final String CID = "TC0ONETIME"; // 테스트용 가맹점 코드
  
  // ========== 토스페이먼츠 관련 ==========
  private static final String TOSS_API_HOST = "https://api.tosspayments.com";
  private static final String TOSS_SECRET_KEY = "test_sk_6BYq7GWPVv97k2edaZ6n3NE5vbo1"; // [중요] 본인의 시크릿 키로 교체 (sk_test_...)
     
  /* -------------------------------------------------------------------- 카카오 ----------------------------------------------------------------------- */
  /** 카카오페이 결제 준비 */
  @PostMapping("/ready/kakaopay")
  @ResponseBody
  public KakaoReadyResponse kakaopayReady(@RequestBody KakaoPayRequestVO requestVO, HttpSession session, Principal principal) {
    
    try {
      // 1) PAYMENTS 저장
      PaymentVO payment = new PaymentVO();
      payment.setAmount(BigDecimal.valueOf(requestVO.getTotalAmount()));
      payment.setPaymentMethod(2); // 카카오

      // ✅ partner_order_id 는 "BG_" + paymentNo 이므로, 여기서는 paymentNo 자체를 DB orderId로 쓰면 됨
      paymentService.insertPayment(payment);
      int paymentNo = payment.getPaymentNo();
     
      // 2) ★ KAKAOPAY_REQUESTS 선(先) INSERT
      requestVO.setPaymentNo(paymentNo);
      requestVO.setCid(CID);
      requestVO.setPartnerOrderId("BG_" + paymentNo); // ✅ partner_order_id 통일
      requestVO.setApprovalUrl("http://localhost:8080/controller/payment/success/kakaopay");
      requestVO.setCancelUrl("http://localhost:8080/controller/payment/cancel");
      requestVO.setFailUrl("http://localhost:8080/controller/payment/fail");
      
      paymentService.insertKakaoRequest(requestVO);
    
      // 3) 카카오 ready 호출
      Map<String, Object> params = new HashMap<>();
      params.put("cid", CID);
      params.put("partner_order_id", requestVO.getPartnerOrderId());
      params.put("partner_user_id", requestVO.getPartnerUserId());
      params.put("item_name", requestVO.getItemName());
      params.put("quantity", requestVO.getQuantity());
      params.put("total_amount", requestVO.getTotalAmount());
      params.put("tax_free_amount", 0);
      params.put("approval_url", "http://localhost:8080/controller/payment/success/kakaopay");
      params.put("cancel_url", "http://localhost:8080/controller/payment/cancel");
      params.put("fail_url", "http://localhost:8080/controller/payment/fail");
    
      HttpHeaders headers = new HttpHeaders();
      headers.set("Authorization", "SECRET_KEY " + KAKAO_SECRET_KEY);
      headers.setContentType(MediaType.APPLICATION_JSON);
    
      ResponseEntity<JsonNode> response = restTemplate.postForEntity(
        KAKAO_OPEN_API_URL + "/ready",
        new HttpEntity<>(params, headers),
        JsonNode.class
      );
    
      if (!response.getStatusCode().is2xxSuccessful()) {
        throw new RuntimeException("카카오페이 결제 준비 실패: " + response.getStatusCode());
      }
    
      // 4) ★ tid 업데이트
      JsonNode body = response.getBody();
      String tid = body.get("tid").asText();
      String nextRedirectUrl = body.get("next_redirect_pc_url").asText();
    
      KakaoPayRequestVO updateVO = new KakaoPayRequestVO();
      updateVO.setPaymentNo(paymentNo);
      updateVO.setTid(tid);
      paymentService.updateKakaoTid(updateVO);
    
      // 세션
      session.setAttribute("paymentNo", paymentNo);
      session.setAttribute("tid", tid);
      session.setAttribute("partner_user_id", requestVO.getPartnerUserId());
    
      return new KakaoReadyResponse(tid, nextRedirectUrl);
      
    } catch (Exception e) {
      throw new RuntimeException("카카오 결제 준비 중 오류: " + e.getMessage());
    }
  }

  /** 카카오페이 승인 */
  @GetMapping("/success/kakaopay")
  public String kakaopaySuccess(@RequestParam("pg_token") String pgToken, HttpSession session) {
    Integer paymentNo = (Integer) session.getAttribute("paymentNo");
    String tid = (String) session.getAttribute("tid");
    String partnerUserId = (String) session.getAttribute("partner_user_id");
    
    if (paymentNo == null || tid == null || partnerUserId == null) return "redirect:/order/error";

    Map<String, Object> params = new HashMap<>();
    params.put("cid", CID);
    params.put("tid", tid);
    params.put("partner_order_id", "BG_" + paymentNo);
    params.put("partner_user_id", partnerUserId);
    params.put("pg_token", pgToken);

    HttpHeaders headers = new HttpHeaders();
    headers.set("Authorization", "SECRET_KEY " + KAKAO_SECRET_KEY);
    headers.setContentType(MediaType.APPLICATION_JSON);

    try {
        ResponseEntity<JsonNode> response = restTemplate.postForEntity(
          KAKAO_OPEN_API_URL + "/approve",
          new HttpEntity<>(params, headers),
          JsonNode.class
        );
        if (response.getStatusCode().is2xxSuccessful()) {
          paymentService.updatePaymentStatus(paymentNo, 2);

          session.removeAttribute("paymentNo");
          session.removeAttribute("tid");
          session.removeAttribute("partner_user_id");

          return "redirect:/order/orderComplete.do?paymentNo=" + paymentNo;
        }
        return "redirect:/payment/fail";
    } catch (Exception e) {
      e.printStackTrace();
      return "redirect:/payment/fail";
    }
  }
  
  @PostMapping("/kakao/cancelPayment.do")
  @ResponseBody
  public ResponseEntity<?> cancelKakao(@RequestBody Map<String, Object> body) {
    try {
      int refundNo = (Integer) body.get("refundNo");

      // 1. 환불 번호로 결제 정보 조회
      PaymentVO payment = paymentService.selectPaymentByRefundNo(refundNo);
      if (payment == null) {
        return ResponseEntity.badRequest().body("결제 정보 없음");
      }

      // 2. TID 조회
      KakaoPayRequestVO kakaoRequest = paymentService.selectKakaoRequest(payment.getPaymentNo());
      if (kakaoRequest == null) {
        return ResponseEntity.badRequest().body("카카오 요청 정보 없음");
      }

      // 3. 요청 파라미터 구성
      Map<String, Object> params = new HashMap<>();
      params.put("cid", CID);
      params.put("tid", kakaoRequest.getTid());
      params.put("cancel_amount", payment.getAmount().intValue());
      params.put("cancel_tax_free_amount", 0);
      params.put("cancel_reason", "관리자 환불");

      HttpHeaders headers = new HttpHeaders();
      headers.set("Authorization", "SECRET_KEY " + KAKAO_SECRET_KEY);
      headers.setContentType(MediaType.APPLICATION_JSON);

      HttpEntity<Map<String, Object>> request = new HttpEntity<>(params, headers);

      // 4. 카카오 API 호출
      ResponseEntity<JsonNode> response = restTemplate.postForEntity(
        KAKAO_OPEN_API_URL + "/cancel",
        request, JsonNode.class
      );

      if (response.getStatusCode().is2xxSuccessful()) {
        // 5. 환불 이력 저장
        JsonNode responseBody = response.getBody();

        KakaoPayCancelVO cancelVO = new  KakaoPayCancelVO();
        cancelVO.setPaymentNo(payment.getPaymentNo());
        cancelVO.setCancelAmount(payment.getAmount().intValue());
        cancelVO.setCancelReason("관리자 환불");
        cancelVO.setCid(CID);
        cancelVO.setTid(kakaoRequest.getTid());
        cancelVO.setCancelTaxFree(0);

        paymentService.insertKakaoCancel(cancelVO);  // 서비스단이지만 매퍼 직접 주입해도 됨
        
        paymentService.updatePaymentStatus(payment.getPaymentNo(), 3);

        return ResponseEntity.ok("success");
        } else {
          return ResponseEntity.status(500).body("카카오페이 환불 실패: " + response.getStatusCode());
        }
    } catch (Exception e) {
      e.printStackTrace();
      return ResponseEntity.status(500).body("오류 발생: " + e.getMessage());
    }
  }
  
  public static class KakaoReadyResponse {
    private String tid;

    @JsonProperty("next_redirect_pc_url")
    private String nextRedirectPcUrl;

    public KakaoReadyResponse() {}

    public KakaoReadyResponse(String tid, String nextRedirectPcUrl) {
      this.tid = tid;
      this.nextRedirectPcUrl = nextRedirectPcUrl;
    }

    public String getTid() { return tid; }
    public void setTid(String tid) { this.tid = tid; }

    public String getNextRedirectPcUrl() { return nextRedirectPcUrl; }
    public void setNextRedirectPcUrl(String nextRedirectPcUrl) {
      this.nextRedirectPcUrl = nextRedirectPcUrl;
    }
  }
  
  /* ------------------------------------------------------------------------ 토스 ------------------------------------------------------------------- */
  
  /* 토스 결제 준비를 위한 전용 API (회원/비회원 공통) */
  @PostMapping("/prepare")
  @ResponseBody
  public Map<String, Object> prepareTossPayment(@RequestBody Map<String, Object> orderData, 
                                                Principal principal, 
                                                HttpServletRequest request) {
    try {
      // 서비스에서 주문 + 결제(PAYMENTS) 생성 후 응답 내려줌
      return paymentService.prepareAndCreateTossOrder(orderData, principal, request);
    } catch (Exception e) {
      e.printStackTrace();
      Map<String, Object> response = new HashMap<>();
      response.put("status", "FAIL");
      response.put("message", "결제 준비 중 오류: " + e.getMessage());
      return response;
    }
  }
  
  /* 토스 결제 성공 콜백 */
  @GetMapping("/success")
  public String tossPaymentSuccess(@RequestParam String paymentKey,
                                   @RequestParam(name = "orderId") String tossOrderId,
                                   @RequestParam Long amount,
                                   Model model) {
    try {
      PaymentVO completedPayment = paymentService.confirmTossPayment(paymentKey, tossOrderId, amount);
      return "redirect:/order/orderComplete.do?paymentNo=" + completedPayment.getPaymentNo();
    } catch (Exception e) {
      e.printStackTrace();
      model.addAttribute("errorMessage", e.getMessage());
      return "redirect:/payment/fail?message=approval_failed";
    }
  }
  
  /* 결제 실패/취소시 확인페이지 */
  @GetMapping("/fail")
  public String paymentFail(Model model,
                            @RequestParam(required = false) String message,
                            @RequestParam(required = false) String code) {
    model.addAttribute("errorMessage", "결제에 실패했습니다.");
    model.addAttribute("errorCode", code);
    model.addAttribute("errorDetail", message);
    return "payment/paymentFail"; 
  }

  
  /* ----------------------------------------------------fail, cancel 매핑 추가--------------------------------------------------- */

 /* @GetMapping("/fail")
  public String paymentFail() {
      return "redirect:/order/fail?message=payment_failed";
  }

  @GetMapping("/cancel")
  public String paymentCancel() {
      return "redirect:/order/fail?message=payment_cancelled";
  }*/

}
