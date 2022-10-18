package conn;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

import bean.*;

public class HibernateConnection {
	public static SessionFactory sessionFactory;
	static String url = "jdbc:mysql://localhost:3306/project_pharmacydelivery?characterEncoding=UTF-8"; 
	static String uname = "root";
	static String pwd = "1234";
	private Connection con;
	
	public static SessionFactory doHibernateConnection(){
		Properties database = new Properties();
		//database.setProperty("hibernate.hbm2ddl.auto", "create"); //หลังจากสร้างตารางแล้วให้เอาออก
		database.setProperty("hibernate.connection.driver_class","com.mysql.jdbc.Driver");
		database.setProperty("hibernate.connection.username",uname);
		database.setProperty("hibernate.connection.password",pwd);
		database.setProperty("hibernate.connection.url",url);
		database.setProperty("hibernate.dialect","org.hibernate.dialect.MySQL5InnoDBDialect");
		Configuration cfg = new Configuration()
							.setProperties(database)
							.addPackage("bean")
							.addAnnotatedClass(Owner.class)
							.addAnnotatedClass(Drugstore.class)
							.addAnnotatedClass(MedicineType.class)
							.addAnnotatedClass(Medicine.class)
							.addAnnotatedClass(Stock.class)
							.addAnnotatedClass(StockId.class)
							.addAnnotatedClass(Pharmacist.class)
							.addAnnotatedClass(Coupon.class)
							.addAnnotatedClass(Member.class)
						    .addAnnotatedClass(Address.class)
						    .addAnnotatedClass(Review.class)
							 .addAnnotatedClass(Orders.class)
							 .addAnnotatedClass(OrderDetail.class)
							 .addAnnotatedClass(OrderDetailId.class)
							 .addAnnotatedClass(Advice.class)
							;
		StandardServiceRegistryBuilder ssrb = new StandardServiceRegistryBuilder().applySettings(cfg.getProperties());
		sessionFactory = cfg.buildSessionFactory(ssrb.build());
		return sessionFactory;
	}
	
	public Connection getConnection() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection(url, uname, pwd);
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(con!=null)
				try{ con.close(); } catch (SQLException ignore) {}
		}
		return con;
	}
}
