package com.bookGap.service;

import java.util.List;

import com.bookGap.vo.RefundVO;

public interface AdminRefundService {
	  List<RefundVO> getAllRefunds();
	  RefundVO getRefundDetail(int refundNo);
	  int updateRefundStatusAndSyncOrder(int refundNo, int refundStatus);
}
