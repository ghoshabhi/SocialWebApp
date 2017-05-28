package com.socialwebapp;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;

@SuppressWarnings("serial")
public class HomePageController extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		resp.setContentType("text/html");
		req.getRequestDispatcher("index.jsp").forward(req, resp);
	}
	
	@SuppressWarnings("deprecation")
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		JSONObject json = new JSONObject();
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		Entity user = null;
		
		Query queryUser = new Query("User").setFilter(FilterOperator.EQUAL.of("fb_id", req.getParameter("userID")));
		int userCount = ds.prepare(queryUser).countEntities();
		// user = ds.prepare(queryUser).asSingleEntity();
	
		System.out.println("count: " + userCount);
		
		if(userCount == 0) {
			user = new Entity("User");
			user.setProperty("name", req.getParameter("name"));
			user.setProperty("email", req.getParameter("email"));
			user.setProperty("fb_id", req.getParameter("userID"));
			ds.put(user);
			
			Cookie userCookie = new Cookie("fb_id", req.getParameter("userID"));
			userCookie.setMaxAge(24*60*60);
			userCookie.setDomain(getServletInfo());
			resp.addCookie(userCookie);
			
			req.getSession().setAttribute("fb_id", req.getParameter("userID"));
			
			//req.setAttribute("user", user);
			try {
				json.put("new_user", "false");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			PrintWriter out = resp.getWriter();
			out.write(json.toString());
			out.close();
		} else {
			user = ds.prepare(queryUser).asSingleEntity();
			
			if(req.getSession().getAttribute("fb_id") == null) {
				req.getSession().setAttribute("fb_id", user.getProperty("fb_id"));
			}
			
			System.out.println(req.getSession().getAttribute("fb_id"));
			
//			Cookie[] cookies = req.getCookies();
//
//			for (int i = 0; i < cookies.length; i++) {
//				//System.out.println("69: " + cookies[i].getValue());
//				if(cookies[i].getName().equals("fb_id")) {
//					System.out.println("69: " + cookies[i].getValue());
//				}
//			}
//			System.out.println((String) user.getProperty("name"));
//			System.out.println((String) user.getProperty("fb_id"));
			try {
				json.put("user", user.toString());
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			PrintWriter out = resp.getWriter();
			out.write(json.toString());
			out.close();
		}
	}
}
