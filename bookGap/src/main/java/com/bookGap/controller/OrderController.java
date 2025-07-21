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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.OrderService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.CommentVO;
import com.bookGap.vo.UserAddressVO;
import com.bookGap.vo.UserVO;

@RequestMapping(value="/order")
@Controller
public class OrderController {
  
  @Autowired
  private OrderService orderService;
	
	@RequestMapping(value = "/orderDetails.do", method = RequestMethod.GET)
	public String orderDetails() {

		return "/orderDetails";
	}
	
	@GetMapping("/orderMain.do")
  public String orderMain(@RequestParam(value = "isbn") String isbn, @AuthenticationPrincipal UserVO user,
                          @RequestParam(value = "quantity", defaultValue = "1") int quantity, Model model) {

	  if (isbn == null || isbn.isEmpty()) {
      model.addAttribute("errorMessage", "올바르지 않은 접근입니다. 상품을 선택해주세요.");
      return "error/errorPage"; // error/errorPage.jsp 파일을 찾게 됩니다.
    }
    
    String userId = user.getUsername();
    
    BookVO book = orderService.getBookByIsbn(isbn);  // 1. 주문할 단일 상품 정보
    
    UserAddressVO defaultAddress = orderService.getDefaultAddress(userId);  // 2. 화면 상단에 표시될 기본 배송지 정보

    List<UserAddressVO> addressList = orderService.getAddressListByUserId(userId);  // 3. (추가) 배송지 변경 모달에 필요한 전체 주소 목록
    
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
	public String deleteAddress(@RequestParam("userAddressId") int userAddressId, @AuthenticationPrincipal UserVO user) {
    try{
      orderService.deleteAddress(userAddressId);
      return "SUCCESS";
    }catch(Exception e){
      return "FAIL: " + e.getMessage();
    }
	}
	
}