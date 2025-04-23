package com.bookGap.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.bookGap.vo.UserVO;

public class UserAuthenticationService implements UserDetailsService {
	
	//컴포넌트가 아니기 때문에 @Autowired 불가능
	SqlSession sqlSession;
		
	public UserAuthenticationService(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		
		//String USER_ID == 사용자 아이디
		Map<String,Object> user
			= sqlSession.selectOne("com.bookGap.mapper.userMapper.selectOneById", username);
		
		
		System.out.println("Map USER_ID : "+ (String)user.get("USER_ID"));
		
		
		int enabled_map = (Integer)user.get("USER_ENABLED");
		
		boolean enabled = false;
		
		if(enabled_map == 1) {
			enabled = true;
		}else {
			enabled = false;
		}
		
		List<GrantedAuthority> authorities = new ArrayList<>();
		
		authorities.add(new SimpleGrantedAuthority((String)user.get("USER_AUTHORITY")));
		
		UserVO vo = new UserVO(
				(String)user.get("USER_ID")
				,(String)user.get("USER_PASSWORD")
				,enabled
				,true
				,true
				,true
				,authorities
				,(String)user.get("USER_AUTHORITY")
				,(Integer)user.get("USER_STATE")
				);	
		
		return vo;
	}

}

