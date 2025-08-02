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
	
	
	
  @PostMapping("/orderMain.do") //get으로 하면 오류나서 post로 변경했어
  public String orderMain(@RequestParam(value = "isbns", required = false) List<String> isbns,
                          @RequestParam(value = "quantities", required = false) List<Integer> quantities,
                          @RequestParam(value = "cartNos", required = false) List<Integer> cartNos,
                          @RequestParam(value = "userId", required = false) String userIdParam,
                          @RequestParam(value = "userAddressId", required = false) Integer userAddressId,
                          @RequestParam(value = "totalPrice", required = false) Integer totalPrice,
                          Principal principal,
                          Model model) {

      // 로그인 여부 체크
      if (principal == null) return "redirect:/login";
      String sessionUserId = principal.getName();
      //System.out.println("sessionUserId1"+sessionUserId);
      // 보안 상 서버 세션의 userId와 form의 userId 비교 (불일치 시 거절 가능)
      if (userIdParam != null && !userIdParam.equals(sessionUserId)) {
    	 // System.out.println("userIdParam"+userIdParam);
    	 //System.out.println("sessionUserId"+sessionUserId);
          return "redirect:/?error=invalid_user";
      }

      List<Map<String, Object>> orderItems = new ArrayList<>();

      if (isbns != null && !isbns.isEmpty()) {
          if (quantities == null || isbns.size() != quantities.size()) {
              return "redirect:/product/cart.do?error=param_mismatch";
          }

          List<BookVO> books = orderService.getBooksByIsbnList(isbns);

          for (int i = 0; i < isbns.size(); i++) {
        	    final int index = i;

        	    String currentIsbn = isbns.get(index);
        	    int currentQuantity = quantities.get(index);

        	    books.stream()
        	        .filter(b -> b.getIsbn().equals(currentIsbn))
        	        .findFirst()
        	        .ifPresent(book -> {
        	            Map<String, Object> item = new HashMap<>();
        	            item.put("book", book);
        	            item.put("quantity", currentQuantity);
        	            item.put("cartNo", (cartNos != null && cartNos.size() > index) ? cartNos.get(index) : null);
        	            orderItems.add(item);
        	        });
        	}

      } else {
          return "redirect:/?error=no_order_data";
      }

      // 기본 배송지 정보 및 주소 리스트 조회
      UserAddressVO defaultAddress = orderService.getDefaultAddress(sessionUserId);
      List<UserAddressVO> addressList = orderService.getAddressListByUserId(sessionUserId);

      model.addAttribute("orderItems", orderItems);
      model.addAttribute("defaultAddress", defaultAddress);
      model.addAttribute("addressList", addressList);
      model.addAttribute("userAddressId", userAddressId);
      model.addAttribute("totalPrice", totalPrice);

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