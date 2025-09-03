package com.bookGap.controller;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.Base64;
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
import com.bookGap.vo.OrderDetailVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.PaymentVO;
import com.bookGap.vo.TossCancelVO;
import com.bookGap.vo.TossRequestVO;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;

@Controller
@RequestMapping("/payment")
public class PaymentController {
  private static final Logger log = LoggerFactory.getLogger(PaymentController.class);
  
  @Autowired private PaymentService paymentService;
  @Autowired private OrderService orderService;
  @Autowired private RestTemplate restTemplate;

  //KakaoPay 고정값
  private static final String KAKAO_OPEN_API_URL = "https://open-api.kakaopay.com/online/v1/payment";
  private static final String KAKAO_SECRET_KEY = "DEVCE7E1EDE6956AA24B1D1393F4F22F917E4725"; // [중요] 본인의 카카오 Admin 키를 넣으세요
  private static final String CID = "TC0ONETIME"; // 테스트용 가맹점 코드
  
  //Toss 고정값
  private static final String TOSS_API_HOST = "https://api.tosspayments.com";
  private static final String TOSS_SECRET_KEY = "test_sk_6BYq7GWPVv97k2edaZ6n3NE5vbo1"; // [중요] 본인의 시크릿 키로 교체 (sk_test_...)
     
  /* -------------------------------------------------------------------- 카카오 ----------------------------------------------------------------------- */
  /** 카카오페이 결제 준비 */
  @PostMapping("/ready/kakaopay")
  @ResponseBody
  public KakaoReadyResponse kakaopayReady(@RequestBody KakaoPayRequestVO req,
                                          HttpSession session, Principal principal) {
    try{
      log.info("[KAKAO READY][REQ] 요청 수신: orderId={}", req.getOrderId());
      
      if (req.getOrderId() == null) throw new IllegalArgumentException("주문 ID(orderId)가 누락되었습니다.");
      
      String partnerUserId = (principal != null) ? principal.getName() : "guest";
      if (principal != null) req.setPartnerUserId(partnerUserId);

      OrderVO order = orderService.getOrderById(req.getOrderId());
      if (order == null) throw new RuntimeException("존재하지 않는 주문입니다: " + req.getOrderId());

      final String partnerOrderId = order.getOrderKey();
      if(partnerOrderId == null || partnerOrderId.trim().isEmpty()){
          log.error("[KAKAO READY][FATAL] DB에서 조회한 주문의 orderKey가 null입니다. (orderId={})", order.getOrderId());
          throw new IllegalStateException("결제에 필요한 고유 주문키(orderKey)가 생성되지 않았습니다.");
      }

      final int totalAmount = order.getTotalPrice();
      if (totalAmount <= 0) throw new RuntimeException("결제 금액이 0보다 작거나 같습니다.");

      int qty = 0;
      String itemName = "BOOK틈 주문상품";
      if(order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()){
          qty = order.getOrderDetails().stream().mapToInt(OrderDetailVO::getOrderCount).sum();
          String firstTitle = order.getOrderDetails().get(0).getBook().getProductInfo().getTitle();
          itemName = (order.getOrderDetails().size() == 1) ? firstTitle : firstTitle + " 외 " + (order.getOrderDetails().size() - 1) + "건";
      }
      
      if (qty <= 0) qty = 1;

      PaymentVO payment = new PaymentVO();
      payment.setAmount(BigDecimal.valueOf(totalAmount));
      payment.setPaymentMethod(2);
      payment.setOrderId(order.getOrderId());
      payment.setStatus(1);
      payment.setUserId(order.getUserId());
      payment.setGuestId(order.getGuestId());
      paymentService.insertPayment(payment);
      int paymentNo = payment.getPaymentNo();

      req.setPaymentNo(paymentNo);
      req.setPartnerOrderId(partnerOrderId);
      req.setTotalAmount(totalAmount);
      req.setItemName(itemName);
      req.setQuantity(qty);
      req.setCid(CID);
      req.setApprovalUrl("http://localhost:8080/controller/payment/success/kakaopay");
      req.setCancelUrl("http://localhost:8080/controller/payment/fail?code=cancel");
      req.setFailUrl("http://localhost:8080/controller/payment/fail?code=fail");
      req.setTaxFreeAmount(0);
      paymentService.insertKakaoRequest(req);

      log.info("[KAKAO READY][DB] paymentNo={} 생성 완료.", paymentNo);

      Map<String, Object> params = new HashMap<>();
      params.put("cid", CID);
      params.put("partner_order_id", partnerOrderId);
      params.put("partner_user_id", partnerUserId);
      params.put("item_name", itemName);
      params.put("quantity", qty);
      params.put("total_amount", totalAmount);
      params.put("tax_free_amount", 0);
      params.put("approval_url", req.getApprovalUrl());
      params.put("cancel_url", req.getCancelUrl());
      params.put("fail_url", req.getFailUrl());

      HttpHeaders headers = new HttpHeaders();
      headers.set("Authorization", "SECRET_KEY " + KAKAO_SECRET_KEY);
      headers.setContentType(MediaType.APPLICATION_JSON);

      HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(params, headers);
      
      ResponseEntity<JsonNode> res = restTemplate.postForEntity(
          KAKAO_OPEN_API_URL + "/ready", requestEntity, JsonNode.class);
      
      if(!res.getStatusCode().is2xxSuccessful()){ throw new RuntimeException("카카오페이 결제 준비 API 호출 실패: " + res.getStatusCode() + " - " + res.getBody()); }

      String tid = res.getBody().get("tid").asText();
      String nextRedirectUrl = res.getBody().get("next_redirect_pc_url").asText();

      KakaoPayRequestVO upd = new KakaoPayRequestVO();
      upd.setPaymentNo(paymentNo);
      upd.setTid(tid);
      paymentService.updateKakaoTid(upd);

      session.setAttribute("paymentNo", paymentNo);
      session.setAttribute("tid", tid);
      session.setAttribute("partner_user_id", partnerUserId);

      log.info("[KAKAO READY][OK] 결제 준비 성공. paymentNo={}, tid={}, redirectUrl={}", paymentNo, tid, nextRedirectUrl);

      return new KakaoReadyResponse(tid, nextRedirectUrl);

    }catch(Exception e){
      log.error("[KAKAO READY][FAIL] 카카오 결제 준비 중 심각한 오류 발생", e);
      throw new RuntimeException(e.getMessage());
    }
  }

