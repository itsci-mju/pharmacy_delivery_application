package controller;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import bean.*;
import conn.HibernateConnection;


public class DrugstoreManager {
	public List<Drugstore> listAllDrugstore() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Drugstore> drugstores = session.createQuery("From Drugstore").list();
			session.close();
			
			return drugstores;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	/*
	public List<Drugstore> searchDrugstore(String name) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Drugstore> drugstores = session.createQuery("From Drugstore where drugstore_name like '%" + name + "%'  order by drugstore_name").list();
			session.close();
			
			return drugstores;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public Drugstore getDrugstore(String Did) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
		
			List<Drugstore> drugstores = session.createQuery("From Drugstore where drugstore_id ='"+Did+"'").list();

			
			session.close();
			
			return drugstores.get(0);
			
		} catch (Exception e) {
			return null;
		}
	}
	
	
	
*/
}
