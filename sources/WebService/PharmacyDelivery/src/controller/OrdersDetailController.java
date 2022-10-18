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
public class OrdersDetailController {
	@RequestMapping(value = "/order_detail/list", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_listOrderDetail(@RequestBody Map<String, String> map) {
		List<OrderDetail> orderDetail = null;
		try {
			String orderId = map.get("orderId");
			
			OrdersDetailManager odm = new OrdersDetailManager();
			orderDetail = odm.listAllOrdersDetail(orderId);
			
			return new ResponseObj(200, orderDetail);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, orderDetail);
	}
	
	@RequestMapping(value = "/order_detail/add", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_addOrderDetail(@RequestBody Map<String, String> map) {
		OrderDetail orderDetail = new OrderDetail() ;
		String message = "";
		try {
			Gson gson = new Gson();
			orderDetail = gson.fromJson(map.get("orderDetail"), OrderDetail.class);
			String drugstoreId = map.get("drugstoreId");
			
			MedicineManager mm =new MedicineManager();
			Medicine med = mm.getMedicine(orderDetail.getMedicine().getMedId());
			orderDetail.setMedicine(med);
			
			OrdersDetailManager odm = new OrdersDetailManager();
			message = odm.insertOrderDetail(orderDetail);
			
			StockManager sm = new StockManager();
			int result = sm.reduceMedQty(drugstoreId, orderDetail.getMedicine().getMedId(), orderDetail.getQuantity());
			
			System.out.println(message);
			
			if ("successfully saved OrderDetail".equals(message)) {
				return new ResponseObj(200, orderDetail);
			}else {
				return new ResponseObj(200, "0");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, "0");
		}
	}
	/*
	 	@RequestMapping(value = "/order_detail/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listOrderDetail(HttpServletRequest request) {
		List<OrderDetail> orderDetail = null;
		try {
			OrdersDetailManager odm = new OrdersDetailManager();
			orderDetail = odm.listAllOrdersDetail();
			System.out.println(orderDetail.toString());
			return new ResponseObj(200, orderDetail);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, orderDetail);
	}
	 */
}
