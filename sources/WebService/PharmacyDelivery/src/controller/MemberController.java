package controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import bean.Member;

@Controller
public class MemberController {
	private static String SALT = "123456";
	
	
	@RequestMapping(value = "/member/list", method = RequestMethod.POST)
	public @ResponseBody ResponseObj do_listMember(HttpServletRequest request) {
		List<Member> members = null;
		try {
			MemberManager rm = new MemberManager();
			members = rm.listAllMembers();
			System.out.println(members.toString());
			return new ResponseObj(200, members);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseObj(500, members);
	}
	

	@RequestMapping(value = "/member/login", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_login(@RequestBody Map<String, String> map) {
		String message = "";
		Member member = null;
		try {
			String username = map.get("MemberUsername");
			String password = map.get("MemberPassword");
			//password = PasswordUtil.getInstance().createPassword(password, SALT);
			
			member = new Member(username, password);
			MemberManager rm = new MemberManager();
			message = rm.doHibernateLogin(member);
			if ("login success".equals(message)) {
				member = rm.getMember(username);
				return new ResponseObj(200, member);
			}else {
				return new ResponseObj(200, "0");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, "0");
		}
	}
	

	@RequestMapping(value = "/member/register", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_register(@RequestBody Map<String, String> map) {
		String message = "";
		Member member = null;
		try {
			String username = map.get("MemberUsername");
			String password = map.get("MemberPassword");		
			
			String MemberName = map.get("MemberName");
			String MemberGender= map.get("MemberGender");
			String  MemberTel= map.get("MemberTel");

			String  MemberEmail= map.get("MemberEmail");
			String  MemberImg= map.get("MemberImg");

			member = new Member(username, password,MemberName,MemberGender,MemberTel,MemberEmail,MemberImg);
			MemberManager rm = new MemberManager();
			message = rm.insertMember(member);
			System.out.println(message);
			if ("successfully saved".equals(message)) {
				return new ResponseObj(200, "1");
			}else {
				return new ResponseObj(200, "0");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			message = "Please try again....";
			return new ResponseObj(500, "0");
		}
	}
	

	@RequestMapping(value = "/review/getmember", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_getMember_Review(@RequestBody Map<String, String> map) {
		Member member = null;
		try {
			String reviewId =map.get("reviewId"); //"80001";

			MemberManager rm = new MemberManager();
			member = rm.getMember_Review(reviewId);
			
			if (member != null) {
				return new ResponseObj(200, member);
			}else {
				return new ResponseObj(200, null);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseObj(500, null);
		}
	}
	
	/*
	@RequestMapping(value = "/member/getprofile", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseObj do_getProfileMember(@RequestBody Map<String, String> map) {
		Member member = null;
		try {
			String username = map.get("MemberUsername");

			MemberManager rm = new MemberManager();
			member = rm.getMember(username);
			
			if (member != null) {
				return new ResponseObj(200, member);
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
