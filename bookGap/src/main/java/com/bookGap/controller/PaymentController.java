package com.bookGap.controller;

import java.math.BigDecimal;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

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

@Controller
@RequestMapping("/payment")
public class PaymentController {

  @Autowired private PaymentService paymentService;

  @Autowired private RestTemplate restTemplate;
  
  //카카오페이 서버와 통신하기 위한 고정 값들
  private static final String KAKAO_HOST = "https://kapi.kakao.com";
  private static final String KAKAO_ADMIN_KEY = "809fcd6cd7077026042123c430cff2a3"; // [중요] 본인의 카카오 Admin 키를 넣으세요
  private static final String CID = "TC0ONETIME"; // 테스트용 가맹점 코드
  
  // ========== 토스페이먼츠 관련 ==========
  private static final String TOSS_API_HOST = "https://api.tosspayments.com";
  private static final String TOSS_SECRET_KEY = "test_sk_6BYq7GWPVv97k2edaZ6n3NE5vbo1"; // [중요] 본인의 시크릿 키로 교체 (sk_test_...)
     
  @PostMapping("/ready/kakaopay")
  @ResponseBody
  public KakaoReadyResponse kakaopayReady(@RequestBody KakaoPayRequestVO requestVO, HttpSession session) {
      
      // 1. payments 테이블에 '결제중' 상태로 데이터 INSERT
      PaymentVO payment = new PaymentVO();
      payment.setAmount(BigDecimal.valueOf(requestVO.getTotalAmount()));
      payment.setPaymentMethod(2); // 2: kakaopay
      payment.setOrderId(Integer.parseInt(requestVO.getPartnerOrderId())); // 실제 주문번호로 변경 필요
      payment.setUserId(requestVO.getPartnerUserId());
      
      paymentService.insertPayment(payment);
      int paymentNo = payment.getPaymentNo(); // [핵심] useGeneratedKeys로 받아온 PK

      // 2. 카카오페이 API에 보낼 파라미터 준비
      MultiValueMap<String, String> parameters = new LinkedMultiValueMap<>();
      parameters.add("cid", CID);
      parameters.add("partner_order_id", String.valueOf(paymentNo)); // 우리 시스템의 고유한 주문/결제 번호를 보내야 함
      parameters.add("partner_user_id", requestVO.getPartnerUserId());
      parameters.add("item_name", requestVO.getItemName());
      parameters.add("quantity", String.valueOf(requestVO.getQuantity()));
      parameters.add("total_amount", String.valueOf(requestVO.getTotalAmount()));
      parameters.add("tax_free_amount", "0");
      parameters.add("approval_url", "http://localhost:8080/ROOT/payment/success/kakaopay"); // [중요] 본인 환경에 맞게 수정
      parameters.add("cancel_url", "http://localhost:8080/ROOT/payment/cancel");
      parameters.add("fail_url", "http://localhost:8080/ROOT/payment/fail");

      // 3. 카카오페이 API 호출
      HttpHeaders headers = new HttpHeaders();
      headers.set("Authorization", "KakaoAK " + KAKAO_ADMIN_KEY);
      headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

      HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(parameters, headers);
      
      KakaoReadyResponse readyResponse = restTemplate.postForObject(
          KAKAO_HOST + "/v1/payment/ready",
          requestEntity,
          KakaoReadyResponse.class
      );
      
      // 4. 응답으로 받은 tid를 DB와 세션에 저장
      String tid = readyResponse.getTid();
      requestVO.setTid(tid);
      requestVO.setPaymentNo(paymentNo);
      paymentService.updateKakaoTid(requestVO); // DB에 tid 업데이트

      session.setAttribute("paymentNo", paymentNo); // 승인 단계에서 필요
      session.setAttribute("tid", tid);

      return readyResponse;
  }
  
  /**
   * 카카오페이 결제 성공 시, 최종 승인을 요청하는 메소드
   */
  @GetMapping("/success/kakaopay")
  public String kakaopaySuccess(@RequestParam("pg_token") String pgToken, HttpSession session) {

      Integer paymentNo = (Integer) session.getAttribute("paymentNo");
      String tid = (String) session.getAttribute("tid");

      if (paymentNo == null || tid == null) {
          // TODO: 세션 만료 또는 비정상 접근에 대한 예외 처리
          return "redirect:/order/error"; 
      }

      MultiValueMap<String, String> parameters = new LinkedMultiValueMap<>();
      parameters.add("cid", CID);
      parameters.add("tid", tid);
      parameters.add("partner_order_id", String.valueOf(paymentNo));
      parameters.add("pg_token", pgToken);
      
      HttpHeaders headers = new HttpHeaders();
      headers.set("Authorization", "KakaoAK " + KAKAO_ADMIN_KEY);
      headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
      
      HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(parameters, headers);

      // 최종 승인 요청
      ResponseEntity<String> response = restTemplate.postForEntity(
          KAKAO_HOST + "/v1/payment/approve", 
          requestEntity, 
          String.class
      );
      
      if (response.getStatusCode().is2xxSuccessful()) {
          // DB의 결제 상태를 '결제완료(2)'로 업데이트
        PaymentVO paymentUpdate = new PaymentVO();
        paymentUpdate.setPaymentNo(paymentNo);
        paymentUpdate.setStatus(2); // 2: 결제완료
        paymentService.updatePaymentStatus(paymentNo, 2);
        session.removeAttribute("paymentNo");
        session.removeAttribute("tid");
        return "redirect:/order/orderComplete.do?paymentNo=" + paymentNo; // 최종 완료 페이지로
      } else {
          // TODO: 실패 처리
          return "redirect:/payment/fail";
      }
  }
  
