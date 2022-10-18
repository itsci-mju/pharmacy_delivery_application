package bean;
import javax.persistence.*;
import java.sql.Date;
import java.util.Calendar;

@Entity
@Table(name="orders")
public class Orders {
	@Id
	private String orderId;
	
	@Column(name="orderDate")
	private Calendar orderDate;
	
	@Column(name="sumQuantity")
	private Integer sumQuantity;
	
	@Column(name="subtotalPrice")
	private Double subtotalPrice;
	
	@Column(name="totalPrice")
	private Double totalPrice;
	
	@Column(name="orderStatus")
	private String orderStatus;
	
	@Column(name="receiptId")
	private String receiptId;
	
	@Column(name="payDate")
	private Calendar payDate;
	
	@Column(name="shippingCost")
	private Double shippingCost;
	
	@Column(name="shippingCompany")
	private String shippingCompany;
	
	@Column(name="trackingNumber")
	private String trackingNumber;
	
	@Column(name="shippingDate")
	private Calendar shippingDate;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="couponName")
	private Coupon coupon;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="addressId")
	private Address  address;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="reviewId")
	private Review  review;
	
	
	public Orders() {
		// TODO Auto-generated constructor stub
	}

	public Orders(String orderId) {
		this.orderId = orderId;
	}

	public Orders(String orderId, Calendar orderDate, Integer sumQuantity, Double subtotalPrice, Double totalPrice,
			String orderStatus, String receiptId, Calendar payDate, Double shippingCost, String shippingCompany,
			String trackingNumber, Calendar shippingDate, Coupon coupon,
			Address address, Review review) {
		super();
		this.orderId = orderId;
		this.orderDate = orderDate;
		this.sumQuantity = sumQuantity;
		this.subtotalPrice = subtotalPrice;
		this.totalPrice = totalPrice;
		this.orderStatus = orderStatus;
		this.receiptId = receiptId;
		this.payDate = payDate;
		this.shippingCost = shippingCost;
		this.shippingCompany = shippingCompany;
		this.trackingNumber = trackingNumber;
		this.shippingDate = shippingDate;
		this.coupon = coupon;
		this.address = address;
		this.review = review;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public Calendar getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(Calendar orderDate) {
		this.orderDate = orderDate;
	}

	public Integer getSumQuantity() {
		return sumQuantity;
	}

	public void setSumQuantity(Integer sumQuantity) {
		this.sumQuantity = sumQuantity;
	}

	public Double getSubtotalPrice() {
		return subtotalPrice;
	}

	public void setSubtotalPrice(Double subtotalPrice) {
		this.subtotalPrice = subtotalPrice;
	}

	public Double getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(Double totalPrice) {
		this.totalPrice = totalPrice;
	}

	public String getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}

	public String getReceiptId() {
		return receiptId;
	}

	public void setReceiptId(String receiptId) {
		this.receiptId = receiptId;
	}

	public Calendar getPayDate() {
		return payDate;
	}

	public void setPayDate(Calendar payDate) {
		this.payDate = payDate;
	}

	public Double getShippingCost() {
		return shippingCost;
	}

	public void setShippingCost(Double shippingCost) {
		this.shippingCost = shippingCost;
	}

	public String getShippingCompany() {
		return shippingCompany;
	}

	public void setShippingCompany(String shippingCompany) {
		this.shippingCompany = shippingCompany;
	}

	public String getTrackingNumber() {
		return trackingNumber;
	}

	public void setTrackingNumber(String trackingNumber) {
		this.trackingNumber = trackingNumber;
	}

	public Calendar getShippingDate() {
		return shippingDate;
	}

	public void setShippingDate(Calendar shippingDate) {
		this.shippingDate = shippingDate;
	}

	public Coupon getCoupon() {
		return coupon;
	}

	public void setCoupon(Coupon coupon) {
		this.coupon = coupon;
	}

	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}

	public Review getReview() {
		return review;
	}

	public void setReview(Review review) {
		this.review = review;
	}

	

}
