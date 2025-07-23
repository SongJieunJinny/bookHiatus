package com.bookGap.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.MypageVO;

@Repository
public class MypageDAO {
	
	@Autowired
	private SqlSession sqlSession;
	
	private final String name_space = "com.bookGap.mapper.mypageMapper.";
	

	public MypageVO selectUserById(String userId) {
	    MypageVO vo = sqlSession.selectOne(name_space + "selectUserById", userId);
	    return vo;
	}
	
	public int userUpdate (MypageVO mypageVO) {
		return sqlSession.update(name_space+"userUpdate",mypageVO);
	} 
	
	public int userPwUpdate (MypageVO mypageVO) {
		return sqlSession.update(name_space+"userPwUpdate",mypageVO);
	}
	
	  public int updateKakaoUser(MypageVO mypageVO) {
	        System.out.println("[DAO] updateKakaoUser 호출됨");
	        System.out.println("[DAO] 파라미터: userId=" + mypageVO.getUserId()
	            + ", kakaoId=" + mypageVO.getKakaoId()
	            + ", userName=" + mypageVO.getUserName()
	            + ", userPhone=" + mypageVO.getUserPhone()
	            + ", userEmail=" + mypageVO.getUserEmail());
	        
	        int rows = sqlSession.update(name_space + "updateKakaoUser", mypageVO);
	        System.out.println("[DAO] update 결과: " + rows + "건 수정됨");
	        return rows;
	    }
	
}
