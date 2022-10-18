package controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import bean.*;
import conn.HibernateConnection;

public class MedicineManager {
	public List<Medicine> listAllMedicine(String drugstoreID) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			Date dNow = new Date( );
		    SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd");
			 
			session.beginTransaction();
			List<Medicine> medines = session.createQuery("select m From  Medicine m  join Stock s on m.medId=s.medicine.medId "
					+ "join Drugstore d on d.drugstoreID=s.drugstore.drugstoreID  "
					+ "where  d.drugstoreID = '"+ drugstoreID+"' "
					+ "and s.expirationDate >= '"+df.format(dNow)+"'  "
					//+ "and s.medQuantity>0 "
					).list();
			session.close();
			
			return medines;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public Medicine getMedicine(String mid) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Medicine> medines = session.createQuery("From Medicine where medId ='"+mid+"'").list();
			session.close();
			
			return medines.get(0) ;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	/*	
	public List<Medicine> listAllMedicine() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Medicine> medines = session.createQuery("From Medicine ").list();
			session.close();
			
			return medines;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Medicine> searchMedicine(String idDrugstore,String name) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Medicine> medines = session.createQuery("From Medicine"
					+ " where  drugstore_id = "+ idDrugstore +" and med_name like  '%" + name + "%'  order by med_id ").list();
			session.close();
			
			return medines;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public Medicine getMedicine(String mid, String did) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Medicine> medines = session.createQuery("From Medicine where  drugstore_id = '"+ did+"' and med_id ='"+mid+"'").list();
			session.close();
			
			return medines.get(0) ;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	*/

}
