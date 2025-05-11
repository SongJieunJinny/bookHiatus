package com.bookGap.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.UserInfoVO;

@Repository
public class UserDAO {
	
	@Autowired
	private SqlSession sqlSession;
	
	private final String name_space = "com.bookGap.mapper.userMapper.";
	
	public int insertUser (UserInfoVO userInfoVO) {
		return sqlSession.insert(name_space+"insertUser", userInfoVO);
	}

}
