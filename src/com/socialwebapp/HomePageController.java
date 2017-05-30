package com.socialwebapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.SortDirection;
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;

@SuppressWarnings("serial")
public class HomePageController extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		Entity user = null;
		
		if(req.getSession().getAttribute("fb_id") != null) {
			String fb_id = (String) req.getSession().getAttribute("fb_id");
			Query queryUser = new Query("User").setFilter(FilterOperator.EQUAL.of("fb_id", fb_id));
			
			user = ds.prepare(queryUser).asSingleEntity();
			if (user != null) {
				long id = Long.parseLong((String) user.getProperty("fb_id"));
				Query queryAllTweetsByUser = new Query("Tweet").setFilter(FilterOperator.EQUAL.of("user_id", id)).addSort("view_counter", SortDirection.DESCENDING);
				List<Entity> userTweets = ds.prepare(queryAllTweetsByUser).asList(FetchOptions.Builder.withLimit(10));
				System.out.println("37: " + userTweets);
				req.setAttribute("tweets_by_user", userTweets);
				req.setAttribute("user", user);				
			} else {
				req.setAttribute("user", null);
			}
		} else {
			req.setAttribute("user", null);
		}
		
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
			
			try {
				json.put("user", user.toString());
			} catch (JSONException e) {
				e.printStackTrace();
			}
			PrintWriter out = resp.getWriter();
			out.write(json.toString());
			out.close();
		}
	}
}
