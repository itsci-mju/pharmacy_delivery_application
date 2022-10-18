package controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import bean.*;
import conn.HibernateConnection;

public class AdviceManager {
	public List<Advice> listAllAdvice() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Advice> advice = session.createQuery("From Advice").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	
	
	public String AddAdvice(Advice advice) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();

			Session session = sessionFactory.openSession();
			Transaction t = session.beginTransaction();
			session.save(advice);
			t.commit();
			session.close();
			return "successfully saved advice";
		} catch (Exception e) {
			return "failed to save advice";
		}
	}
	

	public Advice getAdvice(String aid) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Advice >advice= session.createQuery("From Advice where adviceId='"+aid+"'").list();
			session.close();
			
			return advice.get(0);
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public int updateAdvice(Advice advice,Orders orders) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			Transaction t = session.beginTransaction();
			
			Query q = session.createQuery("update Advice  set orderId= '"+orders.getOrderId()+"' where adviceId='"+advice.getAdviceId()+"' " );
			int status = q.executeUpdate();
			session.close();
			return status;

			// session.saveOrUpdate(advice);
		    // t.commit();
		 //	session.close();
			
			//return 1;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	public int endAdvice(Advice advice) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			Transaction t = session.beginTransaction();
			
			 SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
			
			Query q = session.createQuery("update Advice  set  endTime= '"+df.format(advice.getEndTime().getTime())+"' "
					+ " where adviceId='"+advice.getAdviceId()+"' " );
			int status = q.executeUpdate();
			session.close();
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	/*
	public int endAdvice_member(String adviceId) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			Transaction t = session.beginTransaction();
			
			Query q = session.createQuery("update Advice  set endTime= '"++"' where adviceId='"+advice.getAdviceId()+"' " );
			int status = q.executeUpdate();
			return status;

		} catch (Exception e) {
			return 0;
		}
	}
*/
	
}

