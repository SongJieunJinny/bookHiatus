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
	public UserDetails loadUserByUsername(String USER_ID) throws UsernameNotFoundException {
		
		//String USER_ID == 사용자 아이디
		Map<String,Object> user
			= sqlSession.selectOne("com.bookGap.mapper.userMapper.selectOneById", USER_ID);
		System.out.println("DB 조회 결과: " + user);
		
		
		System.out.println("Map USER_ID : "+ (String)user.get("USER_ID"));
		
		String password = (String) user.get("USER_PW");
		System.out.println("조회된 USER_PW: " + password);
		
		int enabled_map = (Integer)user.get("USER_ENABLED");
		boolean enabled = (enabled_map == 1);
		
		List<GrantedAuthority> authorities = new ArrayList<>();
		
		authorities.add(new SimpleGrantedAuthority((String)user.get("USER_AUTHORITY")));
		
		UserVO vo = new UserVO(
				(String)user.get("USER_ID")
				,(String)user.get("USER_PW")
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