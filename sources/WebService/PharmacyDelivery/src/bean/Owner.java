package bean;
import javax.persistence.*;

@Entity
@Table(name="Owner")

public class Owner {
	@Id
	private String ownerid;
	
	@Column(name="ownerName")
	private String ownerName;
	
	@Column(name="ownerPassword")
	private String ownerPassword ;
	
	@Column(name="imgLicense")
	private String imgLicense ;

	public Owner() {
	}

	public Owner(String ownerid, String ownerName, String ownerPassword, String imgLicense) {
		super();
		this.ownerid = ownerid;
		this.ownerName = ownerName;
		this.ownerPassword = ownerPassword;
		this.imgLicense = imgLicense;
	}

	public String getOwnerid() {
		return ownerid;
	}

	public void setOwnerid(String ownerid) {
		this.ownerid = ownerid;
	}

	public String getOwnerName() {
		return ownerName;
	}

	public void setOwnerName(String ownerName) {
		this.ownerName = ownerName;
	}

	public String getOwnerPassword() {
		return ownerPassword;
	}

	public void setOwnerPassword(String ownerPassword) {
		this.ownerPassword = ownerPassword;
	}

	public String getImgLicense() {
		return imgLicense;
	}

	public void setImgLicense(String imgLicense) {
		this.imgLicense = imgLicense;
	}
	
	
	
	
	
	

}
