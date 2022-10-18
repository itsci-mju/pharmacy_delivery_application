package controller;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
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

public class OrdersDetailManager {
	public List<OrderDetail> listAllOrdersDetail(String orderId) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<OrderDetail> orderDetail = session.createQuery("From OrderDetail where orderId='"+orderId+"' ").list();
			session.close();
			
			return orderDetail;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public String insertOrderDetail(OrderDetail orderDetail) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();

			Session session = sessionFactory.openSession();
			Transaction t = session.beginTransaction();
			session.save(orderDetail);
			t.commit();
			session.close();
			return "successfully saved OrderDetail";
		} catch (Exception e) {
			return "failed to save OrderDetail";
		}
	}
	/*
	public int pCancelOrder(String orderId) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			Query q = session.createQuery("Update Advice set orderId= '"+orderId+"' "
							+ " where adviceId='"+adviceId+"' " );

			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	*/
}
