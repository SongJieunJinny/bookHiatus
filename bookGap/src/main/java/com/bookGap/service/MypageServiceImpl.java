package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
	@Transactional
	public int userUpdate(MypageVO mypageVO) {
	    // USER 테이블 업데이트
	    int updated = mypageDAO.userUpdate(mypageVO);

	    // 주소 업서트
	    int count = mypageDAO.countDefaultAddressByUserId(mypageVO.getUserId());
	    if (count > 0) {
	        mypageDAO.updateDefaultAddress(mypageVO);
	    } else {
	        mypageDAO.insertDefaultAddress(mypageVO);
	    }

	    return updated;
	}


	@Override
	public int userPwUpdate(MypageVO mypageVO) {
		return mypageDAO.userPwUpdate(mypageVO);
	}
	 
}
