package com.bookGap.service;

import com.bookGap.vo.MypageVO;

public interface MypageService {

	// 사용자 정보 조회
	MypageVO getUserById(String userId);

    // 본인 확인 (비밀번호 체크 포함)
    boolean validateUser(String userId, String rawPassword);
    
    // 사용자 정보 변경
    int userUpdate (MypageVO mypageVO);
    
   // 사용자 비밀번호 변경
    int userPwUpdate(MypageVO mypageVO);
    // 카카오 사용자 정보 변경 (비밀번호 제외)
    int updateKakaoUser(MypageVO mypageVO); 
}
