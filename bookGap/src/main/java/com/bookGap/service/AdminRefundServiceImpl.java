package com.bookGap.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class AdminRefundServiceImpl implements AdminRefundService {
	
	 @Autowired
	 private AdminRefundDAO adminRefundDAO;

}
