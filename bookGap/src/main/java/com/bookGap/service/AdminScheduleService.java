package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.ScheduleVO;

public interface AdminScheduleService {
	// 일정 등록
    int insertSchedule(ScheduleVO scheduleVO);

    // 일정 전체 조회
    List<ScheduleVO> getAllSchedules();

    // 일정 수정
    int updateSchedule(ScheduleVO scheduleVO);

    // 일정 삭제
    int deleteSchedule(int scheduleId);

}
