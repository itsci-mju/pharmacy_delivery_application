package controller;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import bean.MedicineType;
import conn.HibernateConnection;

public class MedicineTypeManager {
	public List<MedicineType> listAllMedicineType() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<MedicineType> medicineType = session.createQuery("From MedicineType").list();
			session.close();
			
			return medicineType;
			
		} catch (Exception e) {
			return null;
		}
	}

}
