package controller;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import bean.Member;
import conn.HibernateConnection;

public class MemberManager {
	public List<Member> listAllMembers() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Member> members = session.createQuery("From Member").list();
			session.close();
			
			return members;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public String doHibernateLogin(Member login) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Member> member = session.createQuery("From Member where MemberUsername='" + login.getMemberUsername()+"' ").list();
			session.close();
			
			if (member.size() == 1) {
				//String password = PasswordUtil.getInstance().createPassword(user.get(0).getPassword(), SALT);
				if (login.getMemberPassword().equals(member.get(0).getMemberPassword())) {
					return "login success";
				} else {
					return "username or password does't match";
				}
			} else {
				return "username or password does't match";
			}
		} catch (Exception e) {
			return "Please try again...";
		}
	}
	
	public Member getMember(String mid) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Member >members = session.createQuery("From Member where MemberUsername='"+mid+"'").list();
			session.close();
			
			return members.get(0);
			
		} catch (Exception e) {
			return null;
		}
	}
	
	
	public String insertMember(Member member) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();

			Session session = sessionFactory.openSession();
			Transaction t = session.beginTransaction();
			session.save(member);
			t.commit();
			session.close();
			return "successfully saved";
		} catch (Exception e) {
			return "failed to save order";
		}
	}
	
	public Member getMember_Review(String rid) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();

			session.beginTransaction();
			List<Member >members = session.createQuery("select m from Review r join Orders o on r.reviewId=o.review.reviewId "
					+ "join Advice a on o.orderId=a.orders.orderId "					
				//+ "join Address a on o.address.addressId=a.addressId "
					+ "join Member m on a.member.MemberUsername=m.MemberUsername "
					+ "where r.reviewId='"+rid+"' "
					+ "order by r.reviewDate desc").list();
			session.close();
			
			return members.get(0);
			
		} catch (Exception e) {
			return null;
		}
	}
	

}
