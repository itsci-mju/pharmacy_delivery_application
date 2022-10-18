package controller;

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

import bean.*;

@Controller
public class PharmacistController {
	
	@RequestMapping(value = "/pharmacist/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listPharmacist(HttpServletRequest request) {
		List<Pharmacist> pharmacist = null;
		try {
			PharmacistManager m = new 	PharmacistManager();
			pharmacist = m.listAllPharmacist();
			System.out.println(pharmacist.toString());
			return new ResponseObj(200, pharmacist);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, pharmacist);
	}
	

	@RequestMapping(value = "/pharmacist/login", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_loginPharmacist(@RequestBody Map<String, String> map) {
		String message = "";
		Pharmacist pharmacist = null;
		try {
			String username = map.get("pharmacistID");
			String password = map.get("pharmacistPassword");
			//password = PasswordUtil.getInstance().createPassword(password, SALT);
			
			pharmacist = new Pharmacist(username, password);
			PharmacistManager pm = new PharmacistManager();
			message = pm.doHibernateLogin(pharmacist);
			if ("login success".equals(message)) {
				pharmacist = pm.getPharmacist(username);
				int status = pm.setStatusOnline(username);
				return new ResponseObj(200, pharmacist);
			}else {
				return new ResponseObj(200, "0");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, "0");
		}
	}
	@RequestMapping(value = "/pharmacist/logout", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_logoutPharmacist(@RequestBody Map<String, String> map) {
		String message = "";
		try {
			String pharmacistID = map.get("pharmacistID");
			
			PharmacistManager pm = new PharmacistManager();
			int status = pm.setStatusOffline(pharmacistID);
			return new ResponseObj(200, status);
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, 0);
		}
	}
	
	@RequestMapping(value = "/pharmacist/checkonline", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_checkPharmacist(@RequestBody Map<String, String> map) {
		List<Pharmacist> pharmacist = null;
		try {
			String drugstoreID = map.get("drugstoreID");
			
			PharmacistManager pm = new PharmacistManager();
			pharmacist = pm.checkPharmacistOnline(drugstoreID);

			System.out.println(pharmacist.toString());
			return new ResponseObj(200, pharmacist);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, pharmacist);
	}
	
	
	/*
	@RequestMapping(value = "/pharmacist/getprofile", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_getProfilePharmacist(@RequestBody Map<String, String> map) {
		Pharmacist pharmacist = null;
		try {
			String username = map.get("pharmacistID");

			PharmacistManager pm = new PharmacistManager();
			pharmacist = pm.getPharmacist(username);
			
			if (pharmacist != null) {
				return new ResponseObj(200, pharmacist);
			}else {
				return new ResponseObj(200, null);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);
		}
	}
*/
	
}

