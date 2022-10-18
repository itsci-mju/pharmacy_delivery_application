package bean;
import java.util.Calendar;

import javax.persistence.*;

@Entity
@Table(name="Stock")
@IdClass(StockId.class)
public class Stock {
	@Id
	private Drugstore drugstore;
	
	@Id
	private Medicine medicine;
	
	@Column(name="medQuantity")
	private Integer medQuantity;
	
	@Column(name="expirationDate")
	private Calendar expirationDate;
	
	@Column(name="medPrice")
	private Double medPrice;

	public Stock() {
	}

	public Stock(Drugstore drugstore, Medicine medicine, Integer medQuantity, Calendar expirationDate, Double medPrice) {
		super();
		this.drugstore = drugstore;
		this.medicine = medicine;
		this.medQuantity = medQuantity;
		this.expirationDate = expirationDate;
		this.medPrice = medPrice;
	}

	public Drugstore getDrugstore() {
		return drugstore;
	}

	public void setDrugstore(Drugstore drugstore) {
		this.drugstore = drugstore;
	}

	public Medicine getMedicine() {
		return medicine;
	}

	public void setMedicine(Medicine medicine) {
		this.medicine = medicine;
	}

	public Integer getMedQuantity() {
		return medQuantity;
	}

	public void setMedQuantity(Integer medQuantity) {
		this.medQuantity = medQuantity;
	}

	public Calendar getExpirationDate() {
		return expirationDate;
	}

	public void setExpirationDate(Calendar expirationDate) {
		this.expirationDate = expirationDate;
	}

	public Double getMedPrice() {
		return medPrice;
	}

	public void setMedPrice(Double medPrice) {
		this.medPrice = medPrice;
	}
	
	
}
