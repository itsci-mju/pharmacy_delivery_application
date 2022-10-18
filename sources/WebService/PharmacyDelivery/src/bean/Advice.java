package bean;
import java.util.Calendar;

import javax.persistence.*;

@Entity
@Table(name="Advice")
public class Advice {
	@Id
	private String adviceId;

	@Column(name="startTime")
	private Calendar startTime;
	
	@Column(name="endTime")
	private Calendar endTime;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="pharmacistID",nullable=false)
	private Pharmacist pharmacist ;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="MemberUsername",nullable=false)
	private Member member ;
	
	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="orderId")
	private Orders orders ;
	
	public Advice() {
	}

	public Advice(String adviceId) {
		super();
		this.adviceId = adviceId;
	}

	public Advice(String adviceId, Calendar startTime, Calendar endTime, 
			Pharmacist pharmacist, Member member, Orders orders) {
		super();
		this.adviceId = adviceId;
		this.startTime = startTime;
		this.endTime = endTime;
		this.pharmacist = pharmacist;
		this.member = member;
		this.orders = orders;
	}

	public String getAdviceId() {
		return adviceId;
	}

	public void setAdviceId(String adviceId) {
		this.adviceId = adviceId;
	}

	public Calendar getStartTime() {
		return startTime;
	}

	public void setStartTime(Calendar startTime) {
		this.startTime = startTime;
	}

	public Calendar getEndTime() {
		return endTime;
	}

	public void setEndTime(Calendar endTime) {
		this.endTime = endTime;
	}

	public Pharmacist getPharmacist() {
		return pharmacist;
	}

	public void setPharmacist(Pharmacist pharmacist) {
		this.pharmacist = pharmacist;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public Orders getOrders() {
		return orders;
	}

	public void setOrders(Orders orders) {
		this.orders = orders;
	}
	
}