  // 임시 데이터 전달 클래스들
  public static class KakaoReadyResponse {
      private String tid;
      @JsonProperty("next_redirect_pc_url")
      private String nextRedirectPcUrl;
      // getter, setter ...
      public String getTid() { return tid; }
      public void setTid(String tid) { this.tid = tid; }
      public String getNextRedirectPcUrl() { return nextRedirectPcUrl; }
      public void setNextRedirectPcUrl(String nextRedirectPcUrl) { this.nextRedirectPcUrl = nextRedirectPcUrl; }
  }
  
  /**
   * 토스페이 결제 성공 시, 최종 승인을 요청하는 메소드
   */
  @GetMapping("/success/tosspay")
  public String tossPaySuccess(
          @RequestParam String paymentKey,
          @RequestParam String orderId,
          @RequestParam Long amount,
          HttpSession session) throws Exception {

    // 1. 주문번호(orderId)를 이용해서 우리 DB에 저장된 주문 정보를 가져옵니다.
    //    (예: orderService.findOrderById(orderId) )
    //    여기서는 실제 결제해야 할 금액을 DB에서 가져오는 것이 가장 안전합니다.
    //    이 예제에서는 프론트에서 넘어온 amount를 그대로 사용하지만, 실제로는 DB 금액과 비교해야 합니다.
    
    // 2. 토스페이먼츠 승인 API 호출
    HttpHeaders headers = new HttpHeaders();
    // [핵심] 시크릿 키를 Base64로 인코딩해서 Authorization 헤더에 담아야 합니다.
    String encodedAuth = Base64.getEncoder().encodeToString((TOSS_SECRET_KEY + ":").getBytes("UTF-8"));
    headers.set("Authorization", "Basic " + encodedAuth);
    headers.setContentType(MediaType.APPLICATION_JSON);

    // 승인 요청에 필요한 파라미터
    Map<String, Object> parameters = new HashMap<>();
    parameters.put("paymentKey", paymentKey);
    parameters.put("orderId", orderId);
    parameters.put("amount", amount);

    HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(parameters, headers);
    
    try {
      // API 호출
      ResponseEntity<String> response = restTemplate.postForEntity(
          TOSS_API_HOST + "/v1/payments/confirm",
          requestEntity,
          String.class
      );

      if (response.getStatusCode().is2xxSuccessful()) {
          // 최종 결제 성공
          
          // [DB 작업] 
          // 1. orders 테이블의 주문 ID(PK)를 orderId를 이용해 찾아냅니다.
          // 2. 그 주문 ID를 가지고 payments 테이블을 생성합니다. (결제수단: 1(Toss))
          PaymentVO payment = new PaymentVO();
          payment.setOrderId(Integer.parseInt(orderId.split("_")[1])); // "order_123"에서 123 추출
          payment.setAmount(new BigDecimal(amount));
          payment.setPaymentMethod(1); // 1: Toss
          paymentService.insertPayment(payment);
          int paymentNo = payment.getPaymentNo();
          
          // 3. toss_requests 테이블에 정보를 기록하고, paymentKey를 업데이트합니다.
          TossRequestVO tossRequest = new TossRequestVO();
          tossRequest.setPaymentNo(paymentNo);
          tossRequest.setPaymentKey(paymentKey);
          // ... 필요 시 다른 정보도 추가
          paymentService.insertTossRequest(tossRequest); 
          paymentService.updateTossPaymentKey(tossRequest);
          
          // 4. payments 테이블 상태를 '결제완료(2)'로 최종 업데이트
          paymentService.updatePaymentStatus(paymentNo, 2);

          return "redirect:/order/orderComplete.do?orderId=" + orderId; // 최종 완료 페이지로 이동
      } else {
          // TODO: 승인 실패 (카드 한도 초과 등)
          return "redirect:/order/fail";
        }
    } catch (Exception e) {
      // TODO: API 통신 자체에 실패
      e.printStackTrace();
      return "redirect:/order/fail";
    }
  }

}
