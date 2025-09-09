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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bookGap.service.GuestService;
import com.bookGap.service.OrderService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.GuestVO;
import com.bookGap.vo.OrderVO;

@Controller
public class GuestController {
  
  @Autowired private OrderService orderService;
  @Autowired private GuestService guestService;

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
  public Map<String, Object> createGuestOrder(@RequestBody Map<String, Object> orderData, HttpSession session) {
    Map<String, Object> resp = new HashMap<>();
    try{
      OrderVO createdOrder = orderService.createGuestOrderWithDetails(orderData);
      
      resp.put("status", "SUCCESS");

      resp.put("orderId", createdOrder.getOrderKey());
      resp.put("guestId", createdOrder.getGuestId());
      resp.put("orderName", orderData.get("orderName"));
      resp.put("totalPrice", createdOrder.getTotalPrice());
      resp.put("numericOrderId", createdOrder.getOrderId());

      session.setAttribute("completedGuestOrderKey", createdOrder.getOrderKey());
      
    }catch (IllegalStateException e){
      resp.put("status", "FAIL");
      resp.put("message", e.getMessage());
    }catch (Exception e){
      e.printStackTrace();
      resp.put("status", "FAIL");
      resp.put("message", "비회원 주문 처리 중 오류가 발생했습니다.");
    }
    return resp;
  }

  //===================== 비회원 주문 조회 처리 =====================
  @PostMapping("/guest/guestOrderInfo.do")
  public String guestOrderInfo(@RequestParam("orderKey") String orderKey,
                               @RequestParam("guestEmail") String guestEmail,
                               Model model,
                               RedirectAttributes redirectAttributes) {

    GuestVO guest = guestService.getGuestByEmail(guestEmail);
    if(guest == null){
      redirectAttributes.addFlashAttribute("errorMessage", "주문번호 또는 이메일 정보가 일치하지 않습니다.");
      return "redirect:/";
    }

    OrderVO order = orderService.findGuestOrderByKey(orderKey);

    // 3. [최종 비교] (주문이 있고) && (그 주문의 GUEST_ID가, 방금 이메일로 찾은 guest의 ID와 일치하는가?)
    if (order != null && order.getGuestId().equals(guest.getGuestId())) {
        
        model.addAttribute("order", order);
        model.addAttribute("guestEmail", guest.getGuestEmail()); 
        return "guest/guestOrderDetailsView"; 
    } else {
        redirectAttributes.addFlashAttribute("errorMessage", "주문번호 또는 이메일 정보가 일치하지 않습니다.");
        return "redirect:/";
    }
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