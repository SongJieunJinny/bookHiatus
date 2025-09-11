package com.bookGap.service;

import org.springframework.http.HttpHeaders;

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
    public ProductApiVO fetchAndStoreBooksByCategory(String searchKeyword) {
        try {
           String encodedTitle = searchKeyword;
           System.out.println("검색어들어옴 "+searchKeyword);
           String apiUrl = "https://openapi.naver.com/v1/search/book.json?query=" + encodedTitle + "&display=1";

            System.out.println("NAVER API 호출 URL:" + apiUrl);

            HttpHeaders headers = new HttpHeaders();
            headers.set("X-Naver-Client-Id", "5or5pHzpLqM1xNLNfCw3");
            headers.set("X-Naver-Client-Secret", "7f_dQthAKG");

            HttpEntity<String> entity = new HttpEntity<>(headers);
           
            ResponseEntity<NaverBookResponse> response = restTemplate.exchange(
	             apiUrl,
	             HttpMethod.GET,
	             entity,
	             NaverBookResponse.class
            	);
            ResponseEntity<String> rawResponse = restTemplate.exchange(
            	    apiUrl,
            	    HttpMethod.GET,
            	    entity,
            	    String.class
            	);
            System.out.println("응답 JSON:\n" + rawResponse.getBody());
            System.out.println("NAVER API 응답 상태:"+response.getStatusCode());

            if (response.getStatusCode().is2xxSuccessful()
                    && response.getBody() != null
                    && !response.getBody().getItems().isEmpty()) {

                ProductApiVO book = response.getBody().getItems().get(0);
                System.out.println("도서 정보: {}"+book);
                System.out.println("응답 아이템 수: " + response.getBody().getItems().size());

                if (book.getIsbn() != null && !book.getIsbn().isBlank()
                        && !productApiDAO.existsByIsbn(book.getIsbn())) {
                    productApiDAO.insertProductApi(book);
                }
                System.out.println("응답 전체 내용: " + response.getBody());
                return book;
            }

        } catch (HttpClientErrorException httpEx) {
            System.out.println("NAVER API 요청 오류: {}"+ httpEx.getResponseBodyAsString());
        } catch (Exception e) {
            System.out.println("예외 발생: "+ e);
        }
        
        return null;
    }
    
    //@Override
    //public List<ProductApiVO> selectBookImg(){
    	// return productApiDAO.selectBookImg();
   // }
}
