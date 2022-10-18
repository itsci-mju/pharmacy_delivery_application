package controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import bean.*;
import conn.HibernateConnection;

public class StockManager {
	public List<Stock> listAllStock(String drugstoreID ) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			Date dNow = new Date( );
		    SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd");
		    
			session.beginTransaction();
			List<Stock> stock = session.createQuery("From Stock  where  drugstoreID = '"+ drugstoreID+"' "
					+ "and expirationDate >= '"+df.format(dNow)+"'  "
				//	+ "and medQuantity>0 "
					).list();
			session.close();
			
			return stock ;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public Stock getStock(String drugstoreID,String medId ) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			Date dNow = new Date( );
		    SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd");
		    
			session.beginTransaction();
			List<Stock> stock = session.createQuery("From Stock  where  drugstoreID = '"+ drugstoreID+"' "
					+ "and medId = '"+medId+"'  "
					+ "and expirationDate >= '"+df.format(dNow)+"'  "
				//	+ "and medQuantity>0 "
					).list();
			session.close();
			
			return stock.get(0);
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public int reduceMedQty(String drugstoreId, String medId, int qty) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			Query q = session.createQuery("Update Stock set medQuantity=medQuantity- "+qty+" "
					+ " where drugstoreID='"+drugstoreId+"' "
					+ " and  medId='"+medId+"'");
			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	public int revertMedQty(String drugstoreId, String medId, int qty) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			Query q = session.createQuery("Update Stock set medQuantity=medQuantity+ "+qty+" "
					+ " where drugstoreID='"+drugstoreId+"' "
					+ " and  medId='"+medId+"'");
			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	/*
	public List<Stock> listAlStock() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Stock> stock = session.createQuery("From Stock").list();
			session.close();
			
			return stock;
			
		} catch (Exception e) {
			return null;
		}
	}
	*/

}

