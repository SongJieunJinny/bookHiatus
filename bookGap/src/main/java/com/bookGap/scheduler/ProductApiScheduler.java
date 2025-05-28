package com.bookGap.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.bookGap.service.ProductApiService;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class ProductApiScheduler {
	
	//@Autowired
	//public ProductApiService productApiService;
	
	//@Scheduled(cron= "0 */5 * * * * ") //초 분 시 일 월 요일 연도
	//public void  fetchBooks() throws Exception{

		//productApiService.fetchAndStoreBooksByCategory();
		//System.out.println("스케줄러 실행됨");

	//}
}
