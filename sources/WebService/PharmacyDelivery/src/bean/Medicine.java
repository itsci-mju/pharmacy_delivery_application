package bean;
import javax.persistence.*;

@Entity
@Table(name="Medicine")
public class Medicine {
	@Id
	private String medId;

	@Column(name="medName")
	private String medName;
	
	@Column(name="medDetail")
	private String medDetail;
	
	@Column(name="medImg")
	private String medImg;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="typeId",nullable=false)
	private MedicineType medicineType; 
	

	public Medicine(String medId) {
		this.medId = medId;
	}

	public Medicine() {
	}

	public Medicine(String medId, String medName, String medDetail, String medImg, MedicineType medicineType) {
		super();
		this.medId = medId;
		this.medName = medName;
		this.medDetail = medDetail;
		this.medImg = medImg;
		this.medicineType = medicineType;
	}

	public String getMedId() {
		return medId;
	}

	public void setMedId(String medId) {
		this.medId = medId;
	}

	public String getMedName() {
		return medName;
	}

	public void setMedName(String medName) {
		this.medName = medName;
	}

	public String getMedDetail() {
		return medDetail;
	}

	public void setMedDetail(String medDetail) {
		this.medDetail = medDetail;
	}

	public String getMedImg() {
		return medImg;
	}

	public void setMedImg(String medImg) {
		this.medImg = medImg;
	}

	public MedicineType getMedicineType() {
		return medicineType;
	}

	public void setMedicineType(MedicineType medicineType) {
		this.medicineType = medicineType;
	}


}
