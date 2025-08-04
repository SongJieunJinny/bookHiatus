package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.UserInfoVO;

public interface AdminUserInfoService {
	List<UserInfoVO> getAllUser();
	void updateUser(UserInfoVO user);
	

}
