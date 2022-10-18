package controller;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import bean.Member;
import bean.OrderDetail;
import bean.Orders;
import bean.Review;
import conn.HibernateConnection;

public class ReviewManager {
	public List<Review> listAllReview(String drugstoreID) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();		
			List<Review> review = session.createQuery("select  r  from Review r join Orders o on r.reviewId=o.review.reviewId "
					+ "join Advice a on o.orderId=a.orders.orderId "
					+ "join Pharmacist p on a.pharmacist.pharmacistID=p.pharmacistID "
					+ "where p.drugstore.drugstoreID = '"+drugstoreID+"' "
					+ "order by r.reviewDate desc").list();
			session.close();
			
			return review;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public int addReview(Review review) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();

			Session session = sessionFactory.openSession();
			Transaction t = session.beginTransaction();
			session.save(review);
			t.commit();
			session.close();
			return 1;
		} catch (Exception e) {
			return 0;
		}
	}
	
	public List<Review> listReview() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Review> review = session.createQuery("From Review order by reviewId ").list();
			session.close();
			
			return review;
			
		} catch (Exception e) {
			return null;
		}
	}



}
