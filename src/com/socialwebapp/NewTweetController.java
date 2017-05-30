package com.socialwebapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

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

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.logging.*;

@SuppressWarnings("serial")
public class NewTweetController extends HttpServlet {
	
	private static final Logger log = Logger.getLogger(NewTweetController.class.getName());
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		long fb_id = 0;
		
		if(req.getSession().getAttribute("fb_id") != null) {
			fb_id = Long.valueOf((String) req.getSession().getAttribute("fb_id"));
		}
		
		if(fb_id != 0) {
			Query queryAllTweets = new Query("Tweet").setFilter(FilterOperator.EQUAL.of("user_id", fb_id)).addSort("view_counter", SortDirection.DESCENDING);
			List<Entity> tweets = ds.prepare(queryAllTweets).asList(FetchOptions.Builder.withLimit(10));
			
			System.out.println("NTC: " + tweets);
			
			req.setAttribute("user", fb_id);
			req.setAttribute("tweets", tweets);
		} else {
			req.setAttribute("tweets", null);
			req.setAttribute("user", null);
		}
		resp.setContentType("text/html");
		req.getRequestDispatcher("new_tweet.jsp").forward(req, resp);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		String tweet = req.getParameter("tweetMessage");
		long userID = Long.parseLong(req.getParameter("userID"));
		log.warning("AJAX data: " + tweet + " " + userID);
		
		//Fetch User Info
		Query userQuery = new Query("User").setFilter(FilterOperator.EQUAL.of("fb_id", Objects.toString(userID)));
		Entity user = ds.prepare(userQuery).asSingleEntity();
		
		// Create new Tweet entity
		Entity newTweet = new Entity("Tweet");
		newTweet.setProperty("message", tweet);
		newTweet.setProperty("view_counter", 0);
		newTweet.setProperty("user_id", userID);
		
		if(user != null) {
			newTweet.setProperty("posted_by", user.getProperty("name"));
		} else {
			newTweet.setProperty("posted_by", "Unknown user");
		}
		
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		newTweet.setProperty("created_at", dateFormat.format(new Date()));
		
		// Save to DB
		ds.put(newTweet);
		
		// Get new Tweet's ID and Save it (Datastore doesn't provide a way to get IDs in JSP)
		long newTweetId = newTweet.getKey().getId();
		newTweet.setProperty("tweet_id", newTweetId);
		ds.put(newTweet);
		
		try {
			Thread.sleep(2000);
		} catch (InterruptedException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		String redirectUrl = "/tweet?id=" + newTweetId;
		resp.setContentType("application/json");
		
		JSONObject json = new JSONObject();
		try {
			json.put("url", redirectUrl);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		log.warning(json.toString());
		PrintWriter out = resp.getWriter();
		out.write(json.toString());
		out.close();
	}
}
