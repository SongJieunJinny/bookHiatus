package com.bookGap.service;

import java.util.List;
import com.bookGap.vo.UserInfoVO;

public interface UserService {
	
	public int insertUser(UserInfoVO userInfoVO);
	UserInfoVO findByKakaoId(String kakaoId);
	void insertKakaoUser(UserInfoVO user);
	UserInfoVO findById(String userId);

}