  @GetMapping("/success/kakaopay")
  public String kakaopaySuccess(@RequestParam("pg_token") String pgToken, HttpSession session) {
    Integer paymentNo    = (Integer) session.getAttribute("paymentNo");
    String tid           = (String) session.getAttribute("tid");
    String partnerUserId = (String) session.getAttribute("partner_user_id");
    if (paymentNo == null || tid == null || partnerUserId == null) return "redirect:/order/error";

    String partnerOrderId = paymentService.selectKakaoRequest(paymentNo).getPartnerOrderId();

    Map<String,Object> params = new HashMap<>();
    params.put("cid", CID);
    params.put("tid", tid);
    params.put("partner_order_id", partnerOrderId);
    params.put("partner_user_id", partnerUserId);
    params.put("pg_token", pgToken);

    HttpHeaders headers = new HttpHeaders();
    headers.set("Authorization", "SECRET_KEY " + KAKAO_SECRET_KEY);
    headers.setContentType(MediaType.APPLICATION_JSON);

    try{
      ResponseEntity<JsonNode> response = restTemplate.postForEntity(
        KAKAO_OPEN_API_URL + "/approve",
        new HttpEntity<>(params, headers),
        JsonNode.class);
      if(response.getStatusCode().is2xxSuccessful()){
        paymentService.updatePaymentStatus(paymentNo, 2);
        session.removeAttribute("paymentNo");
        session.removeAttribute("tid");
        session.removeAttribute("partner_user_id");
        return "redirect:/order/orderComplete.do?paymentNo=" + paymentNo;
      }
      return "redirect:/payment/fail";
    }catch(Exception e){
      e.printStackTrace();
      return "redirect:/payment/fail";
    }
  }
  
