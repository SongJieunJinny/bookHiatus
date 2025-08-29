package com.bookGap.controller;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
                                HttpServletResponse response, HttpSession session,
                                Model model)throws Exception{

    System.out.println("===== guestOrderInfo.do 진입 =====");
    System.out.println("전달받은 이메일: " + guestEmail);
    System.out.println("전달받은 비밀번호: " + orderPassword);
    
    if (orderPassword == null || orderPassword.trim().isEmpty() || guestEmail == null || guestEmail.trim().isEmpty()){
      response.setContentType("text/html; charset=UTF-8");
      PrintWriter out = response.getWriter();
      out.println("<script>alert('주문 시 입력했던 주문비밀번호와 이메일을 입력해주세요.'); history.back();</script>");
      out.flush();
      out.close();
      return null; 
    }

    List<OrderVO> orders = orderService.findGuestOrdersByPasswordAndEmail(orderPassword, guestEmail);
    
    if (orders == null || orders.isEmpty()){
      response.setContentType("text/html; charset=UTF-8");
      PrintWriter out = response.getWriter();
      out.println("<script>alert('조회된 주문이 없습니다.'); history.back();</script>");
      out.flush();
      out.close();
      return null;  
    }

    session.setAttribute("authGuestEmail", guestEmail);
    session.setAttribute("authOrderPassword", orderPassword);
    model.addAttribute("guestOrders", orders);
    return "guest/guestOrderInfo";
  }
  
  //===================== 비회원 주문 상세 조회 =====================
  @GetMapping("/guest/guestOrderDetailsView.do")
  public String guestOrderDetailsView(@RequestParam("orderId") int orderId, HttpServletRequest request, 
                                      HttpServletResponse response, HttpSession session, Model model)throws Exception{

    String guestEmail = (String) session.getAttribute("authGuestEmail");
    String orderPassword = (String) session.getAttribute("authOrderPassword");
    
    if (guestEmail == null || orderPassword == null){
      response.setContentType("text/html; charset=UTF-8");
      PrintWriter out = response.getWriter();
      out.println("<script>");
      out.println("alert('인증 정보가 만료되었습니다. 메인 페이지로 이동합니다.');");
      String contextPath = request.getContextPath();
      out.println("location.href = '" + contextPath + "/';"); 
      out.println("</script>");
      out.flush();
      out.close();
      return null; 
    }
    
    OrderVO order = orderService.getGuestOrderByOrderId(orderId);

    if (order == null){
      response.setContentType("text/html; charset=UTF-8");
      PrintWriter out = response.getWriter();
      out.println("<script>alert('해당 주문 정보를 찾을 수 없습니다.'); history.back();</script>");
      out.flush();
      out.close();
      return null; 
    }
    
    model.addAttribute("order", order);
    model.addAttribute("guestEmail", guestEmail);
    model.addAttribute("orderPassword", orderPassword);
    
    return "guest/guestOrderDetailsView"; 
  }

}