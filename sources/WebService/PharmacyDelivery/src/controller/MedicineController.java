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
public class MedicineController {
	
	@RequestMapping(value = "/medicine/list", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_listMedicine(@RequestBody Map<String, String> map) {
		List<Medicine> medicines = null;
		try {
			String drugstoreID = map.get("drugstoreID") ;

			MedicineManager mm = new 	MedicineManager();
			medicines = mm.listAllMedicine(drugstoreID);
			System.out.println(medicines.toString());
			
			if (medicines != null) {
				return new ResponseObj(200, medicines);
			}else {
				return new ResponseObj(200, null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);

		}
	}
	
/*	
	@RequestMapping(value = "/medicine/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listMedicine(HttpServletRequest request) {
		List<Medicine> medicines = null;
		try {
			MedicineManager m = new MedicineManager();
			medicines = m.listAllMedicine();
			System.out.println(medicines.toString());
			return new ResponseObj(200, medicines);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, medicines);
	}

	
	@RequestMapping(value = "/medicine/search", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_searchMedicine(@RequestBody Map<String, String> map) {
		List<Medicine> medicines = null;
		try {
		String drugstore_id = map.get("drugstore_id") ;
		String med_name = map.get("med_name") ;

			System.out.println(map.keySet());
			MedicineManager mm = new 	MedicineManager();
			medicines = mm.searchMedicine(drugstore_id, med_name);
			System.out.println(medicines.toString());
			
			if (medicines != null) {
				return new ResponseObj(200, medicines);
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
