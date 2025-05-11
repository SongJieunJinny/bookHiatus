package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.UserDAO;
import com.bookGap.vo.UserInfoVO;
import com.bookGap.service.UserService;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDAO userDAO;
	
	@Override
	public int insertUser(UserInfoVO userInfoVO) {
		return userDAO.insertUser(userInfoVO);
	}
}
