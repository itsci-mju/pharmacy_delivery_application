package bean;

import java.io.Serializable;

import javax.persistence.*;

public class StockId implements Serializable{
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="drugstoreID")
	private Drugstore drugstore;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="medId")
	private Medicine medicine;

	
	public StockId() {
	}

	public StockId(Drugstore drugstore, Medicine medicine) {
		this.drugstore = drugstore;
		this.medicine = medicine;
	}
	

}
