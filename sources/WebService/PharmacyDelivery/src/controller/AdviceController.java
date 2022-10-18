package controller;

import java.util.Calendar;
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
public class AdviceController {
	
	@RequestMapping(value = "/advice/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listAdvice(HttpServletRequest request) {
		List<Advice> advice = null;
		try {
			AdviceManager m = new AdviceManager();
			advice = m.listAllAdvice();
			System.out.println(advice.toString());
			return new ResponseObj(200, advice);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, advice);
	}
	
	@RequestMapping(value = "/advice/add", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_addAdvice(@RequestBody Map<String, String> map) {
		String message = "";
		Advice advice= new Advice();
		AdviceManager am = new AdviceManager();
		Address address = new Address();
		try {
			Calendar startTime  = Calendar.getInstance();
			String pharmacistID = map.get("pharmacistID");	
			String MemberUsername = map.get("MemberUsername");

			
			
			List<Advice> a = am.listAllAdvice();
			String adviceId = "";
			if(a.size() == 0) {
				adviceId="101";
			}
			else {		
				String S_Aid = a.get(a.size()-1).getAdviceId();
				int aid=Integer.parseInt(S_Aid) ;
				adviceId =Integer.toString(aid+1);			
			}	
			
			advice.setAdviceId(adviceId);
			advice.setStartTime(startTime);
			
			PharmacistManager pm = new PharmacistManager();
			advice.setPharmacist(pm.getPharmacist(pharmacistID));
			MemberManager mm = new MemberManager();
		    advice.setMember((mm.getMember(MemberUsername)));
			
			message = am.AddAdvice(advice);
			System.out.println(message);
			if ("successfully saved advice".equals(message)) {
				return new ResponseObj(200, advice);
			}else {
				return new ResponseObj(200, "0");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, "0");
		}
	}
	
	@RequestMapping(value = "/advice/update_orderId", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj updateOrderId(@RequestBody Map<String, String> map) {
		String message = "";
		Orders orders = new Orders();
		Advice advice = new Advice();
		try {
			Gson gson = new Gson();
			advice= gson.fromJson(map.get("advice"), Advice.class);
			orders = gson.fromJson(map.get("orders"), Orders.class);
			
		//	if(orders.getAddress()!=null) {
		//		orders.getAddress().setMember(advice.getMember());
		//	}
		//	advice.setOrders(orders);
					
			AdviceManager m = new AdviceManager();
			int status = m.updateAdvice(advice,orders);
			return new ResponseObj(200, status);
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, 0);
		}
		
	}


	@RequestMapping(value = "/advice/end", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj endAdvice(@RequestBody Map<String, String> map) {
		Advice advice = new Advice();
		try {
			Gson gson = new Gson();
			advice= gson.fromJson(map.get("advice"), Advice.class);
			
			Calendar time = Calendar.getInstance();
			advice.setEndTime(time);
								
			AdviceManager am = new AdviceManager();
			int status = am.endAdvice(advice);
			
			//MessageManager mm = new MessageManager();
			//status = mm.deleteMessages(advice);
			
			return new ResponseObj(200, status);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, 0);
		}
		
	}
	

	@RequestMapping(value = "/advice/get", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj endAdviceMember(@RequestBody Map<String, String> map) {
		Advice advice= new Advice();
		try {
			String adviceId	= map.get("adviceId")	;
				
			AdviceManager am = new AdviceManager();
			 advice = am.getAdvice(adviceId);
			
			return new ResponseObj(200, advice);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, 0);
		}
		
	}
	
	
}

