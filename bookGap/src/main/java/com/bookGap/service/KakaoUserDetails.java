package com.bookGap.service;

import java.util.Collection;
import java.util.Collections;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.bookGap.vo.UserInfoVO;

public class KakaoUserDetails implements UserDetails {
	  private final UserInfoVO user;

	    public KakaoUserDetails(UserInfoVO user) {
	        this.user = user;
	    }

	    // 권한 반환
	    @Override
	    public Collection<? extends GrantedAuthority> getAuthorities() {
	        return Collections.singleton(new SimpleGrantedAuthority(user.getUserAuthority()));
	    }

	    @Override
	    public String getPassword() {
	        return ""; // 카카오는 비밀번호가 없음 (소셜 로그인)
	    }

	    @Override
	    public String getUsername() {
	        return user.getUserId(); // 또는 user.getKakaoId()
	    }

	    @Override
	    public boolean isAccountNonExpired() {
	        return true; // 계정 만료 X
	    }

	    @Override
	    public boolean isAccountNonLocked() {
	        return true; // 계정 잠김 X
	    }

	    @Override
	    public boolean isCredentialsNonExpired() {
	        return true; // 자격 증명 만료 X
	    }

	    @Override
	    public boolean isEnabled() {
	        return user.isUserEnabled();
	    }

	    // 추가적으로 필요한 getter
	    public UserInfoVO getUser() {
	        return user;
	    }
}
