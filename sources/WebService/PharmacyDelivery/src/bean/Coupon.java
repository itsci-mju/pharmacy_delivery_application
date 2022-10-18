package bean;
import java.util.Calendar;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name="Coupon")
public class Coupon {
	@Id
	private String couponName;
	
	@Column(name="minimumPrice")
	private Double minimumPrice;
	
	@Column(name="discount")
	private Double discount;
	
	@Column(name="couponQty")
	private Integer couponQty;
	
	@Column(name="startDate")
	private Calendar startDate  ;
	
	@Column(name="endDate")
	private Calendar endDate  ;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="drugstoreID")
	private Drugstore drugstore;
	
	public Coupon() {
	}

	public Coupon(String couponName, Double minimumPrice, Double discount, Integer couponQty, Calendar startDate,
			Calendar endDate, Drugstore drugstore) {
		super();
		this.couponName = couponName;
		this.minimumPrice = minimumPrice;
		this.discount = discount;
		this.couponQty = couponQty;
		this.startDate = startDate;
		this.endDate = endDate;
		this.drugstore = drugstore;
	}

	public String getCouponName() {
		return couponName;
	}

	public void setCouponName(String couponName) {
		this.couponName = couponName;
	}

	public Double getMinimumPrice() {
		return minimumPrice;
	}

	public void setMinimumPrice(Double minimumPrice) {
		this.minimumPrice = minimumPrice;
	}

	public Double getDiscount() {
		return discount;
	}

	public void setDiscount(Double discount) {
		this.discount = discount;
	}

	public Integer getCouponQty() {
		return couponQty;
	}

	public void setCouponQty(Integer couponQty) {
		this.couponQty = couponQty;
	}

	public Calendar getStartDate() {
		return startDate;
	}

	public void setStartDate(Calendar startDate) {
		this.startDate = startDate;
	}

	public Calendar getEndDate() {
		return endDate;
	}

	public void setEndDate(Calendar endDate) {
		this.endDate = endDate;
	}

	public Drugstore getDrugstore() {
		return drugstore;
	}

	public void setDrugstore(Drugstore drugstore) {
		this.drugstore = drugstore;
	}

	
}
