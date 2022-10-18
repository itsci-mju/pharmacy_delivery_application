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

import bean.Member;
import bean.OrderDetail;
import bean.Orders;
import bean.Review;

@Controller
public class ReviewController {
	
	@RequestMapping(value = "/review/list", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_listReview(@RequestBody Map<String, String> map) {
		List<Review> reviews = null;
		try {
			String drugstoreID = map.get("drugstoreID") ;
			
			ReviewManager m = new ReviewManager();
			reviews = m.listAllReview(drugstoreID);
			System.out.println(reviews.toString());
			
			if (reviews != null) {
				return new ResponseObj(200, reviews);
			}else {
				return new ResponseObj(200, null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);
		}
	}
	
	@RequestMapping(value = "/review/add", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_addReview(@RequestBody Map<String, String> map) {
		int status = 0;
		Review review = new Review();
		try {
			String orderId = map.get("orderId");
			Gson gson = new Gson();
			review= gson.fromJson(map.get("review"), Review.class);
			
			 Calendar c = Calendar.getInstance();
			review.setReviewDate(c);
			
			ReviewManager rm = new ReviewManager();
			List<Review> r =  rm.listReview();
			String reviewId = "";
			if(r.size() == 0) {
				reviewId="80001";
			}
			else {		
				String S_Rid = r.get(r.size()-1).getReviewId();
				int rid=Integer.parseInt(S_Rid) ;
				reviewId =Integer.toString(rid+1);			
			}	
			
			review.setReviewId(reviewId);
			Calendar reviewdate = Calendar.getInstance();
			review.setReviewDate(reviewdate);
			status = rm.addReview(review);
			
			OrdersManager om = new OrdersManager();
			status = om.updateReview( orderId,review.getReviewId());

			return new ResponseObj(200, status);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, 0);
		}
	}
	

	
	/*
	 @RequestMapping(value = "/review/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listReview(HttpServletRequest request) {
		List<Review> review = null;
		try {
			ReviewManager m = new ReviewManager();
			review = m.listAllReview();
			System.out.println(review.toString());
			return new ResponseObj(200, review);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, review);
	}
	 */

}

