package bean;
import javax.persistence.*;

@Entity
@Table(name="Pharmacist")
public class Pharmacist {
	@Id
	private String pharmacistID;
	
	@Column(name="pharmacistPassword")
	private String pharmacistPassword;
	
	@Column(name="pharmacistName")
	private String pharmacistName;
	
	@Column(name="pharmacistImg")
	private String pharmacistImg;
	
	@Column(name="imgCeritficate")
	private String imgCeritficate;
	
	@Column(name="pharmacistMobile")
	private String pharmacistMobile;
	
	@Column(name="pharmacistEmail")
	private String pharmacistEmail;
	
	@Column(name="pharmacistStatus")
	private String pharmacistStatus;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="drugstoreID")
	private Drugstore drugstore;

	
	public Pharmacist() {
		super();
	}
	public Pharmacist(String pharmacistID) {
		this.pharmacistID = pharmacistID;
	}
	
	
	public Pharmacist(String pharmacistID, String pharmacistPassword) {
		super();
		this.pharmacistID = pharmacistID;
		this.pharmacistPassword = pharmacistPassword;
	}
	public Pharmacist(String pharmacistID, String pharmacistPassword, String pharmacistName, String pharmacistImg,
			String imgCeritficate, String pharmacistMobile, String pharmacistEmail, String pharmacistStatus,
			Drugstore drugstore) {
		super();
		this.pharmacistID = pharmacistID;
		this.pharmacistPassword = pharmacistPassword;
		this.pharmacistName = pharmacistName;
		this.pharmacistImg = pharmacistImg;
		this.imgCeritficate = imgCeritficate;
		this.pharmacistMobile = pharmacistMobile;
		this.pharmacistEmail = pharmacistEmail;
		this.pharmacistStatus = pharmacistStatus;
		this.drugstore = drugstore;
	}
	public String getPharmacistID() {
		return pharmacistID;
	}
	public void setPharmacistID(String pharmacistID) {
		this.pharmacistID = pharmacistID;
	}
	public String getPharmacistPassword() {
		return pharmacistPassword;
	}
	public void setPharmacistPassword(String pharmacistPassword) {
		this.pharmacistPassword = pharmacistPassword;
	}
	public String getPharmacistName() {
		return pharmacistName;
	}
	public void setPharmacistName(String pharmacistName) {
		this.pharmacistName = pharmacistName;
	}
	public String getPharmacistImg() {
		return pharmacistImg;
	}
	public void setPharmacistImg(String pharmacistImg) {
		this.pharmacistImg = pharmacistImg;
	}
	public String getImgCeritficate() {
		return imgCeritficate;
	}
	public void setImgCeritficate(String imgCeritficate) {
		this.imgCeritficate = imgCeritficate;
	}
	public String getPharmacistMobile() {
		return pharmacistMobile;
	}
	public void setPharmacistMobile(String pharmacistMobile) {
		this.pharmacistMobile = pharmacistMobile;
	}
	public String getPharmacistEmail() {
		return pharmacistEmail;
	}
	public void setPharmacistEmail(String pharmacistEmail) {
		this.pharmacistEmail = pharmacistEmail;
	}
	public String getPharmacistStatus() {
		return pharmacistStatus;
	}
	public void setPharmacistStatus(String pharmacistStatus) {
		this.pharmacistStatus = pharmacistStatus;
	}
	public Drugstore getDrugstore() {
		return drugstore;
	}
	public void setDrugstore(Drugstore drugstore) {
		this.drugstore = drugstore;
	}

	

}
