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
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.logging.*;

@SuppressWarnings("serial")
public class NewTweetController extends HttpServlet {
	
	private static final Logger log = Logger.getLogger(NewTweetController.class.getName());
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		long fb_id = 0;
		
		if(req.getSession().getAttribute("fb_id") != null) {
			fb_id = Long.valueOf((String) req.getSession().getAttribute("fb_id"));
			System.out.println("38: Controller: " + fb_id);
		}
		System.out.println("40: Controller: " + fb_id);
//		Cookie[] cookies = req.getCookies();
//
//		for (int i = 0; i < cookies.length; i++) {
//			//System.out.println("69: " + cookies[i].getValue());
//			if(cookies[i].getName().equals("fb_id")) {
//				System.out.println("38: " + cookies[i].getValue());
//				fb_id = cookies[i].getValue();
//			}
//		}
		
		if(fb_id != 0) {
			System.out.println("Line 52: " + fb_id);
			//Query queryUser = new Query("User").setFilter(FilterOperator.EQUAL.of("fb_id", fb_id));
			//int userCount = ds.prepare(queryUser).countEntities();
			//Query queryAllTweets = new Query("Tweet")
			Query queryAllTweets = new Query("Tweet").setFilter(FilterOperator.EQUAL.of("user_id", fb_id));
			List<Entity> tweets = ds.prepare(queryAllTweets).asList(FetchOptions.Builder.withLimit(10));
			
			req.setAttribute("user", fb_id);
			req.setAttribute("tweets", tweets);
			System.out.println("Line 60: " + fb_id);
//			System.out.print("Tweets Size: " + tweets.size());
//			
//			for(Entity tweet : tweets) {
//				System.out.print(tweet.getProperty("message"));
//				System.out.print(tweet.getKey().getId());
//			}

//			if(userCount > 0) {				
//				req.setAttribute("tweets", tweets);
//				req.setAttribute("user", fb_id);
//			} else {
//				System.out.println("72: " + userCount);
//				req.setAttribute("user", null);
//			}
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
		
		// Create new Tweet entity
		Entity newTweet = new Entity("Tweet");
		newTweet.setProperty("message", tweet);
		newTweet.setProperty("view_counter", 0);
		newTweet.setProperty("user_id", userID);

		// Save to DB
		ds.put(newTweet);
		
		// Get new Tweet's ID and Save it (Datastore doesn't provide a way to get IDs in JSP)
		long newTweetId = newTweet.getKey().getId();
		newTweet.setProperty("tweet_id", newTweetId);
		ds.put(newTweet);
		
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
