package bean;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;

public class OrderDetailId implements Serializable {
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="orderId")
	private Orders orders;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="medId")
	private Medicine medicine;

	public OrderDetailId() {
	}

	public OrderDetailId(Orders orders, Medicine medicine) {
		super();
		this.orders = orders;
		this.medicine = medicine;
	}
	
	

}
