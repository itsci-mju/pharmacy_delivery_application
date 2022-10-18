package controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import bean.Address;
import bean.Member;
import bean.Stock;
import conn.HibernateConnection;

public class AddressManager {
	public List<Address> listAddress(String MemberUsername) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Address> address = session.createQuery("From Address "
					+ " where MemberUsername = '"+MemberUsername+"' "
							+ " and status = 'T' ").list();
			session.close();
			
			return address;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public String insertAddress(Address address) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();

			Session session = sessionFactory.openSession();
			Transaction t = session.beginTransaction();
			session.save(address);
			t.commit();
			session.close();
			return "successfully saved address";
		} catch (Exception e) {
			return "failed to save order";
		}
	}
	
	public int removeAddress(String addressId, String MemberUsername) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			Query q = session.createQuery("update Address set status= 'F' "
					+ " where MemberUsername = '"+MemberUsername+"' "
					+ " and addressId = '"+addressId+"' ");

			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	  	public List<Address> listAllAddress() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Address> address = session.createQuery("From Address").list();
			session.close();
			
			return address;
			
		} catch (Exception e) {
			return null;
		}
	}
	  	
	public Address getAddress(String addressId ) {
			try {
				SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
				Session session = sessionFactory.openSession();
						
				session.beginTransaction();
				List<Address> address = session.createQuery("From Address  where  addressId = '"+ addressId+"' ").list();
				session.close();
				
				return address.get(0);
				
			} catch (Exception e) {
				return null;
			}
		}
	

}
