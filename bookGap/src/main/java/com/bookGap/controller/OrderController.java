package com.bookGap.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.OrderService;
import com.bookGap.service.PaymentService;
import com.bookGap.util.PagingUtil;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.PaymentVO;
import com.bookGap.vo.UserAddressVO;
import com.bookGap.vo.UserInfoVO;

@Controller
public class OrderController {
  
  private static final Logger log = LoggerFactory.getLogger(OrderController.class);
  
  @Autowired
  private OrderService orderService;
  @Autowired private PaymentService paymentService;
	
  //===================== 공통: 주문내역 페이지 =====================
  @GetMapping("/order/myOrder.do")
  public String orderDetails(@RequestParam(name="page", defaultValue="1") int page,
                             Principal principal,
                             Model model) {
    if (principal == null) return "redirect:/login.do";
    String userId = principal.getName();

    int total   = orderService.getTotalOrderCount(userId); // 전체 주문 수
    int perPage = 3;                                       // 페이지당 3개

    // 페이징 계산
    PagingUtil paging = new PagingUtil(page, total, perPage);

    // 페이지 범위 보정(선택)
    if (page > paging.getLastPage() && paging.getLastPage() > 0) {
        page = paging.getLastPage();
        paging = new PagingUtil(page, total, perPage);
    }

    // 목록 조회 (LIMIT offset, count)
    List<OrderVO> orderList = orderService.getOrdersPaging(userId, paging.getStart(), paging.getPerPage());

    model.addAttribute("orderList", orderList);
    model.addAttribute("paging", paging);
    return "order/myOrder";
  }
  
  // ===================== 회원 주문 페이지 진입 =====================
  @PostMapping("/order/orderMain.do")
  public String orderMain(@RequestParam(value="isbns",       required=false) List<String> isbns,
                          @RequestParam(value="quantities",  required=false) List<Integer> quantities,
                          @RequestParam(value="cartNos",     required=false) List<Integer> cartNos,
                          @RequestParam(value="userId",      required=false) String userIdParam,
                          @RequestParam(value="userAddressId", required=false) Integer userAddressId,
                          @RequestParam(value="totalPrice",  required=false) Integer totalPrice,
                          Principal principal, Model model) {

    log.info("POST /order/orderMain.do isbns={}, quantities={}", isbns, quantities);

    if (principal == null) return "redirect:/login";
    String sessionUserId = principal.getName();
    if(userIdParam != null && !userIdParam.equals(sessionUserId)){
      return "redirect:/?error=invalid_user";
    }

    // 로그인 사용자 이름 노출
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    Object principalObj = authentication.getPrincipal();
    if(principalObj instanceof UserInfoVO){
      UserInfoVO userInfo = (UserInfoVO) principalObj;
      model.addAttribute("currentUserId", userInfo.getUserId());
      model.addAttribute("currentUserName", userInfo.getUserName());
    }else{
      model.addAttribute("currentUserId", sessionUserId);
      model.addAttribute("currentUserName", "고객");
    }

    // 주문 아이템 구성
    if (isbns == null || isbns.isEmpty()) return "redirect:/?error=no_order_data";
    if(quantities == null || isbns.size() != quantities.size()){
      return "redirect:/product/cart.do?error=param_mismatch";
    }

    List<BookVO> books = orderService.getBooksByIsbnList(isbns);
    List<Map<String, Object>> orderItems = new ArrayList<>();
    for(int i = 0; i < isbns.size(); i++){
      String curIsbn = isbns.get(i);
      int qty = quantities.get(i);
      BookVO book = books.stream().filter(b -> curIsbn.equals(b.getIsbn())).findFirst().orElse(null);
      if(book != null){
        Map<String, Object> item = new HashMap<>();
        item.put("book", book);
        item.put("quantity", qty);
        item.put("cartNo", (cartNos != null && cartNos.size() > i) ? cartNos.get(i) : null);
        orderItems.add(item);
      }
    }

    // 주소 정보
    UserAddressVO defaultAddress = orderService.getDefaultAddress(sessionUserId);
    List<UserAddressVO> addressList = orderService.getAddressList(sessionUserId);

    model.addAttribute("orderItems", orderItems);
    model.addAttribute("defaultAddress", defaultAddress);
    model.addAttribute("addressList", addressList);
    model.addAttribute("userAddressId", userAddressId);
    model.addAttribute("totalPrice", totalPrice);

    return "order/orderMain";
  }
  
  //===================== 회원 주문 생성(API) =====================
  @PostMapping("/order/create")
  @ResponseBody
  public Map<String, Object> createOrder(@RequestBody Map<String, Object> orderData, Principal principal) {
    Map<String, Object> resp = new HashMap<>();

    String requestUserId = (String) orderData.get("userId");
    if(principal == null || !principal.getName().equals(requestUserId)){
      resp.put("status", "FAIL");
      resp.put("message", "사용자 인증 정보가 올바르지 않습니다.");
      return resp;
    }

    try{
      int orderId = orderService.createOrderWithDetails(orderData);
      resp.put("status", "SUCCESS");
      resp.put("orderId", orderId);
    }catch (IllegalStateException e){
      resp.put("status", "FAIL");
      resp.put("message", e.getMessage());
    }catch (Exception e){
      resp.put("status", "FAIL");
      resp.put("message", "주문 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
    }
    return resp;
  }
 
  // ===================== 회원: 주소록 관리(API) =====================
  @PostMapping("/order/addAddress.do")
  @ResponseBody
  public String addAddress(@RequestBody UserAddressVO addressVO, Principal principal) {
    if (principal == null) return "FAIL: NOT_LOGGED_IN";
    addressVO.setUserId(principal.getName());
    try{
      orderService.registerAddress(addressVO);
      return "SUCCESS";
    }catch (Exception e){
      return "FAIL: " + e.getMessage();
    }
  }
	
  /* 주소 삭제(AJAX) — JSP 경로와 맞춤 */
  @PostMapping("/order/deleteAddress.do")
  @ResponseBody
  public String deleteAddress(@RequestParam("userAddressId") int userAddressId) {
    try{
      orderService.removeAddress(userAddressId);
      return "SUCCESS";
    }catch (Exception e){
      return "FAIL: " + e.getMessage();
    }
  }
  
  @GetMapping("/order/orderComplete.do")
  public String orderComplete(@RequestParam("paymentNo") int paymentNo, Model model) {
	  PaymentVO payment = paymentService.getPaymentByNo(paymentNo);
	 // log.info("[orderComplete] request paymentNo = {}", paymentNo);

	   // System.out.println("payment"+payment);
	   // System.out.println("getPaymenNo"+payment.getPaymentNo());
	    // 예: 주문번호로 주문상세 및 배송지 조회
	    OrderVO order = orderService.getOrderById(payment.getOrderId());
	    
	    System.out.println("getPaymenNo"+order.getOrderId());

	    model.addAttribute("payment", payment);
	    model.addAttribute("order", order);
        model.addAttribute("paymentNo", paymentNo);
      return "order/orderComplete";  // --> /WEB-INF/views/order/orderComplete.jsp
  }
  
  // 주문 상세 화면 이동
  @GetMapping("/order/orderDetailsView.do")
  public String orderDetailsView(@RequestParam("orderId") int orderId, Model model) {
    OrderVO order = orderService.getOrderById(orderId);
    if (order == null) {
      return "redirect:/order/orderDetails.do";
    }
    model.addAttribute("order", order);
    return "order/orderDetailsView"; // → /WEB-INF/views/order/orderDetailsView.jsp
  }

}