package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookGap.dao.CommentDAO;

@Service
public class CommentServiceImpl implements CommentService{

	@Autowired
	public CommentDAO commentDAO;
}
