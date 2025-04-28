package com.bookGap.service;

import org.springframework.http.HttpHeaders;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.bookGap.dao.ProductApiDAO;
import com.bookGap.vo.NaverBookResponse;
import com.bookGap.vo.ProductApiVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor 
	//private final 붙은 필드들을 생성자 주입 받을 수 있게 자동 생성자를 만들어 줍니다.
public class ProductApiServiceImpl implements ProductApiService {
	
	@Autowired
	public ProductApiDAO  productApiDAO ;
	
	private final RestTemplate restTemplate = new RestTemplate();

	@Override
    public void fetchAndStoreBooksByCategory(String categoryId) {
		String title = URLEncoder.encode("컴퓨터", StandardCharsets.UTF_8);
		String apiUrl = "https://openapi.naver.com/v1/search/book_adv.json?d_titl=" + title + "&d_catg=" + categoryId;
        System.out.println("호출 URL: " + apiUrl);
        
        // 인증 정보 추가
        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", "5or5pHzpLqM1xNLNfCw3");
        headers.set("X-Naver-Client-Secret", "7f_dQthAKG");

        HttpEntity<String> entity = new HttpEntity<>(headers);

        try {
            // 헤더가 포함된 GET 요청
            ResponseEntity<NaverBookResponse> response = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.GET,
                    entity,
                    NaverBookResponse.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                NaverBookResponse body = response.getBody();
                if (body.getItems() != null) {
                    System.out.println("응답받은 책 개수: " + body.getItems().size());
                    for (ProductApiVO book : body.getItems()) {
                        System.out.println("책 제목: " + book.getTitle() + ", ISBN: " + book.getIsbn());

                        if (book.getIsbn() != null && !book.getIsbn().isBlank() && !productApiDAO.existsByIsbn(book.getIsbn())) {
                            productApiDAO.insertProductApi(book);
                            System.out.println("저장 완료: " + book.getTitle());
                        } else {
                            System.out.println("저장 스킵됨(ISBN 없음 또는 이미 존재): " + book.getTitle());
                        }
                    }
                } else {
                    System.out.println("items가 없습니다. body: " + body);
                }
            } else {
                System.out.println("응답은 성공했지만 body가 비어있음.");
            }
        } catch (HttpClientErrorException e) {
            // HTTP 오류가 발생했을 경우 응답 메시지 출력
            System.out.println("HTTP 오류 발생: " + e.getStatusCode());
            System.out.println("응답 메시지: " + e.getResponseBodyAsString());
        } catch (Exception e) {
            // 다른 예외 처리
            System.out.println("예기치 않은 오류 발생: " + e.getMessage());
        }
    }
}
