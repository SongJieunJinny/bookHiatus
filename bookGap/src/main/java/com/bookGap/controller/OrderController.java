package com.bookGap.controller;

import java.security.Principal;
import java.util.List;

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
import com.bookGap.vo.UserAddressVO;

@RequestMapping(value="/order")
@Controller
public class OrderController {
  
  @Autowired
  private OrderService orderService;
	
	@GetMapping("/orderDetails.do")
	public String orderDetails() {
		return "order/orderDetails";
	}
	
	@GetMapping("/orderMain.do")
  public String orderMain(@RequestParam(value = "isbn", required = false) String isbn,
                          @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                          Principal principal, Model model) {

	  // 로그인하지 않은 사용자는 주소 정보 없이 페이지만 보여줌
	  if(principal == null){
      model.addAttribute("book", null);
      model.addAttribute("quantity", 0);
      model.addAttribute("defaultAddress", null);
      model.addAttribute("addressList", null);
      return "order/orderMain";
    }
	  
	  // 로그인한 사용자의 ID를 가져옴
    String userId = principal.getName();
    
    BookVO book = null;
    if(isbn != null && !isbn.isEmpty()){
      book = orderService.getBookByIsbn(isbn);
    }

    UserAddressVO defaultAddress = orderService.getDefaultAddress(userId);
    List<UserAddressVO> addressList = orderService.getAddressListByUserId(userId);

    model.addAttribute("book", book);
    model.addAttribute("quantity", quantity);
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