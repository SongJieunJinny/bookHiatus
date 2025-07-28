package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.UserAddressVO;

public interface AddressService {
	 List<UserAddressVO> getUserAddresses(String userId);
	
	boolean addUserAddress(UserAddressVO vo);
	
	boolean deleteUserAddress(int userAddressId, String userId);

}
