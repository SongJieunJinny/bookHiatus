package com.bookGap.controller;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.bookGap.service.PaymentService;
import com.bookGap.vo.KakaoPayRequestVO;
import com.bookGap.vo.PaymentVO;
import com.bookGap.vo.TossRequestVO;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
@RequestMapping("/payment")
public class PaymentController {
	private static final Logger log = LoggerFactory.getLogger(PaymentController.class);
  @Autowired private PaymentService paymentService;

  @Autowired private RestTemplate restTemplate;
  @Autowired private ObjectMapper objectMapper;
  
  //카카오페이 서버와 통신하기 위한 고정 값들
  private static final String KAKAO_OPEN_API_URL = "https://open-api.kakaopay.com/online/v1/payment";
  private static final String KAKAO_SECRET_KEY = "DEVCE7E1EDE6956AA24B1D1393F4F22F917E4725"; // [중요] 본인의 카카오 Admin 키를 넣으세요
  private static final String CID = "TC0ONETIME"; // 테스트용 가맹점 코드
  
  // ========== 토스페이먼츠 관련 ==========
  private static final String TOSS_API_HOST = "https://api.tosspayments.com";
  private static final String TOSS_SECRET_KEY = "test_sk_6BYq7GWPVv97k2edaZ6n3NE5vbo1"; // [중요] 본인의 시크릿 키로 교체 (sk_test_...)
     
  @PostMapping("/ready/kakaopay")
  @ResponseBody
  public KakaoReadyResponse kakaopayReady(@RequestBody KakaoPayRequestVO requestVO, HttpSession session) {
      // DB 저장
      PaymentVO payment = new PaymentVO();
      payment.setAmount(BigDecimal.valueOf(requestVO.getTotalAmount()));
      payment.setPaymentMethod(2); // 카카오페이
      payment.setOrderId(Integer.parseInt(requestVO.getPartnerOrderId()));

      if (requestVO.getPartnerUserId().startsWith("G-")) {
          payment.setGuestId(requestVO.getPartnerUserId());
      } else {
          payment.setUserId(requestVO.getPartnerUserId());
      }

      paymentService.insertPayment(payment);
      log.info("[orderComplete] loaded payment: paymentNo={}, orderId={}",
    	         payment.getPaymentNo(), payment.getOrderId());
      int paymentNo = payment.getPaymentNo();
      log.info("[kakaopayReady] save to session paymentNo={}, partner_user_id={}", paymentNo, requestVO.getPartnerUserId());
      requestVO.setPaymentNo(paymentNo);

      // 요청 파라미터 준비
      Map<String, Object> params = new HashMap<>();
      params.put("cid", CID);
      params.put("partner_order_id", String.valueOf(paymentNo));
      params.put("partner_user_id", requestVO.getPartnerUserId());
      params.put("item_name", requestVO.getItemName());
      params.put("quantity", requestVO.getQuantity());
      params.put("total_amount", requestVO.getTotalAmount());
      params.put("tax_free_amount", 0);
      params.put("approval_url", "http://localhost:8080/controller/payment/success/kakaopay");
      params.put("cancel_url", "http://localhost:8080/controller/payment/cancel");
      params.put("fail_url", "http://localhost:8080/controller/payment/fail");

      HttpHeaders headers = new HttpHeaders();
      headers.set("Authorization", "SECRET_KEY " + KAKAO_SECRET_KEY); // Open API 방식
      headers.setContentType(MediaType.APPLICATION_JSON);

      HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(params, headers);

      ResponseEntity<JsonNode> response = restTemplate.postForEntity(
          KAKAO_OPEN_API_URL + "/ready", requestEntity, JsonNode.class
      );

      if (response.getStatusCode().is2xxSuccessful()) {
          JsonNode body = response.getBody();
          String tid = body.get("tid").asText();
          String nextRedirectUrl = body.get("next_redirect_pc_url").asText();

          // TID 저장
          requestVO.setTid(tid);
          paymentService.updateKakaoTid(requestVO);

          // 세션 저장
          session.setAttribute("paymentNo", paymentNo);
          session.setAttribute("tid", tid);
          session.setAttribute("partner_user_id", requestVO.getPartnerUserId());

          return new KakaoReadyResponse(tid, nextRedirectUrl);
      } else {
          throw new RuntimeException("카카오페이 결제 준비 실패: " + response.getStatusCode());
      }
  }
  
