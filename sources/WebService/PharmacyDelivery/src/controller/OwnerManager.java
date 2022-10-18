package controller;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import bean.*;
import conn.HibernateConnection;

public class OwnerManager {
	public List<Owner> listAllAddress() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Owner> owner = session.createQuery("From Owner").list();
			session.close();
			
			return owner;
			
		} catch (Exception e) {
			return null;
		}
	}

}