  @PostMapping(value = "/kakao/cancelPayment.do", produces = "text/plain;charset=UTF-8")
  @ResponseBody
  public ResponseEntity<?> cancelKakao(@RequestBody Map<String, Object> body) {
      try {
          PaymentVO payment = null;
          String cancelReason = "관리자 환불";

          if (body.containsKey("refundNo")) {
        	  int refundNo = (Integer) body.get("refundNo");
              payment = paymentService.selectPaymentByRefundNo(refundNo);
          } else if (body.containsKey("paymentNo") && body.containsKey("orderId")) {
        	  int paymentNo = Integer.parseInt(body.get("paymentNo").toString());
        	  int orderId = Integer.parseInt(body.get("orderId").toString());
        	  payment = paymentService.getPaymentByNo(paymentNo);
              if (payment == null || payment.getOrderId() != orderId) {
                  return ResponseEntity.badRequest().body("결제 정보 불일치");
              }
              cancelReason = "사용자 주문취소";
          } else {
              return ResponseEntity.badRequest().body("요청 파라미터 부족");
          }

          if (payment == null) return ResponseEntity.badRequest().body("결제 정보 없음");

          KakaoPayRequestVO kakaoRequest = paymentService.selectKakaoRequest(payment.getPaymentNo());
          if (kakaoRequest == null) return ResponseEntity.badRequest().body("카카오 요청 정보 없음");

          // 카카오 API 요청
          Map<String, Object> params = new HashMap<>();
          params.put("cid", CID);
          params.put("tid", kakaoRequest.getTid());
          params.put("cancel_amount", payment.getAmount().intValue());
          params.put("cancel_tax_free_amount", 0);
          params.put("cancel_reason", cancelReason);

          HttpHeaders headers = new HttpHeaders();
          headers.set("Authorization", "SECRET_KEY " + KAKAO_SECRET_KEY);
          headers.setContentType(MediaType.APPLICATION_JSON);

          HttpEntity<Map<String, Object>> request = new HttpEntity<>(params, headers);
          ResponseEntity<JsonNode> response = restTemplate.postForEntity(
              KAKAO_OPEN_API_URL + "/cancel", request, JsonNode.class);

          if (response.getStatusCode().is2xxSuccessful()) {
              // 1. 결제 상태 업데이트
              paymentService.updatePaymentStatus(payment.getPaymentNo(), 3); // 환불 완료

              // 2. 카카오 환불 이력 저장
              KakaoPayCancelVO cancelVO = new KakaoPayCancelVO();
              cancelVO.setPaymentNo(payment.getPaymentNo());
              cancelVO.setCancelAmount(payment.getAmount().intValue());
              cancelVO.setCancelReason(cancelReason);
              cancelVO.setCid(CID);
              cancelVO.setTid(kakaoRequest.getTid());
              cancelVO.setCancelTaxFree(0);
              paymentService.insertKakaoCancel(cancelVO);

              // 3. 주문 상태 업데이트 (사용자 요청일 때만)
              if (!body.containsKey("refundNo")) {
            	  int orderId = Integer.parseInt(body.get("orderId").toString());
                  orderService.updateOrderStatus(orderId, 4); // 4 = 주문취소
              }

              return ResponseEntity.ok("success");
          } else {
              return ResponseEntity.status(500).body("카카오페이 환불 실패");
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
	  this.tid = tid; this.nextRedirectPcUrl = nextRedirectPcUrl;
	}
	
	public String getTid() { return tid; }
	
	public void setTid(String tid) { this.tid = tid; }
	
	public String getNextRedirectPcUrl() { return nextRedirectPcUrl; }
	
	public void setNextRedirectPcUrl(String nextRedirectPcUrl) { this.nextRedirectPcUrl = nextRedirectPcUrl; }
  
  }
  
  /* ------------------------------------------------------------------------ 토스 ------------------------------------------------------------------- */
  
  /* 토스 결제 준비를 위한 전용 API (회원/비회원 공통) */
  @PostMapping("/prepare")
  @ResponseBody
  public Map<String, Object> prepareTossPayment(@RequestBody Map<String, Object> orderData,
                                                Principal principal,
                                                HttpServletRequest request) {
    try{
      return paymentService.prepareAndCreateTossOrder(orderData, principal, request);
    }catch(Exception e){
      e.printStackTrace();
      Map<String,Object> response = new HashMap<>();
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
                                   Model model, Principal principal) {
    try {
        PaymentVO completedPayment = paymentService.confirmTossPayment(paymentKey, tossOrderId, amount);

        return "redirect:/order/orderComplete.do?paymentNo=" + completedPayment.getPaymentNo();

    } catch (Exception e) {
        e.printStackTrace();
        model.addAttribute("errorMessage", e.getMessage());
        model.addAttribute("errorCode", "TOSS_APPROVAL_FAILED");
        
        return "redirect:/payment/fail?message=" + e.getMessage();
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

  @PostMapping(value = "/toss/cancelPayment.do", produces = "text/plain;charset=UTF-8")
  @ResponseBody
  public ResponseEntity<?> cancelToss(@RequestBody Map<String, Object> body) {
    try {
      PaymentVO payment = null;
      String cancelReason = "관리자 환불";

      // 1) 관리자 환불 경로 (refundNo 기반)
      if (body.containsKey("refundNo")) {
        int refundNo = Integer.parseInt(body.get("refundNo").toString());
        payment = paymentService.selectPaymentByRefundNo(refundNo);

      // 2) 사용자 주문취소 경로 (paymentNo + orderId 기반)
      } else if (body.containsKey("paymentNo") && body.containsKey("orderId")) {
        int paymentNo = Integer.parseInt(body.get("paymentNo").toString());
        int orderId   = Integer.parseInt(body.get("orderId").toString());

        // 결제 단건 조회 (mapper: getPaymentByNo)
        payment = paymentService.getPaymentByNo(paymentNo);
        if (payment == null || payment.getOrderId() != orderId) {
          return ResponseEntity.badRequest().body("결제 정보 불일치");
        }
        cancelReason = "사용자 주문취소";

      } else {
        return ResponseEntity.badRequest().body("요청 파라미터 부족");
      }

      if (payment == null) return ResponseEntity.badRequest().body("결제 정보 없음");

      // 3) 토스 결제 요청 정보 조회 (payment_no → payment_key 필요)
      TossRequestVO tossRequest = paymentService.findTossRequestByPaymentNo(payment.getPaymentNo());
      if (tossRequest == null || tossRequest.getPaymentKey() == null) {
        return ResponseEntity.badRequest().body("Toss 결제 정보 없음");
      }

      // 4) 토스 취소 API 호출
      HttpHeaders headers = new HttpHeaders();
      String encodedAuth = Base64.getEncoder().encodeToString((TOSS_SECRET_KEY + ":").getBytes("UTF-8"));
      headers.set("Authorization", "Basic " + encodedAuth);
      headers.setContentType(MediaType.APPLICATION_JSON);

      Map<String, Object> params = new HashMap<>();
      params.put("cancelReason", cancelReason);
      // 필요 시 부분취소 금액 지정: params.put("cancelAmount", payment.getAmount().intValue());

      HttpEntity<Map<String, Object>> request = new HttpEntity<>(params, headers);
      String url = TOSS_API_HOST + "/v1/payments/" + tossRequest.getPaymentKey() + "/cancel";
      ResponseEntity<JsonNode> response = restTemplate.postForEntity(url, request, JsonNode.class);

      if (response.getStatusCode().is2xxSuccessful()) {
        // 5) 결제 상태 갱신 (3=환불완료)
        paymentService.updatePaymentStatus(payment.getPaymentNo(), 3);

        // 6) 환불 이력 저장
        TossCancelVO cancelVO = new TossCancelVO();
        cancelVO.setPaymentNo(payment.getPaymentNo());
        cancelVO.setPaymentKey(tossRequest.getPaymentKey());
        cancelVO.setCancelReason(cancelReason);
        paymentService.insertTossCancel(cancelVO);

        // 7) 사용자 경로라면 주문상태도 취소(4)로 업데이트
        if (!body.containsKey("refundNo")) {
          int orderId = Integer.parseInt(body.get("orderId").toString());
          orderService.updateOrderStatus(orderId, 4);
        }

        return ResponseEntity.ok("success");
      } else {
        return ResponseEntity.status(500).body("토스페이 환불 실패");
      }

    } catch (Exception e) {
      e.printStackTrace();
      return ResponseEntity.status(500).body("오류 발생: " + e.getMessage());
    }
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