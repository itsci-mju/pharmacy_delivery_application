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
public class StockController {
	@RequestMapping(value = "/stock/list", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_listStock(@RequestBody Map<String, String> map) {
		List<Stock> stock = null;
		try {
			String drugstoreID = map.get("drugstoreID") ;
			StockManager m = new StockManager();
			stock = m.listAllStock(drugstoreID);
			System.out.println(stock.toString());
			return new ResponseObj(200, stock);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, stock);
	}
	
	@RequestMapping(value = "/stock/get", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_getStock(@RequestBody Map<String, String> map) {
		Stock stock = null;
		try {
			String drugstoreID = map.get("drugstoreID") ;
			String medId = map.get("medId") ;

			StockManager m = new StockManager();
			stock = m.getStock(drugstoreID,medId);
			System.out.println(stock.toString());
			return new ResponseObj(200, stock);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, stock);
	}
	
	/*
	@RequestMapping(value = "/stock/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listStock(HttpServletRequest request) {
		List<Stock> stock = null;
		try {
			StockManager m = new StockManager();
			stock = m.listAlStock();
			System.out.println(stock.toString());
			return new ResponseObj(200, stock);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, stock);
	}
	*/

}

