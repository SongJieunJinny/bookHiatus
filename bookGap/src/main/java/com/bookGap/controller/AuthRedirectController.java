package com.bookGap.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class AuthRedirectController {
	
	@PostMapping("/auth/saveRedirect.do")
    @ResponseBody
    public Map<String, Object> saveRedirect(@RequestParam("redirectUrl") String redirectUrl,
                                            HttpSession session) {
        // ★ SuccessHandler가 읽는 키와 반드시 동일해야 함
        session.setAttribute("redirectAfterLogin", redirectUrl);

        Map<String, Object> res = new HashMap<>();
        res.put("ok", true);
        return res;
    }

}
