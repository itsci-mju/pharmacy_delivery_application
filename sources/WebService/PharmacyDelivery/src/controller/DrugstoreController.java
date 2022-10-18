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

import bean.Drugstore;

@Controller
public class DrugstoreController {
	
	@RequestMapping(value = "/drugstore/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listDrugstore(HttpServletRequest request) {
		List<Drugstore> drugstores = null;
		try {
			DrugstoreManager dm = new 	DrugstoreManager();
			drugstores = dm.listAllDrugstore();
			System.out.println(drugstores.toString());
			return new ResponseObj(200, drugstores);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, drugstores);
	}
	/*
	@RequestMapping(value = "/drugstore/search", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_searchDrugstore(@RequestBody Map<String, String> map) {
		List<Drugstore> drugstores = null;
		try {
			String name = map.get("drugstore_name");
			
			DrugstoreManager dm = new 	DrugstoreManager();
			drugstores = dm.searchDrugstore(name);
			System.out.println(drugstores.toString());
			
			if (drugstores != null) {
				return new ResponseObj(200, drugstores);
			}else {
				return new ResponseObj(200, null);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);
		}
	}
	
	@RequestMapping(value = "/drugstore/getprofile", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_getDrugstore(@RequestBody Map<String, String> map) {
		Drugstore drugstore = null;
		try {
			String id = map.get("drugstore_id");
			
			DrugstoreManager  dm = new DrugstoreManager();
			drugstore = dm.getDrugstore(id);
			
			if (drugstore != null) {
				return new ResponseObj(200, drugstore);
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
