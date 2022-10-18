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
public class CouponController {
	@RequestMapping(value = "/coupon/list", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_getCoupon(@RequestBody Map<String, String> map) {
		List<Coupon> coupons = null;
		try {
			System.out.println(map.toString());
			String drugstoreID = map.get("drugstoreID") ;
			
			CouponManager m = new 	CouponManager();
			coupons = m.listAllCoupon(drugstoreID);
			System.out.println(coupons.toString());
			
			if (coupons != null) {
				return new ResponseObj(200, coupons);
			}else {
				return new ResponseObj(200, null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);

		}
	}
	
	@RequestMapping(value = "/coupon/check", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_checkCoupon(@RequestBody Map<String, String> map) {
		Coupon coupon = new Coupon();
		try {
			String drugstoreId = map.get("drugstoreID") ;
			String couponName = map.get("couponName") ;
			
			CouponManager m = new 	CouponManager();
			coupon = m.verifyCoupon(couponName,drugstoreId);
			
			return new ResponseObj(200, coupon);

		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);

		}
	}
	
	@RequestMapping(value = "/coupon/min", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_minCoupon(@RequestBody Map<String, String> map) {
		Double min_coupon = 0.0;
		try {
			String drugstoreID = map.get("drugstoreID") ;
			
			CouponManager m = new 	CouponManager();
			min_coupon = m.minCoupon(drugstoreID);
			
			if (min_coupon != 0.0) {
				return new ResponseObj(200, min_coupon);
			}else {
				return new ResponseObj(200, null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);

		}
	}
	
	/*
	@RequestMapping(value = "/coupon/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listCoupon(HttpServletRequest request) {
		List<Coupon> coupon = null;
		try {
			CouponManager m = new 	CouponManager();
			coupon = m.listAllCoupon();
			System.out.println(coupon.toString());
			return new ResponseObj(200, coupon);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, coupon);
	}
*/
}

