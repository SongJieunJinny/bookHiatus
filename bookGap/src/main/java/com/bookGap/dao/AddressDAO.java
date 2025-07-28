package com.bookGap.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.UserAddressVO;
@Repository
public class AddressDAO {
	@Autowired
	private SqlSession sqlSession;
	
	 private final String namespace = "com.bookGap.mapper.AddressMapper.";
	 
	 public List<UserAddressVO> selectUserAddresses(String userId) {
	        return sqlSession.selectList(namespace + "selectUserAddresses", userId);
	    }

	    public int insertUserAddress(UserAddressVO vo) {
	        return sqlSession.insert(namespace + "insertUserAddress", vo);
	    }

	    public int deleteUserAddress(int userAddressId, String userId) {
	        Map<String, Object> params = new HashMap<>();
	        params.put("userAddressId", userAddressId);
	        params.put("userId", userId);
	        return sqlSession.delete(namespace + "deleteUserAddress", params);
	    }

}
