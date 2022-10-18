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

public class OrdersManager {
	public List<Orders> listOrders() {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Orders> orders = session.createQuery("From Orders order by orderId ").list();
			session.close();
			
			return orders;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Advice> listOrders_cf(String MemberUsername) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			 SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
			 Calendar c = Calendar.getInstance();
			 c.add(Calendar.HOUR_OF_DAY, -24);
			 Date d = c.getTime();
			 
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where o.orderStatus ='cf' "
					+ " and  '"+df.format(d)+"' <  o.orderDate "
					+ " and a.member.MemberUsername = '"+MemberUsername+"' "
					+ " order by o.orderId  DESC ").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Advice> listOrders_store(String MemberUsername) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			 
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where o.orderStatus ='store' "
					+ " and a.member.MemberUsername = '"+MemberUsername+"' "
					+ " order by o.payDate  DESC ").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Advice> listOrders_wt(String MemberUsername) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			 
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where o.orderStatus ='wt' "
					+ " and a.member.MemberUsername = '"+MemberUsername+"' "
					+ " order by o.payDate  DESC ").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Advice> listOrders_T(String MemberUsername) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			 
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where o.orderStatus ='T' "
					+ " and a.member.MemberUsername = '"+MemberUsername+"' "
					+ " order by o.shippingDate  DESC ").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}

	public List<Advice> listOrders_C(String MemberUsername) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where o.orderStatus ='C' "
					+ " and a.member.MemberUsername = '"+MemberUsername+"' "
					+ " order by o.orderId  DESC ").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Advice> listOrders_expir(String MemberUsername) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			 SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
			 Calendar c = Calendar.getInstance();
			 c.add(Calendar.HOUR_OF_DAY, -24);
			 Date d = c.getTime();
			 
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where  o.orderStatus ='cf'  and '"+df.format(d)+"' >  o.orderDate "
					+ " and a.member.MemberUsername = '"+MemberUsername+"' "
					+ " order by o.orderId  DESC ").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	
	
	public String insertOrder(Orders order) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();

			Session session = sessionFactory.openSession();
			Transaction t = session.beginTransaction();
			session.save(order);
			t.commit();
			session.close();
			return "successfully saved order";
		} catch (Exception e) {
			return "failed to save order";
		}
	}
	
	public Orders getOrder(String orderId) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Orders >orders = session.createQuery("From Orders where orderId='"+orderId+"'").list();
			session.close();
			
			return orders.get(0);
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public int pCancelOrder(String orderId) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			Query q = session.createQuery("update Orders set orderStatus= 'pc' "
							+ " where orderId='"+orderId+"' " );

			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	public int cancelOrder_member(String orderId) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			Query q = session.createQuery("update Orders set orderStatus= 'C' "
							+ " where orderId='"+orderId+"' " );

			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	public int confirmOrder(String orderId, String couponName,Double totalPrice ) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			session.beginTransaction();
			
			SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
			 Calendar c = Calendar.getInstance();
			 Date d = c.getTime();
			
			Query q ;
			if(  !couponName.equals("")) {
				q = session.createQuery("update Orders "
						+ " set orderStatus= 'cf' "
						+ "  , couponName= '"+couponName+"' "
						+ "  , totalPrice= "+totalPrice+" "
						+ "  , orderDate= '"+df.format(d)+"' "
						+ "  where orderId='"+orderId+"' " );
			}else {
				q = session.createQuery("update Orders "
						+ " set orderStatus= 'cf' "
						+ "  , totalPrice= "+totalPrice+" "
						+ "  , orderDate= '"+df.format(d)+"' "
						+ " where orderId='"+orderId+"' " );
			}
						
			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	public int updateReview(String orderId, String reviewId) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			Query q = session.createQuery("update Orders set reviewId= '"+reviewId+"' "
							+ " where orderId='"+orderId+"' " );

			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	public int payOrder(Orders orders ) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			Transaction t = session.beginTransaction();
			
			 session.saveOrUpdate(orders);
		     t.commit();
			session.close();
			
			return 1;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	/********************pharmacist ****************************/
	public List<Advice> phar_listOrders_cf(String pharmacistID) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			 SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
			 Calendar c = Calendar.getInstance();
			 c.add(Calendar.HOUR_OF_DAY, -24);
			 Date d = c.getTime();
			 
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where o.orderStatus ='cf' "
					+ " and  '"+df.format(d)+"' <  o.orderDate "
					+ " and a.pharmacist.pharmacistID= '"+pharmacistID+"' "					
					+ " order by o.orderId  ASC ").list();
					
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	
	public List<Advice> phar_listOrders_store(String pharmacistID) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			 
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where o.orderStatus ='store' "
					+ " and a.pharmacist.pharmacistID= '"+pharmacistID+"' "
					+ " order by o.payDate  ASC ").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Advice> phar_listOrders_wt(String pharmacistID) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			 
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where o.orderStatus ='wt' "
					+ " and a.pharmacist.pharmacistID= '"+pharmacistID+"' "
					+ " order by o.payDate  ASC ").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Advice> phar_listOrders_T(String pharmacistID) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			 
			 SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
			 Calendar c = Calendar.getInstance();
			 c.add(Calendar.MONTH, -1);
			 Date d = c.getTime();
			
			session.beginTransaction();
			List<Advice> advice = session.createQuery("select a From Orders o join  Advice a on o.orderId=a.orders.orderId"
					+ " where o.orderStatus ='T' "
					+ " and  '"+df.format(d)+"' <  o.shippingDate "
					+ " and a.pharmacist.pharmacistID= '"+pharmacistID+"' "
					+ " order by o.shippingDate  DESC ").list();
			session.close();
			
			return advice;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public int successStoreOrder(String orderId) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			
			 SimpleDateFormat df =  new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
			Calendar c = Calendar.getInstance();
			Date d = c.getTime();
			
			Query q = session.createQuery("update Orders set orderStatus= 'T' "
							+ " , shippingDate = '"+df.format(d)+"' " 
							+ " where orderId='"+orderId+"' ");

			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}
	
	public int addShipping(String orderId, String shippingDate, String shippingCompany, String trackingNumber) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			
			
			Query q = session.createQuery("update Orders set orderStatus= 'T' "
							+ " , shippingDate = '"+shippingDate+"' " 
							+ " , shippingCompany = '"+shippingCompany+"' " 
							+ " , trackingNumber = '"+trackingNumber+"' " 
							+ " where orderId='"+orderId+"' ");

			int status = q.executeUpdate();
			session.close();
			
			return status;
			
		} catch (Exception e) {
			return 0;
		}
	}

	/*
	public List<Orders> listOrdersMember(String id) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Orders> orders = session.createQuery("From Orders where  Mem_id='"+id+"' order by orders_id desc").list();
			session.close();
			
			return orders;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	public List<Order_detail> listAllOrdersDetail(String oid) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
			Session session = sessionFactory.openSession();
			
			session.beginTransaction();
			List<Order_detail> order_detail = session.createQuery("From Order_detail where orders_id='"+oid+"'").list();
			session.close();
			
			return order_detail;
			
		} catch (Exception e) {
			return null;
		}
	}
	
	/*
	public String insertOrder(Orders orders) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();

			Session session = sessionFactory.openSession();
			Transaction t = session.beginTransaction();
			session.save(orders);
			t.commit();
			session.close();
			return "successfully saved";
		} catch (Exception e) {
			return "failed to save order";
		}
	}
	*/
	
	/*
	public String insertOrder(Orders o,String oid) {
		HibernateConnection condb = new HibernateConnection();
		Connection con = condb.getConnection();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		Calendar Cdate = Calendar.getInstance();
		Date orderdate = Cdate.getTime();

		try {
			Statement stmt = con.createStatement();
			String sql = "";

				sql =  "insert into orders values('"+oid+"','"+df.format(orderdate)+"' "
						+ ", '"+o.getMember().getMem_id()+"',null"+" "
						+ ","+o.getSubtotal_price()+" ,"+o.getTotal_price()+" "
						+ " , null , '"+o.getNotes()+"' "
								+ ",'T'"
						+ ",'"+o.getName()+"','"+o.getMobileNo()+"' "
						+ ",'"+o.getAddress()+"','"+o.getSubdistrict()+"' "
						+ ",'"+o.getDistrict()+"','"+o.getProvince()+"' "
						
						+ ", null )" ;						
			
			int result = stmt.executeUpdate(sql);
			con.close();
			if(result==1) {
				return "successfully saved";
			}else {
				return"fail to add order";
			}
			
		} catch (SQLException e) {
			return "failed to save order";
		}
		
	}
	
	
	public String insertOrder_Detail(Order_detail Order_detail) {
		try {
			SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();

			Session session = sessionFactory.openSession();
			Transaction t = session.beginTransaction();
			session.saveOrUpdate(Order_detail);
			t.commit();
			session.close();
			return "successfully saved";
		} catch (Exception e) {
			return "failed to save student";
		}
	}
	

	


	*/
}
