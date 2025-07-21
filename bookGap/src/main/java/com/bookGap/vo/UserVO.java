package com.bookGap.vo;

import java.util.Collection;
import java.util.Collections;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;


public class UserVO  extends User {
	private String userId; //아이디
	private String userPw; //비밀번호
	private boolean userEnabled; //활성화여부(1활성화, 2비활성화)
	private String userAuthority; //권한
	private int userState; //가입여부(1 가입상태, 2 탈퇴상태)

//2. 생성자 직접 작성
  
 /**
  * [이것이 에러 해결의 핵심입니다]
  * Spring이 내부적으로 객체를 만들 때 사용하는, 매개변수 없는 기본 생성자입니다.
  * 부모 클래스(User)가 기본 생성자가 없으므로, super()를 이용해 부모 생성자를 직접 호출해줍니다.
  */
  public UserVO() {
    // 부모 클래스 생성자에 임시 기본값을 넘겨줍니다.
    super("anonymousUser", "password", Collections.emptyList()); 
  }
	
	public UserVO(String username, String password, boolean enabled, boolean accountNonExpired,
			          boolean credentialsNonExpired, boolean accountNonLocked,
			          Collection<? extends GrantedAuthority> authorities,String authority, int user_state) {
		      super(username, password, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked, authorities);
		
		this.userId = username;
		this.userPw = password;
		this.userEnabled = enabled;
		this.userAuthority = authority;
		this.userState = user_state;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPw() {
		return userPw;
	}

	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}

	public boolean isUserEnabled() {
		return userEnabled;
	}

	public void setUserEnabled(boolean userEnabled) {
		this.userEnabled = userEnabled;
	}

	public String getUserAuthority() {
		return userAuthority;
	}

	public void setUserAuthority(String userAuthority) {
		this.userAuthority = userAuthority;
	}

	public int getUserState() {
		return userState;
	}

	public void setUserState(int userState) {
		this.userState = userState;
	}
}
