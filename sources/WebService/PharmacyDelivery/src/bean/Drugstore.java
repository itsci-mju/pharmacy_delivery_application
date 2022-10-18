package bean;
import javax.persistence.*;

@Entity
@Table(name="Drugstore")

public class Drugstore {
	@Id
	@Column(name="drugstoreID")
	private String drugstoreID;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="ownerid",nullable=false)
	private Owner owner ;
	
	@Column(name="drugstoreName")
	private String drugstoreName;
	
	@Column(name="drugstoreAddress")
	private String drugstoreAddress;
	
	@Column(name="drugstoreTel")
	private String drugstoreTel;
	
	
	@Column(name="drugstoreStatus")
	private String drugstoreStatus;

	
	@Column(name="drugstoreImg")
	private String drugstoreImg;
	
	public Drugstore() {
	}
	
	public Drugstore(String drugstoreID) {
		this.drugstoreID = drugstoreID;
	}

	public Drugstore(String drugstoreID, Owner owner, String drugstoreName, String drugstoreAddress,
			String drugstoreTel, String drugstoreStatus, String drugstoreImg) {
		super();
		this.drugstoreID = drugstoreID;
		this.owner = owner;
		this.drugstoreName = drugstoreName;
		this.drugstoreAddress = drugstoreAddress;
		this.drugstoreTel = drugstoreTel;
		this.drugstoreStatus = drugstoreStatus;
		this.drugstoreImg = drugstoreImg;
	}

	public String getDrugstoreID() {
		return drugstoreID;
	}

	public void setDrugstoreID(String drugstoreID) {
		this.drugstoreID = drugstoreID;
	}

	public Owner getOwner() {
		return owner;
	}

	public void setOwner(Owner owner) {
		this.owner = owner;
	}

	public String getDrugstoreName() {
		return drugstoreName;
	}

	public void setDrugstoreName(String drugstoreName) {
		this.drugstoreName = drugstoreName;
	}

	public String getDrugstoreAddress() {
		return drugstoreAddress;
	}

	public void setDrugstoreAddress(String drugstoreAddress) {
		this.drugstoreAddress = drugstoreAddress;
	}

	public String getDrugstoreTel() {
		return drugstoreTel;
	}

	public void setDrugstoreTel(String drugstoreTel) {
		this.drugstoreTel = drugstoreTel;
	}

	public String getDrugstoreStatus() {
		return drugstoreStatus;
	}

	public void setDrugstoreStatus(String drugstoreStatus) {
		this.drugstoreStatus = drugstoreStatus;
	}

	public String getDrugstoreImg() {
		return drugstoreImg;
	}

	public void setDrugstoreImg(String drugstoreImg) {
		this.drugstoreImg = drugstoreImg;
	}


	
	
	
	
}
