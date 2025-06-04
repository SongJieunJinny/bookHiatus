package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.AdminScheduleDAO;
import com.bookGap.vo.ScheduleVO;

@Service
public class AdminScheduleServiceImpl implements   AdminScheduleService{
	
	
	 @Autowired
	    private AdminScheduleDAO adminScheduleDAO;

	    @Override
	    public int insertSchedule(ScheduleVO scheduleVO) {
	        return adminScheduleDAO.insertSchedule(scheduleVO);
	    }

	    @Override
	    public List<ScheduleVO> getAllSchedules() {
	        return adminScheduleDAO.getAllSchedules();
	    }

	    @Override
	    public int updateSchedule(ScheduleVO scheduleVO) {
	        return adminScheduleDAO.updateSchedule(scheduleVO);
	    }

	    @Override
	    public int deleteSchedule(int scheduleId) {
	        return adminScheduleDAO.deleteSchedule(scheduleId);
	    }
	
	

}
