package com.bookGap.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.OrderService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.UserAddressVO;

@RequestMapping(value="/order")
@Controller
public class OrderController {
  
  @Autowired
  private OrderService orderService;
	
  @GetMapping("/orderDetails.do")
  public String orderDetails(Principal principal, Model model) {
    if(principal == null){
      return "redirect:/login"; // 비로그인 시 로그인 페이지로
    }
    String userId = principal.getName();
    List<OrderVO> orderList = orderService.getOrdersByUserId(userId);
    model.addAttribute("orderList", orderList);
    return "order/orderDetails";
  }
	
	@GetMapping("/orderMain.do")
  public String orderMain(@RequestParam(value = "isbns", required = false) List<String> isbns,
                          @RequestParam(value = "quantities", required = false) List<Integer> quantities,
                          @RequestParam(value = "isbn", required = false) String isbn,
                          @RequestParam(value = "quantity", required = false) Integer quantity,
                          Principal principal, Model model) {

    if(principal == null){ return "redirect:/login"; }
    String userId = principal.getName();

    List<Map<String, Object>> orderItems = new ArrayList<>();
  
    //장바구니를 통해 여러 상품을 주문하는 경우 (isbns 파라미터가 존재)
    if(isbns != null && !isbns.isEmpty()){
      if(quantities == null || isbns.size() != quantities.size()){
        return "redirect:/product/cart.do?error=param_mismatch";
      }
      
      // 서비스의 getBooksByIsbnList 메소드를 호출하여 여러 책 정보를 한 번에 가져옴
      List<BookVO> books = orderService.getBooksByIsbnList(isbns);
      
      // 가져온 책 정보와 수량을 Map으로 묶어 orderItems 리스트에 추가
      for(int i = 0; i < isbns.size(); i++){
        String currentIsbn = isbns.get(i);
        int currentQuantity = quantities.get(i);
        
        books.stream()
             .filter(b -> b.getIsbn().equals(currentIsbn))
             .findFirst()
             .ifPresent(book -> {
               Map<String, Object> item = new HashMap<>();
               item.put("book", book);
               item.put("quantity", currentQuantity);
               orderItems.add(item);
             });
      }

    // 단일 상품을 바로 주문하는 경우 (isbn 파라미터가 존재)
    }else if(isbn != null && !isbn.isEmpty()){
      BookVO book = orderService.getBookByIsbn(isbn);
      if(book != null){
        Map<String, Object> item = new HashMap<>();
        item.put("book", book);
        item.put("quantity", (quantity != null) ? quantity : 1);
        orderItems.add(item);
      }
    }
    
    // 처리할 상품이 없는 경우, 홈페이지나 장바구니로 리다이렉트
    if(orderItems.isEmpty()){ return "redirect:/"; }
  
    // --- 공통 로직: 주소 정보 조회 및 모델에 데이터 추가 ---
    UserAddressVO defaultAddress = orderService.getDefaultAddress(userId);
    List<UserAddressVO> addressList = orderService.getAddressListByUserId(userId);
  
    model.addAttribute("orderItems", orderItems); // 주문 상품 리스트
    model.addAttribute("defaultAddress", defaultAddress);
    model.addAttribute("addressList", addressList);
  
    return "order/orderMain";
  }

	@PostMapping("/addAddress.do")
	@ResponseBody // 페이지 이동 없이 데이터만 반환
	public String addAddress(@RequestBody UserAddressVO addressVO, Principal principal) {
	  if(principal != null){
      String loginId = principal.getName();
      System.out.println("### 서버가 인식한 로그인 ID: [" + loginId + "]"); 
      addressVO.setUserId(loginId);
    }else{
      System.out.println("### 경고: Principal 객체가 null입니다. 로그인 상태가 아닙니다.");
      return "FAIL: NOT_LOGGED_IN"; // 여기서 처리를 중단.
    }
	  
	  try{
      orderService.addAddress(addressVO);
      return "SUCCESS";
    }catch(Exception e){
      System.out.println("### 데이터베이스 저장 실패! 전달된 VO 정보: " + addressVO.toString()); 
      e.printStackTrace();
      return "FAIL: " + e.getMessage();
    }
  }
	
	@PostMapping("/deleteAddress.do")
	@ResponseBody
	public String deleteAddress(@RequestParam("userAddressId") int userAddressId) {
    try{
      orderService.deleteAddress(userAddressId);
      return "SUCCESS";
    }catch(Exception e){
      return "FAIL: " + e.getMessage();
    }
	}
	
}