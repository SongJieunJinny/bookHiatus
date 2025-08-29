package com.bookGap.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookGap.vo.ScheduleVO;

@Repository
public class AdminScheduleDAO {
	
	  @Autowired
	    private SqlSession sqlSession;

	    private final String namespace = "com.bookGap.mapper.AdminScheduleMapper.";

	    // 일정 등록
	    public int insertSchedule(ScheduleVO scheduleVO) {
	        return sqlSession.insert(namespace + "insertSchedule", scheduleVO);
	    }

	    // 일정 조회 (전체)
	    public List<ScheduleVO> getAllSchedules() {
	        return sqlSession.selectList(namespace + "getAllSchedules");
	    }

	    // 일정 수정
	    public int updateSchedule(ScheduleVO scheduleVO) {
	        return sqlSession.update(namespace + "updateSchedule", scheduleVO);
	    }

	    // 일정 삭제
	    public int deleteSchedule(int scheduleId) {
	        return sqlSession.delete(namespace + "deleteSchedule", scheduleId);
	    }
	    
	    public List<Map<String, Object>> getScheduleCountByWeekday() {
	        return sqlSession.selectList(namespace + "getScheduleCountByWeekday");
	    }

}
