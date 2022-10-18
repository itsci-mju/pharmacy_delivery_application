package controller;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

import bean.*;
import conn.HibernateConnection;

public class PharmacistManager {
	public List<Pharmacist> listAllPharmacist() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Pharmacist> pharmacist = session.createQuery("From Pharmacist").list();
			session.close();
			
			return pharmacist;
			
		} catch (Exception e) {
			return null;
		}
	}
	

	public String doHibernateLogin(Pharmacist login) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Pharmacist> pharmacist = session.createQuery("From Pharmacist where pharmacistID='" + login.getPharmacistID()+"' ").list();
			session.close();
			
			if (pharmacist.size() == 1) {
				//String password = PasswordUtil.getInstance().createPassword(user.get(0).getPassword(), SALT);
				if (login.getPharmacistPassword().equals(pharmacist.get(0).getPharmacistPassword())) {
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
	
	public Pharmacist getPharmacist(String pid) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Pharmacist >pharmacist = session.createQuery("From Pharmacist where pharmacistID='"+pid+"'").list();
			session.close();
			
			return pharmacist.get(0);
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Pharmacist> checkPharmacistOnline(String diD) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Pharmacist >pharmacist = session.createQuery("From Pharmacist where drugstoreID='"+diD+"' and pharmacistStatus='ON' ").list();
			session.close();
			
			return pharmacist;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public int setStatusOnline(String id ) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			Query q = session.createQuery("Update Pharmacist set pharmacistStatus='ON' where pharmacistID='"+id+"' ");
			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	public int setStatusOffline(String id ) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			Query q = session.createQuery("Update Pharmacist set pharmacistStatus='OF' where pharmacistID='"+id+"' ");
			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	

}

