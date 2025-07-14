package com.bookGap.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookGap.dao.CommentDAO;
import com.bookGap.util.PagingUtil;
import com.bookGap.vo.CommentLoveVO;
import com.bookGap.vo.CommentRatingVO;
import com.bookGap.vo.CommentVO;

@Service
public class CommentServiceImpl implements CommentService {
	
	@Autowired public CommentDAO commentDAO;
	@Autowired private BookService bookService;

  @Autowired private CommentLoveService loveService;
  @Autowired private CommentRatingService ratingService;

  @Override
  public Map<String, Object> getCommentList(String isbn, String loginUserId, int cnowpage) {
    Map<String, Object> result = new HashMap<>();
    int total = commentDAO.selectTotal(isbn);
    PagingUtil paging = new PagingUtil(cnowpage, total, 5);

    Map<String, Object> params = new HashMap<>();
    params.put("isbn", isbn);
    params.put("loginUserId", loginUserId);
    params.put("start", paging.getStart());
    params.put("perPage", paging.getPerPage());

    List<CommentVO> commentList = commentDAO.getCommentListWithDetails(params);
    
    result.put("commentList", commentList);
    result.put("paging", paging);
    return result;
  }

  @Override
  @Transactional 
  public void writeComment(CommentVO commentVO, int rating, boolean liked) {
    int bookNo = bookService.getBookNoByIsbn(commentVO.getIsbn());
    commentVO.setBookNo(bookNo);
    
    // 1. 댓글 본문 저장
    commentDAO.insert(commentVO); // 이 시점에 commentVO에 commentNo가 채워짐
    
    // 2. 별점 저장 (RatingService 위임)
    CommentRatingVO ratingVO = new CommentRatingVO();
    ratingVO.setCommentNo(commentVO.getCommentNo());
    ratingVO.setUserId(commentVO.getUserId());
    ratingVO.setIsbn(commentVO.getIsbn());
    ratingVO.setRating(rating);
    ratingService.upsertRating(ratingVO);
    
    // 3. 좋아요 저장 (LoveService 위임)
    if (liked) {
      CommentLoveVO loveVO = new CommentLoveVO();
      loveVO.setCommentNo(commentVO.getCommentNo());
      loveVO.setUserId(commentVO.getUserId());
      loveVO.setIsbn(commentVO.getIsbn());
      loveService.insertLove(loveVO);
    }
  }

  @Override
  @Transactional 
  public void modifyComment(CommentVO commentVO, int rating, boolean liked) {
    // 1. 댓글 내용 수정
    commentDAO.update(commentVO);

    // 2. 별점 수정 (있으면 update, 없으면 insert)
    CommentRatingVO ratingVO = new CommentRatingVO();
    ratingVO.setCommentNo(commentVO.getCommentNo());
    ratingVO.setUserId(commentVO.getUserId());
    ratingVO.setIsbn(commentVO.getIsbn());
    ratingVO.setRating(rating);
    ratingService.updateRating(ratingVO);
    
    // 3. 좋아요 상태 변경
    CommentLoveVO loveVO = new CommentLoveVO();
    loveVO.setCommentNo(commentVO.getCommentNo());
    loveVO.setUserId(commentVO.getUserId());
    
    if (liked) {
      loveService.insertLove(loveVO);
    } else {
      loveService.deleteLove(loveVO);
    }
    
  }

  @Override
  @Transactional
  public void deleteComment(int commentNo, String loginUserId, boolean isAdmin) throws IllegalAccessException {
    CommentVO cvo = commentDAO.selectOne(commentNo);
    if (cvo == null) throw new RuntimeException("Comment not found");
    if (!cvo.getUserId().equals(loginUserId) && !isAdmin) {
      throw new IllegalAccessException("No permission");
    }
    commentDAO.changeState(commentNo);
  }

  @Override
  public CommentVO selectOne(int commentNo) {
    return commentDAO.selectOne(commentNo);
  }
}