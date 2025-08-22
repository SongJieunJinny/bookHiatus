package com.bookGap.vo;

import lombok.Data;

@Data
public class AdminOrderUpdateRequestVO {
    private int orderId;       // ORDERS.ORDER_ID
    private int orderStatus;   // ORDERS.ORDER_STATUS
    private int paymentStatus; // PAYMENTS.STATUS
    private String courier;    // ORDERS.COURIER
    private String invoice;    // ORDERS.INVOICE
    
    
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public int getOrderStatus() {
		return orderStatus;
	}
	public void setOrderStatus(int orderStatus) {
		this.orderStatus = orderStatus;
	}
	public int getPaymentStatus() {
		return paymentStatus;
	}
	public void setPaymentStatus(int paymentStatus) {
		this.paymentStatus = paymentStatus;
	}
	public String getCourier() {
		return courier;
	}
	public void setCourier(String courier) {
		this.courier = courier;
	}
	public String getInvoice() {
		return invoice;
	}
	public void setInvoice(String invoice) {
		this.invoice = invoice;
	}
    
    
    
    
}
