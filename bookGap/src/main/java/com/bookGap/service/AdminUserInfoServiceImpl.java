package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.UserDAO;
import com.bookGap.vo.UserInfoVO;



@Service
public class AdminUserInfoServiceImpl  implements  AdminUserInfoService {
	 @Autowired
	 private UserDAO userDAO;
	 
	 @Override
	 public List<UserInfoVO> getAllUser(){
		  return userDAO.selectAllUser();
	 }
	 
	 @Override
		public void updateUser(UserInfoVO user) {
		 userDAO.updateUser(user);  
		}


	
}
