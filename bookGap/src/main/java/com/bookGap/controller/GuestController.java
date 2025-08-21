package com.bookGap.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.OrderService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.OrderVO;

@Controller
public class GuestController {
  
  @Autowired
  private OrderService orderService;

//===================== 비회원 주문 페이지로 이동 =====================
  @GetMapping("/guest/guestOrder.do")
  public String showGuestOrderPage(@RequestParam(value="isbns",     required=false) List<String> isbns,
                                   @RequestParam(value="quantities",required=false) List<Integer> quantities,
                                   @RequestParam(value="isbn",      required=false) String isbn,
                                   @RequestParam(value="quantity",  required=false) Integer quantity,
                                   Model model) {

    List<BookVO> books = new ArrayList<>();
    List<Integer> qtys = new ArrayList<>();

    if(isbns != null && !isbns.isEmpty()){
      books = orderService.getBooksByIsbnList(isbns);
      qtys  = (quantities != null) ? quantities : Collections.emptyList();
    }else if (isbn != null && quantity != null){
      BookVO book = orderService.getBookByIsbn(isbn);
      if (book == null) return "redirect:/?error=book_not_found";
      books.add(book);
      qtys.add(quantity);
    }else{
      return "redirect:/?error=no_data";
    }

    model.addAttribute("bookList", books);
    model.addAttribute("quantityList", qtys);
    return "guest/guestOrder";
  }
  
  // ===================== 비회원 주문 생성(API) =====================
  @PostMapping("/order/guest/create")
  @ResponseBody
  public Map<String, Object> createGuestOrder(@RequestBody Map<String, Object> orderData) {
    Map<String, Object> resp = new HashMap<>();
    try{
      Map<String, Object> result = orderService.createGuestOrderWithDetails(orderData);
      resp.put("status", "SUCCESS");
      resp.put("orderId", result.get("orderId"));
      resp.put("guestId", result.get("guestId"));
    }catch (IllegalStateException e){
      resp.put("status", "FAIL");
      resp.put("message", e.getMessage());
    }catch (Exception e){
      resp.put("status", "FAIL");
      resp.put("message", "비회원 주문 처리 중 오류가 발생했습니다.");
    }
    return resp;
  }

  //===================== 비회원 주문 조회 처리 =====================
  @PostMapping("/guest/guestOrderInfo.do")
  public String guestOrderInfo( @RequestParam("orderPassword") String orderPassword,
                                @RequestParam("guestEmail") String guestEmail,
                                Model model) {

    // 1. 입력값 검증 (null + 빈 문자열)
    if(orderPassword == null || orderPassword.trim().isEmpty() || guestEmail == null || guestEmail.trim().isEmpty()){
      model.addAttribute("msg", "비밀번호와 이메일을 모두 입력하세요.");
      return "order/guestOrderForm";
    }

    // 2. 서비스 호출
    List<OrderVO> orders = orderService.findGuestOrdersByPasswordAndEmail(orderPassword, guestEmail);

    // 3. 조회 결과 체크
    if(orders == null || orders.isEmpty()){
      model.addAttribute("msg", "조회된 주문이 없습니다.");
      return "order/guestOrderForm";
    }

    // 4. 정상적으로 결과 전달 (주문별 + 상품내역 포함됨)
    System.out.println("조회된 주문 수: " + orders.size());
    model.addAttribute("guestOrders", orders);
    return "guest/guestOrderInfo";
  }

}