package bean;
import javax.persistence.*;

@Entity
@Table(name="orderdetail")
@IdClass(OrderDetailId.class)
public class OrderDetail {
	@Id
	private Orders orders;
	
	@Id
	private Medicine medicine;
	
	@Column(name="quantity")
	private Integer quantity;
	
	@Column(name="sumprice")
	private Double sumprice;
	
	@Column(name="note")
	private String note;

	public OrderDetail() {
		// TODO Auto-generated constructor stub
	}

	public OrderDetail(Orders orders, Medicine medicine, Integer quantity, Double sumprice, String note) {
		super();
		this.orders = orders;
		this.medicine = medicine;
		this.quantity = quantity;
		this.sumprice = sumprice;
		this.note = note;
	}

	public Orders getOrder() {
		return orders;
	}

	public void setOrder(Orders order) {
		this.orders = order;
	}

	public Medicine getMedicine() {
		return medicine;
	}

	public void setMedicine(Medicine medicine) {
		this.medicine = medicine;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public Double getSumprice() {
		return sumprice;
	}

	public void setSumprice(Double sumprice) {
		this.sumprice = sumprice;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}


	

}
