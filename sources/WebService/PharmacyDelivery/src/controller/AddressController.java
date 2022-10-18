
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

import com.google.gson.Gson;

import bean.Address;
import bean.Advice;
import bean.Orders;
import bean.Stock;

@Controller
public class AddressController {
	
	@RequestMapping(value = "/address/list",  method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_listAddress(@RequestBody Map<String, String> map) {
		List<Address> address = null;
		try {
			String MemberUsername = map.get("MemberUsername");
			
			AddressManager am = new 	AddressManager();
			address = am.listAddress(MemberUsername);
			return new ResponseObj(200, address);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, address);
	}

	@RequestMapping(value = "/address/add",  method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_addAddress(@RequestBody Map<String, String> map) {
		Address address = new Address();
		String message = "";
		try {
			Gson gson = new Gson();
			address= gson.fromJson(map.get("address"), Address.class);
			
			AddressManager am = new AddressManager();
			
			List<Address> a =  am.listAllAddress();
			String addressId = "";
			if(a.size() == 0) {
				addressId="100";
			}
			else {		
				String A_Oid = a.get(a.size()-1).getAddressId() ;
				int aid=Integer.parseInt(A_Oid) ;
				addressId =Integer.toString(aid+1);			
			}	
			address.setAddressId(addressId);
			address.setStatus("T");
			
			message =  am.insertAddress(address);
			
			if ("successfully saved address".equals(message)) {
				return new ResponseObj(200, 1);
			}else {
				return new ResponseObj(200, 0);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, address);
	}
	
	@RequestMapping(value = "/address/remove",  method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_removeAddress(@RequestBody Map<String, String> map) {
		int status = 0;
		try {
			String addressId = map.get("addressId");
			String MemberUsername = map.get("MemberUsername");
			
			AddressManager am = new 	AddressManager();
			status = am.removeAddress(addressId, MemberUsername);
			return new ResponseObj(200, status);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, status);
	}

	@RequestMapping(value = "/address/get", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_getAddress(@RequestBody Map<String, String> map) {
		Address address = null;
		try {
			String addressId = map.get("addressId") ;

			AddressManager m = new AddressManager();
			address = m.getAddress(addressId);
			
			if(address!=null) {
				return new ResponseObj(200, address);
			}else {
				return new ResponseObj(200, 0);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, address);
	}
}

