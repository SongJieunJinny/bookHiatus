package com.bookGap.vo;

import lombok.Data;

@Data
public class ProductApiVO {
	  private String isbn;
	  private String title;//책제
	  private Integer discount; //판매가
	  private String pubdate;//출간
	  private String publisher;//출판
	  private String author;//저자이
	  private String description;//책소
	  private String image;//섬네일URL
	  private String link;//도서정보 url
	  
		public String getIsbn() {
			return isbn;
		}
		public void setIsbn(String isbn) {
			this.isbn = isbn;
		}
		public String getTitle() {
			return title;
		}
		public void setTitle(String title) {
			this.title = title;
		}
		public int getDiscount() {
			return discount;
		}
		public void setDiscount(int discount) {
			this.discount = discount;
		}
		public String getPubdate() {
			return pubdate;
		}
		public void setPubdate(String pubdate) {
			this.pubdate = pubdate;
		}
		public String getPublisher() {
			return publisher;
		}
		public void setPublisher(String publisher) {
			this.publisher = publisher;
		}
		public String getAuthor() {
			return author;
		}
		public void setAuthor(String author) {
			this.author = author;
		}
		public String getDescription() {
			return description;
		}
		public void setDescription(String description) {
			this.description = description;
		}
		public String getImage() {
			return image;
		}
		public void setImage(String image) {
			this.image = image;
		}
		public String getLink() {
			return link;
		}
		public void setLink(String link) {
			this.link = link;
		}

	  
}
