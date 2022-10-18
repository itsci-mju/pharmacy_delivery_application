package controller;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.persistence.TemporalType;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

import bean.*;
import conn.HibernateConnection;

public class CouponManager {
	
	public List<Coupon> listAllCoupon(String drugstoreID) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			
			Date dNow = new Date( );
			 SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd");
			//System.out.println(df.format(dNow));
			
			List<Coupon> coupon = session.createQuery("From Coupon "
							+ " where  drugstoreID = '"+ drugstoreID+"' "
							+ " and  '"+df.format(dNow)+"' between startDate and endDate").list();
			session.close();
			
			return coupon;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	 public Coupon verifyCoupon(String couponName, String drugstoreID ) {
			try {
				SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
				Session session = sessionFactory.openSession();
				
				Date dNow = new Date( );
				 SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd");
				
				session.beginTransaction();
				List<Coupon >coupons = session.createQuery("From Coupon "
								+ " where couponName='"+couponName+"' "
								+ " and drugstoreID = '"+drugstoreID+"' "
								+ " and  '"+df.format(dNow)+"' between startDate and endDate "
								+ " and couponQty>0").list();

				session.close();
				
				return coupons.get(0);
				
			} catch (Exception e) {
				return null;
			}
	    }
	
		public int reduceCouponQty(String couponName) {
			try {
				SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
				Session session = sessionFactory.openSession();
				
				session.beginTransaction();
				Query q = session.createQuery("Update Coupon set couponQty=couponQty-1  "
						+ " where couponName='"+couponName+"' " );
				int status = q.executeUpdate();
				session.close();
				
				return status;
				
			} catch (Exception e) {
				return 0;
			}
		}
		
		public int revertCouponQty(String couponName) {
			try {
				SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
				Session session = sessionFactory.openSession();
				
				session.beginTransaction();
				Query q = session.createQuery("Update Coupon set couponQty=couponQty+1  "
						+ " where couponName='"+couponName+"' " );
				int status = q.executeUpdate();
				session.close();
				
				return status;
				
			} catch (Exception e) {
				return 0;
			}
		}
		
		public Double minCoupon(String drugstoreID) {
			try {
				SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
				Session session = sessionFactory.openSession();
				
				session.beginTransaction();
				
				Date dNow = new Date( );
				 SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd");
				//System.out.println(df.format(dNow));
				
				List<Double> min_coupon = session.createQuery("select min(minimumPrice) From Coupon "
								+ " where  drugstoreID = '"+ drugstoreID+"' "
								+ " and  '"+df.format(dNow)+"' between startDate and endDate").list();
				session.close();
				
				return min_coupon.get(0);
				
			} catch (Exception e) {
				return 0.0;
			}
		}
}

