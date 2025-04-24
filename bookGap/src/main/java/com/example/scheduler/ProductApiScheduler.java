package com.example.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class ProductApiScheduler {
	
	@Scheduled(cron= "0 0 12 1/1 *  * ") //초 분 시 일 월 요일 연도
	public void  productApiScheduler() throws Exception{
		
		System.out.println("스케줄러 실행됨");
		
		
		
		
	}
}
