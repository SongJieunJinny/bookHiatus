package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookGap.dao.UserDAO;
import com.bookGap.vo.MypageVO;
import com.bookGap.vo.UserAddressVO;
import com.bookGap.vo.UserInfoVO;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDAO userDAO;
	
	@Override
	public int insertUser(UserInfoVO userInfoVO) {
		return userDAO.insertUser(userInfoVO);
	}
	@Override
  public UserInfoVO findByKakaoId(String  kakaoId) {
    return userDAO.findByKakaoId( kakaoId);
  }

  @Override
  public void insertKakaoUser(UserInfoVO user) {
    userDAO.insertKakaoUser(user);
  }
    
  @Override
  public UserInfoVO findById(String userId) {
    return userDAO.findById(userId);
  }
    
  @Override
  @Transactional
  public boolean joinUserAndAddress(UserInfoVO userInfoVO, UserAddressVO userAddressVO) {
    try{
      //회원 정보 저장
      int userInsertCount = userDAO.insertUser(userInfoVO);
      if(userInsertCount == 0){
        
        return false;
      }
      if(userAddressVO != null && userAddressVO.getPostCode() != null && !userAddressVO.getPostCode().isEmpty()){
        userAddressVO.setUserId(userInfoVO.getUserId());     // FK 설정
        userAddressVO.setUserName(userInfoVO.getUserName());   // 받는 사람 이름 설정
        userAddressVO.setUserPhone(userInfoVO.getUserPhone()); // 받는 사람 연락처 설정
  
        int addressInsertCount = userDAO.insertUserAddress(userAddressVO);
        if(addressInsertCount == 0){
            throw new RuntimeException("주소 정보 저장에 실패했습니다.");
        }
      }
      
      return true;
    }catch(Exception e){
      System.err.println("회원가입 트랜잭션 실패: " + e.getMessage());
      
      throw new RuntimeException(e);
    }
  }
  
  @Override
  public int userPwUpdate(UserInfoVO user) {
    return userDAO.userPwUpdate(user);
  }
  
  @Override
  public boolean checkUserExists(String userId, String userEmail) {
      return userDAO.checkUserExists(userId, userEmail);
  }
}
