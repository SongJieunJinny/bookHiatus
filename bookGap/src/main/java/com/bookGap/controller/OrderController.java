package com.bookGap.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.web.bind.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookGap.service.OrderService;
import com.bookGap.vo.BookVO;
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
  public String orderMain(@RequestParam(value = "isbn", required = false) String isbn, @AuthenticationPrincipal UserVO user,
                          @RequestParam(value = "quantity", defaultValue = "1") int quantity, Model model) {

	  if (isbn == null || isbn.isEmpty()) {
      model.addAttribute("errorMessage", "올바르지 않은 접근입니다. 상품을 선택해주세요.");
      return "error/errorPage"; // error/errorPage.jsp 파일을 찾게 됩니다.
    }
    
    String userId = user.getUsername();
    
    BookVO book = orderService.getBookByIsbn(isbn);
    UserAddressVO address = orderService.getDefaultAddress(userId);
    
    model.addAttribute("book", book);
    model.addAttribute("quantity", quantity);
    model.addAttribute("defaultAddress", address);
    
    return "order/orderMain";
  }

}
