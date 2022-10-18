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
public class OwnerController {
	
	@RequestMapping(value = "/owner/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listOwner(HttpServletRequest request) {
		List<Owner> owner = null;
		try {
			OwnerManager m = new 	OwnerManager();
			owner = m.listAllAddress();
			System.out.println(owner.toString());
			return new ResponseObj(200, owner);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, owner);
	}

}

