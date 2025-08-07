package com.bookGap.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.UserAddressVO;
import com.bookGap.vo.UserInfoVO;

@Repository
public class UserDAO {
	
	@Autowired
	private  SqlSession sqlSession;
	
	private final static String name_space = "com.bookGap.mapper.userMapper.";
	
	public int insertUser (UserInfoVO userInfoVO) {
		return sqlSession.insert(name_space+"insertUser", userInfoVO);
	}
	
	public int insertUserAddress(UserAddressVO userAddressVO) {
    return sqlSession.insert(name_space + "insertUserAddress", userAddressVO);
  }

	public  List<UserInfoVO> selectAllUser() {
		return sqlSession.selectList(name_space + "selectAllUser");
	}
	
	public UserInfoVO findByKakaoId(String kakaoId) {
		return sqlSession.selectOne(name_space + "findByKakaoId", kakaoId);
	}
	public void insertKakaoUser(UserInfoVO user) {
		sqlSession.insert(name_space + "insertKakaoUser", user);
	}
	 
	public UserInfoVO findById(String userId) {
		return sqlSession.selectOne(name_space + "findById", userId);
	}
	
	public void updateUser(UserInfoVO user) {
		sqlSession.update(name_space + "updateUser", user);
	}
	
	public int userPwUpdate (UserInfoVO user) {
	  return sqlSession.update(name_space+"userPwUpdate",user);
	}
	
	public boolean checkUserExists(String userId, String userEmail) {
    Map<String, String> params = new HashMap<>();
    params.put("userId", userId);
    params.put("userEmail", userEmail);
    // 아래 쿼리 id는 mapper.xml에 정의한 id와 일치해야 합니다.
    // 또한, 파라미터를 2개 이상 넘길 때 mapper에서 #{userId}, #{userEmail}로 받으려면
    // DAO에서 Map 이나 @Param을 써야합니다. 여기선 Map 방식을 보여드렸습니다.
    // 만약 #{param1}, #{param2} 방식을 쓰신다면 Map이 필요없습니다.
    // return sqlSession.selectOne(name_space + "checkUserExists", params) > 0;

    // #{param1}, #{param2} 로 넘기는 더 간단한 방법
    int count = sqlSession.selectOne(name_space + "checkUserExists", Map.of("param1", userId, "param2", userEmail));
    return count > 0;
}

}