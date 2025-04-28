package com.bookGap.vo;

import java.util.List;
import lombok.Data;

@Data
public class NaverBookResponse {
	 private List<ProductApiVO> items;

	public List<ProductApiVO> getItems() {
		return items;
	}

	public void setItems(List<ProductApiVO> items) {
		this.items = items;
	}
	 
}
