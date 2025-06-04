package com.bookGap.controller;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.bookGap.service.AdminScheduleService;
import com.bookGap.vo.ScheduleVO;

@Controller
@RequestMapping("/admin/schedule")
public class AdminScheduleController {
	@Autowired
    private AdminScheduleService adminScheduleService;

    // 일정 전체 조회 (FullCalendar 로드용)
	@GetMapping("/list")
	@ResponseBody
	public List<Map<String, Object>> getAllSchedules() {
	    List<ScheduleVO> schedules = adminScheduleService.getAllSchedules();
	    List<Map<String, Object>> result = new ArrayList<>();

	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm"); // FullCalendar에 맞춤

	    for (ScheduleVO vo : schedules) {
	        String eventStart = (vo.getStartDate() != null) ? sdf.format(vo.getStartDate()) : null;
	        String eventEnd = (vo.getEndDate() != null) ? sdf.format(vo.getEndDate()) : null;

	        Map<String, Object> event = new HashMap<>();
	        event.put("id", vo.getScheduleId());
	        event.put("title", vo.getTitle());
	        event.put("start", eventStart);
	        event.put("end", eventEnd);
	        event.put("backgroundColor", vo.getColor());
	        event.put("borderColor", vo.getColor());
	        event.put("allDay", false);

	        System.out.println("▶▶▶ [컨트롤러] FullCalendar에 보낼 데이터: " + event);
	        result.add(event);
	    }
	    System.out.println("▶▶▶ [컨트롤러] 최종 반환할 데이터: " + result);
	    return result;
	}

	 @PostMapping("/insert")
	    @ResponseBody
	    public String insertSchedule(@RequestBody ScheduleVO scheduleVO) {
		 	System.out.println("▶▶▶ [컨트롤러] 일정 등록 요청: " + scheduleVO);
		    adminScheduleService.insertSchedule(scheduleVO);
		    return "success";
	    }

	    @PostMapping("/update")
	    @ResponseBody
	    public String updateSchedule(@RequestBody ScheduleVO scheduleVO) {
	    	 	System.out.println("▶▶▶ [컨트롤러] 일정 수정 요청: " + scheduleVO);
	    	    adminScheduleService.updateSchedule(scheduleVO);
	    	    return "success";
	    }

	    @PostMapping("/delete")
	    @ResponseBody
	    public String deleteSchedule(@RequestParam int scheduleId) {
	        adminScheduleService.deleteSchedule(scheduleId);
	        return "success";
	    }

}
