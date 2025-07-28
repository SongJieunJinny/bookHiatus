package com.bookGap.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookGap.service.AddressService;
import com.bookGap.vo.UserAddressVO;

@Controller 
public class AddressController {
	 @Autowired
	    private AddressService addressService;
	 
	 
	 @GetMapping("/address/list.do")
	    public List<UserAddressVO> getUserAddresses(Principal principal) {
	        if (principal == null) return List.of();  // 로그인 안 된 경우 빈 리스트
	        return addressService.getUserAddresses(principal.getName());
	    }

	    /** [회원] 배송지 추가 */
	    @PostMapping("/address/add")
	    public String addUserAddress(@RequestBody UserAddressVO vo, Principal principal) {
	        if (principal == null) return "NOT_LOGGED_IN";
	        vo.setUserId(principal.getName());
	        return addressService.addUserAddress(vo) ? "SUCCESS" : "FAIL";
	    }

	    /** [회원] 배송지 삭제 */
	    @PostMapping("/address/delete")
	    public String deleteUserAddress(@RequestParam("addressId") int userAddressId, Principal principal) {
	        if (principal == null) return "NOT_LOGGED_IN";
	        return addressService.deleteUserAddress(userAddressId, principal.getName()) ? "SUCCESS" : "FAIL";
	    }

}
