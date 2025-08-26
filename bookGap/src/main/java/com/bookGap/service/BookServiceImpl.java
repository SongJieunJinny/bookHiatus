package com.bookGap.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.BookDAO;
import com.bookGap.vo.BookVO;
import com.bookGap.vo.ProductApiVO;
import com.bookGap.vo.SearchVO;

@Service
public class BookServiceImpl implements BookService{
	
	@Autowired
    private BookDAO bookDAO;
	
	 @Override
	 public List<ProductApiVO> getBooksWithProductInfo() {
	    return bookDAO.selectBooksWithProductInfo();
	 }
	 
	 @Override
	 public List<String> getDistinctCategories() {
	     return bookDAO.selectDistinctCategories();
	 }
	 
	 @Override
	 public List<ProductApiVO> getBooksByCategory(String category) {
	     return bookDAO.selectBooksByCategory(category);
	 }
	 
	 @Override
	 public List<ProductApiVO> getBooksPaging(SearchVO vo) {
	     return bookDAO.selectBooksPaging(vo);
	 }

	 @Override
	 public List<ProductApiVO> getBooksByCategoryPaging(SearchVO vo) {
	     return bookDAO.selectBooksByCategoryPaging(vo);
	 }

	 @Override
	 public int getTotalBookCount(SearchVO vo) {
	     return bookDAO.getBookTotalCount(vo);
	 }

	 @Override
	 public int getTotalByCategory(SearchVO vo) {
	     return bookDAO.getBookTotalCountByCategory(vo);
	 }
	 
	 @Override
	 public BookVO getBookDetailByIsbn(String isbn) {
	     return bookDAO.selectBookDetailByIsbn(isbn);
	 }

  @Override
  public int getBookNoByIsbn(String isbn) {
    return bookDAO.getBookNoByIsbn(isbn);
  }
  
  @Override
  public List<ProductApiVO> getNewBooks() {
    return bookDAO.getNewBooks();
  }
	
  @Override
  public List<ProductApiVO> searchBooksByKeyword(SearchVO searchVO) {
    return bookDAO.searchBooksByKeyword(searchVO);
  }

  @Override
  public int getBookTotalCountByKeyword(SearchVO searchVO) {
    return bookDAO.getBookTotalCountByKeyword(searchVO);
  }
  
  @Override
  public List<ProductApiVO> getPopularBooks(SearchVO searchVO) {
      return bookDAO.selectPopularBooks(searchVO);
  }

}