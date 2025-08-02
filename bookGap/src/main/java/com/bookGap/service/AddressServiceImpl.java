package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.AddressDAO;
import com.bookGap.dao.CartDAO;
import com.bookGap.vo.UserAddressVO;

@Service
public class AddressServiceImpl   implements  AddressService{
	@Autowired
    private CartDAO cartDAO;
	@Autowired
	 private AddressDAO addressDAO;
	
	 
	 @Override
	    public List<UserAddressVO> getUserAddresses(String userId) {
	        return addressDAO.selectUserAddresses(userId);
	    }

	    @Override
	    public boolean addUserAddress(UserAddressVO vo) {
	        return addressDAO.insertUserAddress(vo) > 0;
	    }

	    @Override
	    public boolean deleteUserAddress(int userAddressId, String userId) {
	        return addressDAO.deleteUserAddress(userAddressId, userId) > 0;
	    }

}
