package com.bookGap.scheduler;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.bookGap.service.AdminBookService;
import com.bookGap.vo.BookVO;

@Component
public class InventoryScheduler {
	
	@Autowired
	public AdminBookService adminBookService;
	
	@Scheduled(cron= "0 */5 * * * * ") //초 분 시 일 월 요일 연도  (cron = "0 0 0/2 * * ?") 2시간 
	public void updateBookInventoryStatus() {
        List<BookVO> books = adminBookService.adminInventoryManagementSelectAll();

        for (BookVO book : books) {
            Integer stock = book.getBookStock(); // null 안전 체크를 위해 Integer로 받음
            String state = book.getBookState();              // "0" or "1" 가정

            boolean notAlreadySoldOut = (state == null || !"0".equals(state));
            if (stock <= 1 && notAlreadySoldOut) {
                book.setBookState("0");                      // "0": 품절
                adminBookService.updateInventory(book);
                System.out.println("품절 처리된 도서 ISBN: " + book.getIsbn());
            }
        }
    }
}
