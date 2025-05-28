package com.bookGap.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CommentDAO {
	
	@Autowired 
	private SqlSession sqlSession;
	
	private final String name_space = "com.bookGap.mapper.commentMapper.";

}
