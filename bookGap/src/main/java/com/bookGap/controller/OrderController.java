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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.OrderService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.OrderVO;
import com.bookGap.vo.UserAddressVO;

@Controller
public class OrderController {
  
  @Autowired
  private OrderService orderService;
	
  @GetMapping("/order/orderDetails.do")
  public String orderDetails(Principal principal, Model model) {
    if(principal == null){
      return "redirect:/login"; // 비로그인 시 로그인 페이지로
    }
    String userId = principal.getName();
    List<OrderVO> orderList = orderService.getOrdersByUser(userId);
    model.addAttribute("orderList", orderList);
    return "order/orderDetails";
  }
	
  /*  '회원'이 주문 페이지로 진입 */
  @PostMapping("/order/orderMain.do") 
  public String orderMain(@RequestParam(value = "isbns", required = false) List<String> isbns,
                          @RequestParam(value = "quantities", required = false) List<Integer> quantities,
                          @RequestParam(value = "cartNos", required = false) List<Integer> cartNos,
                          @RequestParam(value = "userId", required = false) String userIdParam,
                          @RequestParam(value = "userAddressId", required = false) Integer userAddressId,
                          @RequestParam(value = "totalPrice", required = false) Integer totalPrice,
                          Principal principal, Model model) {

    // 로그인 여부 체크
    if (principal == null) return "redirect:/login";
    String sessionUserId = principal.getName();

    if(userIdParam != null && !userIdParam.equals(sessionUserId)){
      return "redirect:/?error=invalid_user";
    }

    List<Map<String, Object>> orderItems = new ArrayList<>();
   System.out.println("orderItems"+orderItems);

    if(isbns != null && !isbns.isEmpty()){
      if(quantities == null || isbns.size() != quantities.size()){
        return "redirect:/product/cart.do?error=param_mismatch";
      }
      
      List<BookVO> books = orderService.getBooksByIsbnList(isbns);

      for(int i = 0; i < isbns.size(); i++){
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

    }else{
      return "redirect:/?error=no_order_data";
    }

    // 기본 배송지 정보 및 주소 리스트 조회
    UserAddressVO defaultAddress = orderService.getDefaultAddress(sessionUserId);
    List<UserAddressVO> addressList = orderService.getAddressList(sessionUserId);
    System.out.println("orderItems"+orderItems);
    model.addAttribute("orderItems", orderItems);
    model.addAttribute("defaultAddress", defaultAddress);
    model.addAttribute("addressList", addressList);
    model.addAttribute("userAddressId", userAddressId);
    System.out.println("userAddressId"+userAddressId);
    model.addAttribute("totalPrice", totalPrice);

    return "order/orderMain";
  }

  /*  회원 주문 페이지의 '주소록 추가' 팝업 */
	@PostMapping("/addAddress.do")
	@ResponseBody 
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
	    orderService.registerAddress(addressVO);
      return "SUCCESS";
    }catch(Exception e){
      System.out.println("### 데이터베이스 저장 실패! 전달된 VO 정보: " + addressVO.toString()); 
      e.printStackTrace();
      return "FAIL: " + e.getMessage();
    }
  }
	
	/* 주소 삭제 */
	@PostMapping("/deleteAddress.do")
	@ResponseBody
	public String deleteAddress(@RequestParam("userAddressId") int userAddressId) {
    try{
      orderService.removeAddress(userAddressId);
      return "SUCCESS";
    }catch(Exception e){
      return "FAIL: " + e.getMessage();
    }
	}
	
	/* '비회원' 주문 처리 */
	@PostMapping("/guest/processOrder.do")
  @ResponseBody
  public Map<String, Object> processGuestOrder(@RequestBody Map<String, Object> orderData) {
    
    Map<String, Object> response = new HashMap<>();
    try {
        orderService.createGuestOrder(orderData); 
        response.put("status", "Success");
        response.put("message", "주문이 성공적으로 접수되었습니다.");

    } catch (Exception e) {
        response.put("status", "Error");
        response.put("message", "주문 처리 중 오류 발생: " + e.getMessage());
        e.printStackTrace();
    }
    
    return response; // 프론트엔드에 성공/실패 결과를 반환
  }
	
	/* 비회원 주문 페이지 */
	@GetMapping("/guest/guestOrder.do")
	public String showGuestOrderPage(
	    @RequestParam(value = "isbns", required = false) List<String> isbns,
	    @RequestParam(value = "quantities", required = false) List<Integer> quantities,
	    @RequestParam(value = "isbn", required = false) String isbn, 
	    @RequestParam(value = "quantity", required = false) Integer quantity,
	    @RequestParam(value = "totalPrice", required = false) Integer totalPrice,
	    Model model) {
		
		System.out.println("받은 isbns: " + isbns);
		System.out.println("받은 quantities: " + quantities);
		System.out.println("단일 isbn: " + isbn + ", quantity: " + quantity);

	    List<BookVO> books = new ArrayList<>();
	    List<Integer> qtys = new ArrayList<>();

	    if (isbns != null && !isbns.isEmpty()) {
	        books = orderService.getBooksByIsbnList(isbns);
	        qtys = quantities;
	    } else if (isbn != null && quantity != null) {
	        BookVO book = orderService.getBookByIsbn(isbn);
	        if (book != null) {
	            books.add(book);
	            qtys.add(quantity);
	        } else {
	            return "redirect:/?error=book_not_found";
	        }
	    } else {
	        return "redirect:/?error=no_data";
	    }

	    model.addAttribute("bookList", books);
	    model.addAttribute("quantityList", qtys);
	    return "guest/guestOrder";  // guestOrder.jsp
	}
	
	@GetMapping("/order/orderMain.do")
	public String orderMainForGuest(@RequestParam("isbn") String isbn,
	                                @RequestParam("quantity") int quantity,
	                                Model model) {

	    BookVO book = orderService.getBookByIsbn(isbn);
	    if (book == null) {
	        model.addAttribute("errorMessage", "상품 정보를 찾을 수 없습니다.");
	        return "error/404";
	    }

	    model.addAttribute("book", book);
	    model.addAttribute("quantity", quantity);
	    
	    return "order/orderMain";  
	}
}