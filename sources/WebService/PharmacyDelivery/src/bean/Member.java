package bean;
import javax.persistence.*;

@Entity
@Table(name="Member")

public class Member {
	@Id
	private String MemberUsername;
	
	@Column(name="MemberPassword")
	private String MemberPassword;
	
	@Column(name="MemberName")
	private String MemberName;
	
	@Column(name="MemberGender")
	private String MemberGender;
	
	@Column(name="MemberTel")
	private String MemberTel;
	
	@Column(name="MemberEmail")
	private String MemberEmail;
	
	@Column(name="MemberImg")
	private String MemberImg;
	
	
	public Member() {
		// TODO Auto-generated constructor stub
	}

	public Member(String MemberUsername) {
		this.MemberUsername = MemberUsername;
	}

	public Member(String memberUsername, String memberPassword) {
		super();
		MemberUsername = memberUsername;
		MemberPassword = memberPassword;
	}




	public Member(String memberUsername, String memberPassword, String memberName, String memberGender,
			String memberTel, String memberEmail, String memberImg) {
		super();
		MemberUsername = memberUsername;
		MemberPassword = memberPassword;
		MemberName = memberName;
		MemberGender = memberGender;
		MemberTel = memberTel;
		MemberEmail = memberEmail;
		MemberImg = memberImg;
	}

	public String getMemberName() {
		return MemberName;
	}

	public void setMemberName(String memberName) {
		MemberName = memberName;
	}

	public String getMemberGender() {
		return MemberGender;
	}

	public void setMemberGender(String memberGender) {
		MemberGender = memberGender;
	}

	public String getMemberTel() {
		return MemberTel;
	}

	public void setMemberTel(String memberTel) {
		MemberTel = memberTel;
	}

	public String getMemberEmail() {
		return MemberEmail;
	}

	public void setMemberEmail(String memberEmail) {
		MemberEmail = memberEmail;
	}

	public String getMemberImg() {
		return MemberImg;
	}

	public void setMemberImg(String memberImg) {
		MemberImg = memberImg;
	}

	public String getMemberUsername() {
		return MemberUsername;
	}

	public void setMemberUsername(String memberUsername) {
		MemberUsername = memberUsername;
	}

	public String getMemberPassword() {
		return MemberPassword;
	}

	public void setMemberPassword(String memberPassword) {
		MemberPassword = memberPassword;
	}

	
}
