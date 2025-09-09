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
import org.springframework.http.HttpMethod;
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
      log.info("[KAKAO READY][REQ] 요청 수신: orderId={}", req);
      
      OrderVO order;
      if(principal != null){ // 회원 주문
        Long orderId = req.getOrderId();
        if (orderId == null) throw new IllegalArgumentException("orderId 누락");
        log.info("[KAKAO READY][AUTH] 회원 주문, userId={}", principal.getName());

        order = orderService.getOrderById(orderId.intValue()); // 회원 전용 매퍼
        if (order == null) throw new RuntimeException("주문 없음: orderId=" + orderId);
        if (!principal.getName().equals(order.getUserId()))
          throw new RuntimeException("주문 소유자 불일치");
      }else{                 // 비회원 주문
        String orderKey = req.getOrderKey();
        if (orderKey == null || orderKey.isBlank())
          throw new IllegalArgumentException("orderKey 누락");
        log.info("[KAKAO READY][GUEST] 비회원 주문");

        order = orderService.findGuestOrderByKey(orderKey);    // 게스트 전용 매퍼(ORDER_TYPE=2)
        if (order == null) throw new RuntimeException("게스트 주문 없음: orderKey=" + orderKey);
      }

      // ===== 카카오 파트너 식별 값 =====
      final String partnerUserId = (principal != null) ? principal.getName() : order.getGuestId();
      req.setPartnerUserId(partnerUserId);

      final String partnerOrderId = order.getOrderKey(); // 카카오에는 항상 orderKey 사용
      if(partnerOrderId == null || partnerOrderId.isBlank()){
        log.error("[KAKAO READY][FATAL] DB orderKey null (orderId={})", order.getOrderId());
        throw new IllegalStateException("orderKey 미생성");
      }


      // ===== 결제 금액/상품명 구성 =====
      final int totalAmount = order.getTotalPrice();
      if (totalAmount <= 0) throw new RuntimeException("결제 금액이 0보다 작거나 같습니다.");

      int qty = 0;
      String itemName = "BOOK틈 주문상품";
      if (order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) {
        qty = order.getOrderDetails().stream().mapToInt(OrderDetailVO::getOrderCount).sum();
        String firstTitle = order.getOrderDetails().get(0).getBook().getProductInfo().getTitle();
        itemName = (order.getOrderDetails().size() == 1)
            ? firstTitle
            : firstTitle + " 외 " + (order.getOrderDetails().size() - 1) + "건";
      }
      if (qty <= 0) qty = 1;

      // ===== 사전 결제 레코드 생성 =====
      PaymentVO payment = new PaymentVO();
      payment.setAmount(BigDecimal.valueOf(totalAmount));
      payment.setPaymentMethod(2); // 카카오
      payment.setOrderId(order.getOrderId());
      payment.setStatus(1);
      payment.setUserId(order.getUserId());
      payment.setGuestId(order.getGuestId());
      paymentService.insertPayment(payment);
      int paymentNo = payment.getPaymentNo();

      paymentService.logPayment(paymentNo, "[KAKAO][READY] 결제 레코드 생성, amount=" + totalAmount);

      // ===== 카카오 요청 파라미터 =====
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

      paymentService.logPayment(paymentNo, "[KAKAO][READY] KAKAOPAY_REQUESTS 저장, partnerOrderId=" + partnerOrderId);

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

      if (!res.getStatusCode().is2xxSuccessful())
        throw new RuntimeException("카카오페이 /ready 실패: " + res.getStatusCode() + " - " + res.getBody());

      String tid = res.getBody().get("tid").asText();
      String nextRedirectUrl = res.getBody().get("next_redirect_pc_url").asText();

      KakaoPayRequestVO upd = new KakaoPayRequestVO();
      upd.setPaymentNo(paymentNo);
      upd.setTid(tid);
      paymentService.updateKakaoTid(upd);

      paymentService.logPayment(paymentNo, "[KAKAO][READY][OK] tid=" + tid + ", redirect=" + nextRedirectUrl);

      session.setAttribute("paymentNo", paymentNo);
      session.setAttribute("tid", tid);
      session.setAttribute("partner_user_id", partnerUserId);

      log.info("[KAKAO READY][OK] paymentNo={}, tid={}, redirect={}", paymentNo, tid, nextRedirectUrl);
      return new KakaoReadyResponse(tid, nextRedirectUrl);

    } catch (Exception e) {
      log.error("[KAKAO READY][FAIL]", e);
      throw new RuntimeException(e.getMessage());
    }
  }

  @GetMapping("/success/kakaopay")
  public String kakaopaySuccess(@RequestParam("pg_token") String pgToken, HttpSession session, Model model, Principal principal) {
    Integer paymentNo    = (Integer) session.getAttribute("paymentNo");
    String tid           = (String) session.getAttribute("tid");
    String partnerUserId = (String) session.getAttribute("partner_user_id");
    
    if(paymentNo == null || tid == null || partnerUserId == null){
      model.addAttribute("errorMessage", "결제 정보가 만료되었거나 유효하지 않습니다.");
      return "payment/paymentFail";
    }

    try{
      KakaoPayRequestVO kakaoRequest = paymentService.selectKakaoRequest(paymentNo);
      if(kakaoRequest == null) { throw new Exception("카카오페이 요청 정보를 찾을 수 없습니다."); }
      String partnerOrderId = kakaoRequest.getPartnerOrderId();
  
      // 카카오 API 요청을 위한 파라미터 준비
      Map<String,Object> params = new HashMap<>();
      params.put("cid", CID);
      params.put("tid", tid);
      params.put("partner_order_id", partnerOrderId);
      params.put("partner_user_id", partnerUserId);
      params.put("pg_token", pgToken);
  
      // HTTP 헤더 설정
      HttpHeaders headers = new HttpHeaders();
      headers.set("Authorization", "SECRET_KEY " + KAKAO_SECRET_KEY);
      headers.setContentType(MediaType.APPLICATION_JSON);
  
      // RestTemplate으로 API 호출
      ResponseEntity<JsonNode> response = restTemplate.postForEntity(
          KAKAO_OPEN_API_URL + "/approve",
          new HttpEntity<>(params, headers),
          JsonNode.class
      );
    
      // --- 결제 승인 성공 시 DB 상태를 업데이트하고 세션을 정리 ---
      if(response.getStatusCode().is2xxSuccessful()){
        
        paymentService.updatePaymentStatus(paymentNo, 2); // DB의 결제 상태를 '완료(2)'로 변경

        // 사용이 끝난 세션 정보는 즉시 삭제
        session.removeAttribute("paymentNo");
        session.removeAttribute("tid");
        session.removeAttribute("partner_user_id");
        
        // --- 회원/비회원을 구분하여 Model에 데이터를 담기 ---
        String guestOrderKey = (String) session.getAttribute("completedGuestOrderKey");

        if(guestOrderKey != null){  // [비회원]
          model.addAttribute("orderKey", guestOrderKey);
          model.addAttribute("order", orderService.findGuestOrderByKey(guestOrderKey));

          session.removeAttribute("completedGuestOrderKey"); // 사용 후 즉시 제거
        }else if(principal != null){  // [회원]
          PaymentVO payment = paymentService.getPaymentByNo(paymentNo);

          if(payment != null) {
            model.addAttribute("order", orderService.getOrderById(payment.getOrderId()));
            model.addAttribute("payment", payment);
          }

        }else{  // 비회원도 아니고 회원도 아닌 경우 (매우 드묾), 비정상 접근으로 간주
          throw new Exception("사용자 인증 정보를 찾을 수 없습니다.");
        }
        return "order/orderComplete"; // -> /WEB-INF/views/order/orderComplete.jsp
      }

      throw new Exception("카카오페이 최종 승인에 실패했습니다.");

    }catch(Exception e){
      e.printStackTrace();
      model.addAttribute("errorMessage", "결제 처리 중 오류가 발생했습니다: " + e.getMessage());
      return "payment/paymentFail"; 
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
              
              paymentService.logPayment(payment.getPaymentNo(),  "[KAKAO][CANCEL] 환불 완료, reason=" + cancelReason + ", amount=" + payment.getAmount());

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
                                   Model model, HttpSession session) {
    try{
      PaymentVO completedPayment = paymentService.confirmTossPayment(paymentKey, tossOrderId, amount);
  
      String guestOrderKey = (String) session.getAttribute("completedGuestOrderKey");
  
      if(guestOrderKey != null){  // [비회원일 경우]
        model.addAttribute("orderKey", guestOrderKey);
        model.addAttribute("order", orderService.findGuestOrderByKey(guestOrderKey));
        session.removeAttribute("completedGuestOrderKey");
      }else{  // [회원일 경우]
        model.addAttribute("order", orderService.getOrderById(completedPayment.getOrderId()));
        model.addAttribute("payment", completedPayment);
      }
  
      return "order/orderComplete";

    }catch (Exception e){
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
    try{
      PaymentVO payment = null;
      String cancelReason = "관리자 환불";

      // ----------------경로 분기: 관리자 환불, 사용자 주문취소---------------- //
      if(body.containsKey("refundNo")){  //관리자 환불(refundNo)
        int refundNo = Integer.parseInt(body.get("refundNo").toString());
        payment = paymentService.selectPaymentByRefundNo(refundNo);
      }else if(body.containsKey("paymentNo") && body.containsKey("orderId")){  //사용자 주문취소(paymentNo + orderId)
        int paymentNo = Integer.parseInt(body.get("paymentNo").toString());
        int orderId   = Integer.parseInt(body.get("orderId").toString());

        payment = paymentService.getPaymentByNo(paymentNo);
        if(payment == null || payment.getOrderId() != orderId){ return ResponseEntity.badRequest().body("결제 정보 불일치"); }
        cancelReason = "사용자 주문취소";
      }else{
        return ResponseEntity.badRequest().body("요청 파라미터 부족");
      }

      if (payment == null) return ResponseEntity.badRequest().body("결제 정보 없음");

      // ----------------TOSS_REQUESTS 조회---------------- //
      TossRequestVO tossRequest = paymentService.findTossRequestByPaymentNo(payment.getPaymentNo());
      if (tossRequest == null) return ResponseEntity.badRequest().body("Toss 결제 정보 없음");

      String paymentKey = tossRequest.getPaymentKey();
      if(paymentKey == null || paymentKey.isBlank()){

        String orderIdForToss = tossRequest.getOrderId();
        if(orderIdForToss == null || orderIdForToss.isBlank()) { orderIdForToss = "BG_" + String.format("%06d", payment.getPaymentNo()); }

        HttpHeaders h = new HttpHeaders();
        String basic = Base64.getEncoder().encodeToString((TOSS_SECRET_KEY + ":").getBytes("UTF-8"));
        h.set("Authorization", "Basic " + basic);

        ResponseEntity<JsonNode> findRes = restTemplate.exchange( TOSS_API_HOST + "/v1/payments/orders/" + orderIdForToss,
                                                                  HttpMethod.GET,
                                                                  new HttpEntity<>(h),
                                                                  JsonNode.class );

        if(!findRes.getStatusCode().is2xxSuccessful() || findRes.getBody() == null){ return ResponseEntity.status(500).body("Toss 결제 조회 실패"); }

        String recoveredKey = findRes.getBody().path("paymentKey").asText(null);
        if(recoveredKey == null || recoveredKey.isBlank()){ return ResponseEntity.status(500).body("Toss paymentKey 조회 실패"); }

        TossRequestVO upd = new TossRequestVO();
        upd.setPaymentNo(payment.getPaymentNo());
        upd.setPaymentKey(recoveredKey);
        paymentService.updateTossPaymentKey(upd);

        paymentKey = recoveredKey;
        tossRequest.setPaymentKey(recoveredKey);
      }

      // ----------------취소 API 호출---------------- //
      HttpHeaders headers = new HttpHeaders();
      String encodedAuth = Base64.getEncoder().encodeToString((TOSS_SECRET_KEY + ":").getBytes("UTF-8"));
      headers.set("Authorization", "Basic " + encodedAuth);
      headers.setContentType(MediaType.APPLICATION_JSON);

      Map<String, Object> params = new HashMap<>();
      params.put("cancelReason", cancelReason);
      // 부분취소 시: params.put("cancelAmount", payment.getAmount().intValue());

      ResponseEntity<JsonNode> response = restTemplate.postForEntity( TOSS_API_HOST + "/v1/payments/" + paymentKey + "/cancel",
                                                                      new HttpEntity<>(params, headers),
                                                                      JsonNode.class );

      if (!response.getStatusCode().is2xxSuccessful()) { return ResponseEntity.status(500).body("토스페이 환불 실패"); }

      // ----------------DB 반영---------------- //
      paymentService.updatePaymentStatus(payment.getPaymentNo(), 3); // 3=환불완료

      TossCancelVO cancelVO = new TossCancelVO();
      cancelVO.setPaymentNo(payment.getPaymentNo());
      cancelVO.setPaymentKey(paymentKey);
      cancelVO.setCancelReason(cancelReason);
      paymentService.insertTossCancel(cancelVO);

      if(!body.containsKey("refundNo")){  // 사용자 경로면 주문상태도 취소(4)
        int orderId = Integer.parseInt(body.get("orderId").toString());
        orderService.updateOrderStatus(orderId, 4);
      }

      paymentService.logPayment(payment.getPaymentNo(), "[TOSS][CANCEL] 환불 완료, reason=" + cancelReason);
      return ResponseEntity.ok("success");

    }catch (Exception e){
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