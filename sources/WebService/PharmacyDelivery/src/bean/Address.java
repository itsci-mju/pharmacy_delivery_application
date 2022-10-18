
package bean;
import javax.persistence.*;

@Entity
@Table(name="Address")

public class Address {
	@Id
	private String addressId;
	
	@Column(name="name")
	private String name;
	
	@Column(name="addressDetail")
	private String addressDetail;
	
	@Column(name="tel")
	private String tel;
	
	@Column(name="status")
	private String status;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="MemberUsername")
	private Member member;
	
	public Address() {
		// TODO Auto-generated constructor stub
	}
	
	public Address(String addressId) {
		this.addressId = addressId;
	}



	public Address(String addressId, String name, String addressDetail, String tel, String status, Member member) {
		super();
		this.addressId = addressId;
		this.name = name;
		this.addressDetail = addressDetail;
		this.tel = tel;
		this.status = status;
		this.member = member;
	}
	

	public String getAddressId() {
		return addressId;
	}

	public void setAddressId(String addressId) {
		this.addressId = addressId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddressDetail() {
		return addressDetail;
	}

	public void setAddressDetail(String addressDetail) {
		this.addressDetail = addressDetail;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}


}

