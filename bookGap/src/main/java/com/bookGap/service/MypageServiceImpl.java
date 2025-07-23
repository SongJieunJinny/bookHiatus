package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.bookGap.vo.MypageVO;
import com.bookGap.dao.MypageDAO;

@Service
public class MypageServiceImpl implements MypageService{

	@Autowired
	private MypageDAO mypageDAO;
	
	@Autowired
    private BCryptPasswordEncoder passwordEncoder;

	@Override
	public MypageVO getUserById(String userId) {
		return mypageDAO.selectUserById(userId);
	}
	
	@Override
	public boolean validateUser(String userId, String rawPassword) {
		MypageVO user = getUserById(userId);
        if (user == null) return false;
        return passwordEncoder.matches(rawPassword, user.getUserPw());
    }

	@Override
	public int userUpdate(MypageVO mypageVO) {
		return mypageDAO.userUpdate(mypageVO);
	}

	@Override
	public int userPwUpdate(MypageVO mypageVO) {
		return mypageDAO.userPwUpdate(mypageVO);
	}
	
}
