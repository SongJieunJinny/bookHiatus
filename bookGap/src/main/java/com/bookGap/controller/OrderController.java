package com.bookGap.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.web.bind.annotation.AuthenticationPrincipal;
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
import com.bookGap.vo.UserVO;

@RequestMapping(value="/order")
@Controller
public class OrderController {
  
  @Autowired
  private OrderService orderService;
	
	@GetMapping("/orderDetails.do")
	public String orderDetails() {
		return "/orderDetails";
	}
	
	@GetMapping("/orderMain.do")
  public String orderMain(@RequestParam(value = "isbn", required = false) String isbn,
                          @AuthenticationPrincipal UserVO user, Model model, 
                          @RequestParam(value = "quantity", defaultValue = "1") int quantity) {

	  if(user == null){
      model.addAttribute("book", null);
      model.addAttribute("quantity", 0);
      model.addAttribute("defaultAddress", null);
      model.addAttribute("addressList", null);
      return "order/orderMain";
    }

    String userId = user.getUsername();
    
    BookVO book = null;
    if (isbn != null && !isbn.isEmpty()) {
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
	public String addAddress(@RequestBody UserAddressVO addressVO, @AuthenticationPrincipal UserVO user) {
    try{
      addressVO.setUserId(user.getUsername()); // 현재 로그인한 사용자 ID 설정
      orderService.addAddress(addressVO); // 서비스에 주소 추가 로직 호출
      return "SUCCESS";
    }catch(Exception e){
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