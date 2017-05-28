package com.socialwebapp;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;

import java.util.logging.*;

@SuppressWarnings("serial")
public class NewTweetController extends HttpServlet {
	
	private static final Logger log = Logger.getLogger(NewTweetController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		resp.setContentType("text/html");
		req.getRequestDispatcher("new_tweet.jsp").forward(req, resp);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		String tweet = req.getParameter("tweetMessage");
		
		log.warning("AJAX data: " + tweet);
		
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		// Create new Tweet entity
		Entity newTweet = new Entity("Tweet");
		newTweet.setProperty("message", tweet);

		// Save to DB
		ds.put(newTweet);
		
		// Get new Tweet's ID
		long newTweetId = newTweet.getKey().getId();
		String redirectUrl = "/tweet/" + newTweetId;
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