  /**
   * 카카오페이 결제 성공 시, 최종 승인을 요청하는 메소드
   */
  @GetMapping("/success/kakaopay")
  public String kakaopaySuccess(@RequestParam("pg_token") String pgToken, HttpSession session) {
      Integer paymentNo = (Integer) session.getAttribute("paymentNo");
      String tid = (String) session.getAttribute("tid");
      String partnerUserId = (String) session.getAttribute("partner_user_id");
      
      log.info("[kakaopaySuccess] session paymentNo={}, tid={}, partner_user_id={}, pg_token={}",
    	         new Object[]{paymentNo, tid, partnerUserId, pgToken});


      if (paymentNo == null || tid == null || partnerUserId == null) {
          return "redirect:/order/error";
      }

      Map<String, Object> params = new HashMap<>();
      params.put("cid", CID);
      params.put("tid", tid);
      params.put("partner_order_id", String.valueOf(paymentNo));
      params.put("partner_user_id", partnerUserId);
      params.put("pg_token", pgToken);

      HttpHeaders headers = new HttpHeaders();
      headers.set("Authorization", "SECRET_KEY " + KAKAO_SECRET_KEY);
      headers.setContentType(MediaType.APPLICATION_JSON);

      HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(params, headers);

      try {
          ResponseEntity<JsonNode> response = restTemplate.postForEntity(
              KAKAO_OPEN_API_URL + "/approve", requestEntity, JsonNode.class
          );

          if (response.getStatusCode().is2xxSuccessful()) {
              paymentService.updatePaymentStatus(paymentNo, 2);
              session.removeAttribute("paymentNo");
              session.removeAttribute("tid");
              session.removeAttribute("partner_user_id");

              return "redirect:/order/orderComplete.do?paymentNo=" + paymentNo;
          } else {
              return "redirect:/payment/fail";
          }
      } catch (Exception e) {
          e.printStackTrace();
          return "redirect:/payment/fail";
      }
  }
  
  /**
   * 토스페이 결제 성공 시, 최종 승인을 요청하는 메소드
   */
  @GetMapping("/success/tosspay")
  public String tossPaySuccess(@RequestParam String paymentKey,
                               @RequestParam String orderId,
                               @RequestParam Long amount,
                               Principal principal) throws Exception {
      HttpHeaders headers = new HttpHeaders();
      String encodedAuth = Base64.getEncoder().encodeToString((TOSS_SECRET_KEY + ":").getBytes("UTF-8"));
      headers.set("Authorization", "Basic " + encodedAuth);
      headers.setContentType(MediaType.APPLICATION_JSON);

      Map<String, Object> params = new HashMap<>();
      params.put("paymentKey", paymentKey);
      params.put("orderId", orderId);
      params.put("amount", amount);

      HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(params, headers);

      try {
          ResponseEntity<String> response = restTemplate.postForEntity(
              TOSS_API_HOST + "/v1/payments/confirm", requestEntity, String.class);

          System.out.println("TOSS 응답: " + response.getBody());

          if (response.getStatusCode().is2xxSuccessful()) {
              JsonNode resNode = objectMapper.readTree(response.getBody());

              if (!resNode.has("customerKey")) {
                  throw new NullPointerException("TOSS 응답에 customerKey 없음");
              }

              String customerKey = resNode.get("customerKey").asText();

              PaymentVO payment = new PaymentVO();
              TossRequestVO tossRequest = new TossRequestVO();

              int realOrderId;
              if (orderId.contains("_guest_")) {
                  realOrderId = Integer.parseInt(orderId.split("_")[2]);
                  payment.setGuestId(customerKey);
                  tossRequest.setCustomerKey(customerKey);
              } else {
                  realOrderId = Integer.parseInt(orderId.split("_")[1]);
                  payment.setUserId(principal.getName());
                  tossRequest.setCustomerKey(principal.getName());
              }

              payment.setOrderId(realOrderId);
              payment.setAmount(new BigDecimal(amount));
              payment.setPaymentMethod(1); // toss
              payment.setStatus(2);

              paymentService.insertPayment(payment);
              int paymentNo = payment.getPaymentNo();

              tossRequest.setPaymentNo(paymentNo);
              tossRequest.setPaymentKey(paymentKey);
              tossRequest.setOrderName(resNode.get("orderName").asText());
              tossRequest.setSuccessUrl("http://localhost:8080/ROOT/payment/success/tosspay");
              tossRequest.setFailUrl("http://localhost:8080/ROOT/payment/fail");

              paymentService.insertTossRequest(tossRequest);

              return "redirect:/order/orderComplete.do?orderId=" + realOrderId;

          } else {
              return "redirect:/order/fail?message=approval_failed";
          }

      } catch (Exception e) {
          e.printStackTrace();
          return "redirect:/order/fail?message=api_error";
      }
  }
  
// fail, cancel 매핑 추가
  @GetMapping("/fail")
  public String paymentFail() {
      return "redirect:/order/fail?message=payment_failed";
  }

  @GetMapping("/cancel")
  public String paymentCancel() {
      return "redirect:/order/fail?message=payment_cancelled";
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

}
