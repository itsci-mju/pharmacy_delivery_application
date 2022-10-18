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

import bean.MedicineType;

@Controller
public class MedicineTypeController {
	@RequestMapping(value = "/medicine_type/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listMedicineType(HttpServletRequest request) {
		List<MedicineType> medicineType = null;
		try {
			MedicineTypeManager m = new 	MedicineTypeManager();
			medicineType = m.listAllMedicineType();
			System.out.println(medicineType.toString());
			return new ResponseObj(200, medicineType);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, medicineType);
	}
}
