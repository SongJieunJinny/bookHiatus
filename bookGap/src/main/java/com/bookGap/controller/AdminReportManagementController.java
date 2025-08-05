package com.bookGap.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookGap.service.ComplainService;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.ComplainSummaryVO;
import com.bookGap.vo.ComplainVO;

@Controller
@RequestMapping("/admin")
public class AdminReportManagementController {
	@Autowired
    private ComplainService complainService;
	
	@GetMapping("/adminReportManagement.do")
    public String adminReportManagement(@RequestParam(name = "filterStatus", required = false) String status,
                                        Model model) {
        List<ComplainSummaryVO> summaryList;

        if (status != null && !status.isEmpty()) {
            summaryList = complainService.getReportSummaryByStatus(status);
        } else {
            summaryList = complainService.getReportSummary();
        }

        model.addAttribute("reportSummaryList", summaryList);
        model.addAttribute("selectedStatus", status);
        return "admin/adminReportManagement";
    }
	
	// mapComplainType 메서드 수정
	private String mapComplainType(String typeStr) {
	    switch (typeStr) {
	        case "1": return "욕설/비방";
	        case "2": return "스팸";
	        case "3": return "음란물";
	        default: return "기타";
	    }
	}

	@GetMapping("/getComplainDetail.do")
	@ResponseBody
	public Map<String, Object> getDetail(@RequestParam("commentNo") int commentNo) {
	    Map<String, Object> result = new HashMap<>();

	    List<ComplainVO> list = complainService.getComplainListByCommentNo(commentNo);
	    if (list.isEmpty()) {
	        return Collections.emptyMap(); // 또는 HTTP 204 처리 고려
	    }

	    // complainType이 문자열로 되어 있을 경우, String으로 처리
	    for (ComplainVO vo : list) {
	        vo.setComplainTypeText(mapComplainType(vo.getComplainType()));  // 수정된 메서드 호출
	    }

	    ComplainVO main = list.get(0); // 대표 신고 하나
	    result.put("main", main);
	    result.put("complainList", list);
	    return result;
	}
	
	 @PostMapping("/updateComplainStatus.do")
	 @ResponseBody
	 public String updateStatus(@RequestBody Map<String, Object> payload) {
	     try {
	         int commentNo = Integer.parseInt(payload.get("commentNo").toString());
	         int commentState = Integer.parseInt(payload.get("commentState").toString());

	         ComplainVO commentVO = new ComplainVO();
	         commentVO.setCommentNo(commentNo);
	         commentVO.setCommentState(commentState);
	         complainService.updateCommentState(commentVO);

	         Object rawList = payload.get("complainList");
	         if (!(rawList instanceof List)) {
	             return "INVALID_PAYLOAD";
	         }

	         List<?> complainList = (List<?>) rawList;
	         for (Object itemObj : complainList) {
	             if (itemObj instanceof Map) {
	                 Map<?, ?> itemMap = (Map<?, ?>) itemObj;
	                 ComplainVO vo = new ComplainVO();
	                 vo.setComplainNo(Integer.parseInt(itemMap.get("complainNo").toString()));
	                 vo.setStatus(itemMap.get("status").toString());
	                 vo.setProcessNote(itemMap.get("processNote") != null ? itemMap.get("processNote").toString() : null);
	                 complainService.updateComplainStatus(vo);
	             }
	         }

	         return "OK";

	     } catch (Exception e) {
	         e.printStackTrace();
	         return "ERROR";
	     }
	 }
	
	

}
