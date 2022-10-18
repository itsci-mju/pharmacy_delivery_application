package controller;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import bean.*;

@Controller
public class OrdersController {
	@RequestMapping(value = "/orders/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listOrders(HttpServletRequest request) {
		List<Orders> orders = null;
		try {
			OrdersManager om = new OrdersManager();
			orders = om.listOrders();
			return new ResponseObj(200, orders);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, orders);
	}
	
	@RequestMapping(value = "/orders/list_status", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_listOrdersStatus(@RequestBody Map<String, String> map) {
		List<Advice> advice = null;
		try {
			String status = map.get("status");
			String MemberUsername = map.get("MemberUsername");
			
			OrdersManager om = new OrdersManager();
			if(status.equals("cf")) {
				advice = om.listOrders_cf(MemberUsername);
			}else if(status.equals("store")) {
				advice = om.listOrders_store(MemberUsername);
			}else if(status.equals("wt")) {
				advice = om.listOrders_wt(MemberUsername);
			}else if(status.equals("T")) {
				advice = om.listOrders_T(MemberUsername);
			}else if(status.equals("C")) {
				advice = om.listOrders_C(MemberUsername);
			}else if(status.equals("expir")) {
				advice = om.listOrders_expir(MemberUsername);
			}

			return new ResponseObj(200, advice);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, advice);
	}
	
	@RequestMapping(value = "/orders/add", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_addOrder(@RequestBody Map<String, String> map) {
		Orders orders = new Orders();
		String message = "";
		try {
	        int  sumQuantity = Integer.parseInt(map.get("sumQuantity"));
	        Double subtotalPrice = Double.parseDouble(map.get("subtotalPrice"));
	        Double shippingCost = Double.parseDouble(map.get("shippingCost"));
	        Gson gson = new Gson();
			Address address= gson.fromJson(map.get("address"), Address.class);
			
	        Double totalPrice = subtotalPrice+shippingCost;
	        
			OrdersManager om = new OrdersManager();
			List<Orders> o =  om.listOrders();
			String orderId = "";
			if(o.size() == 0) {
				orderId="50001";
			}
			else {		
				String S_Oid = o.get(o.size()-1).getOrderId();
				int oid=Integer.parseInt(S_Oid) ;
				orderId =Integer.toString(oid+1);			
			}	
			
		     orders.setOrderId(orderId);
			Calendar oderdate = Calendar.getInstance();
			orders.setOrderDate(oderdate);
			orders.setSumQuantity(sumQuantity);
			orders.setSubtotalPrice(subtotalPrice);
			orders.setTotalPrice(totalPrice);
			orders.setShippingCost(shippingCost);
			orders.setOrderStatus("wcf");
			orders.setAddress(address);
		
			
			message = om.insertOrder(orders);
			System.out.println(message);

			if ("successfully saved order".equals(message)) {
				return new ResponseObj(200, orders);
			}else {
				return new ResponseObj(200, "0");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, "0");
		}
	}
	

	@RequestMapping(value = "/orders/confirm", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj confirmOrder(@RequestBody Map<String, String> map) {
		String message = "";
		int status=0;
		try {
			String couponName = map.get("couponName");
	        Gson gson = new Gson();
	  			//Address address= gson.fromJson(map.get("address"), Address.class);
	  			Orders orders= gson.fromJson(map.get("orders"), Orders.class);

	  			OrdersManager om = new OrdersManager();
				List<Orders> o =  om.listOrders();
				String orderId = "";
				if(o.size() == 0) {
					orderId="50001";
				}
				else {		
					String S_Oid = o.get(o.size()-1).getOrderId();
					int oid=Integer.parseInt(S_Oid) ;
					orderId =Integer.toString(oid+1);			
				}	
				
				orders.setOrderId(orderId);
				Calendar oderdate = Calendar.getInstance();
				orders.setOrderDate(oderdate);
				orders.setOrderStatus("cf");
				//orders.setAddress(address);
			
				message = om.insertOrder(orders);
				System.out.println(message);

				if ("successfully saved order".equals(message)) {
					if( !couponName.equals("") ) {
						CouponManager cm = new CouponManager();
						status = cm.reduceCouponQty(couponName);
					}
					return new ResponseObj(200, orders);
				}else {
					return new ResponseObj(200, "0");
				}
						
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, 0);
		}
		
	}
	
	@RequestMapping(value = "/orders/get", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_getOrder(@RequestBody Map<String, String> map) {
		Orders orders = null;
		try {
			String orderId = map.get("orderId");
	         
			OrdersManager om = new OrdersManager();
		
			orders = om.getOrder(orderId);
			System.out.println(orders);

			if (orders != null) {
				return new ResponseObj(200, orders);
			}else {
				return new ResponseObj(200, null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);
		}
	}
	
	/*
	@RequestMapping(value = "/orders/pCancel", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj pCancelOrder(@RequestBody Map<String, String> map) {
		String message = "";
		Advice advice = new Advice();
		try {
			String orderId = map.get("orderId");
			Gson gson = new Gson();
			advice= gson.fromJson(map.get("advice"), Advice.class);
			
			OrdersManager m = new OrdersManager();
			int status = m.pCancelOrder(orderId);
			
			AdviceManager am = new AdviceManager();
			advice.setOrders(null);
			status = am.updateAdvice(advice);
			
			 List<OrderDetail> orderDetail  = null;
			 OrdersDetailManager odm = new OrdersDetailManager();
			 orderDetail = odm.listAllOrdersDetail(orderId);
			
			 StockManager sm = new StockManager();
			 for(OrderDetail d : orderDetail) {
				 status = sm.revertMedQty(advice.getPharmacist().getDrugstore().getDrugstoreID(), d.getMedicine().getMedId(), d.getQuantity());
			 }
			
			
			return new ResponseObj(200, status);
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, 0);
		}
		
	}
	*/
	
	
	@RequestMapping(value = "/orders/cancel_member", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj cancelOrderMember(@RequestBody Map<String, String> map) {
		Orders orders = new Orders();
		try {
			Gson gson = new Gson();
			orders= gson.fromJson(map.get("orders"), Orders.class);
			String drugstoreID = map.get("drugstoreID");	
			
			OrdersManager m = new OrdersManager();
			int status = m.cancelOrder_member(orders.getOrderId());
						
			 List<OrderDetail> orderDetail  = null;
			 OrdersDetailManager odm = new OrdersDetailManager();
			 orderDetail = odm.listAllOrdersDetail(orders.getOrderId());
			
			 StockManager sm = new StockManager();
			 for(OrderDetail d : orderDetail) {
				 status = sm.revertMedQty(drugstoreID, d.getMedicine().getMedId(), d.getQuantity());
			 }
			
			 if(orders.getCoupon()!=null ){
				 CouponManager cm = new CouponManager();
				 status = cm.revertCouponQty(orders.getCoupon().getCouponName());
			 }
			
			
			return new ResponseObj(200, status);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, 0);
		}
		
	}
	
	

	@RequestMapping(value = "/orders/pay", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj payOrder(@RequestBody Map<String, String> map) {
		String message = "";
		Advice advice = new Advice();
		try {
			Gson gson = new Gson();
			advice= gson.fromJson(map.get("advice"), Advice.class);
			String receiptId = map.get("receiptId");	

			advice.getOrders().setReceiptId(receiptId);
			Calendar paydate = Calendar.getInstance();
			advice.getOrders().setPayDate(paydate);
			if(advice.getOrders().getAddress()!=null) {
				advice.getOrders().setOrderStatus("wt");
				advice.setMember(advice.getOrders().getAddress().getMember());
			}else{
				advice.getOrders().setOrderStatus("store");
			}

			
			OrdersManager m = new OrdersManager();
			int status = m.payOrder(advice.getOrders());
			
			if(status==1 ) {
				return new ResponseObj(200, advice);
			}else {
				return new ResponseObj(200, "0");
			}
		
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500,"0");
		}
		
	}
	
/********************pharmacist ****************************/
	@RequestMapping(value = "/orders/list_status_pharmacist", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_listOrdersStatusPharmacist(@RequestBody Map<String, String> map) {
		List<Advice> advice = null;
		try {
			String status = map.get("status");
			String pharmacistID = map.get("pharmacistID");
			
			OrdersManager om = new OrdersManager();
			if(status.equals("cf")) {
				advice = om.phar_listOrders_cf(pharmacistID);
			}else if(status.equals("store")) {
				advice = om.phar_listOrders_store(pharmacistID);
			}else if(status.equals("wt")) {
				advice = om.phar_listOrders_wt(pharmacistID);
			}else if(status.equals("T")) {
				advice = om.phar_listOrders_T(pharmacistID);
			}

			return new ResponseObj(200, advice);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, advice);
	}
	
	@RequestMapping(value = "/orders/success_store", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj success_store(@RequestBody Map<String, String> map) {
		try {
			String orderId = map.get("orderId");

			OrdersManager m = new OrdersManager();
			int status = m.successStoreOrder(orderId);
		
			return new ResponseObj(200, status);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, 0);
		}
		
	}
	

	@RequestMapping(value = "/orders/add_shipping", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj add_shipping(@RequestBody Map<String, String> map) {
		String message = "";
		try {
			String orderId = map.get("orderId");
			String shippingDate = map.get("shippingDate");
			String shippingCompany = map.get("shippingCompany");
			String trackingNumber = map.get("trackingNumber");

			OrdersManager m = new OrdersManager();
			int status = m.addShipping(orderId, shippingDate, shippingCompany, trackingNumber);
		
			return new ResponseObj(200, status);
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, 0);
		}
		
	}
	
	
/*	
	@RequestMapping(value = "/orders/list", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_listOrderMember(@RequestBody Map<String, String> map) {
		List<Orders> orders = null;
		try {
			String Mem_id = map.get("Mem_id");
			
			OrdersManager om = new OrdersManager();
			orders = om.listOrdersMember(Mem_id);
			System.out.println(orders.toString());
			
			if (orders != null) {
				return new ResponseObj(200, orders);
			}else {
				return new ResponseObj(200, null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);

		}
	}
	
	@RequestMapping(value = "/order_detail/list", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_listOrderDetail(@RequestBody Map<String, String> map) {
		List<Order_detail> orderDetail = null;
		try {
			String oid = map.get("orders_id");
			
			OrdersManager om = new OrdersManager();
			orderDetail = om.listAllOrdersDetail(oid);
			System.out.println(orderDetail.toString());
			
			if (orderDetail != null) {
				return new ResponseObj(200, orderDetail);
			}else {
				return new ResponseObj(200, null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);

		}
	}
	

	@RequestMapping(value = "/orders/add", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_addOrder(@RequestBody Map<String, String> map) {
		Orders orders = new Orders();
		String message = "";
		try {
			String Mem_id = map.get("Mem_id");
	       //Calendar orders_Date = map.get("orders_Date");
	        Double subtotal_price = Double.parseDouble(map.get("subtotal_price"));
	        Double total_price = Double.parseDouble(map.get("Total_price"));
	        String notes = map.get("notes");
	        
	        String Name = map.get("Name");
	        String mobileNo = map.get("mobileNo");
	        String address = map.get("Address");
	        String subdistrict = map.get("subdistrict");
	        String district = map.get("district");
	        String province = map.get("province");
	        //String zipcode = map.get("zipcode");

			MemberManager  mm = new MemberManager();
			Member member = mm.getMember(Mem_id);
			
			OrdersManager om = new OrdersManager();
			List<Orders> o =  om.getListOrders();
			String orders_id = "";
			if(o.size() == 0) {
				orders_id="50001";
			}
			else {		
				String S_Oid = o.get(o.size()-1).getOrders_id();
				int oid=Integer.parseInt(S_Oid) ;
				orders_id =Integer.toString(oid+1);			
			}	
		
			orders. setMember(member);
			Calendar oderdate = Calendar.getInstance();
			orders.setOrders_Date(oderdate);
			orders.setOrders_id(orders_id);
			orders.setSubtotal_price(subtotal_price);
			orders.setTotal_price(total_price);
			orders.setNotes(notes);
			orders.setName(Name);
			orders.setMobileNo(mobileNo);
			orders.setAddress(address);
			orders.setSubdistrict(subdistrict);
			orders.setDistrict(district);
			orders.setProvince(province);
			
			message = om.insertOrder(orders,orders_id);
			if ("successfully saved".equals(message)) {
				return new ResponseObj(200, orders_id);
			}else {
				return new ResponseObj(200, "0");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, "0");
		}
	}
	

	@RequestMapping(value = "/order_detail/add", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_addOrderDetail(@RequestBody Map<String, String> map) {
		Order_detail order_detail = null;
		String message = "";
		try {
			OrdersManager om = new OrdersManager();
			
			  String orders_id = map.get("orders_id");
		      String med_id  =map.get("med_id");
		      String drugstore_id =map.get("drugstore_id");
		      int amount = Integer.parseInt(map.get("amount"));
		      
		     Orders order = om.getOrder(orders_id);
		   
		     //DrugstoreManager dm = new DrugstoreManager();
		     //Drugstore drugstore = dm.getDrugstore(drugstore_id);
		     
		     MedicineManager mm = new MedicineManager();
		     Medicine medicine = mm.getMedicine(med_id, drugstore_id);
		     
			order_detail = new Order_detail(order,medicine ,amount);
			
			message = om.insertOrder_Detail(order_detail);
			return new ResponseObj(200,order_detail);
	
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, order_detail);
		}
	}

*/
}
