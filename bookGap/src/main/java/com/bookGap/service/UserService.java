package com.bookGap.service;

import com.bookGap.vo.UserAddressVO;
import com.bookGap.vo.UserInfoVO;

public interface UserService {
	
	public int insertUser(UserInfoVO userInfoVO);
	
	public boolean joinUserAndAddress(UserInfoVO userInfoVO, UserAddressVO userAddressVO);
	
	public UserInfoVO findByKakaoId(String kakaoId);
	
	public void insertKakaoUser(UserInfoVO user);
	
	public UserInfoVO findById(String userId);
	
	public int userPwUpdate(UserInfoVO user);
	
	public boolean checkUserExists(String userId, String userEmail);
	
}