package com.socialwebapp;

import java.io.IOException;
// import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

@SuppressWarnings("serial")
public class TweetPermalinkController extends HttpServlet {
	
//	private static final Logger log = Logger.getLogger(NewTweetController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		
		long fb_id = 0;
		
		if(req.getSession().getAttribute("fb_id") != null) {
			fb_id = Long.valueOf((String)req.getSession().getAttribute("fb_id"));
		} 
		
		if(fb_id == 0) {
			System.out.println("32: No session present");
		} else {
			System.out.println("34: Session fb_id " + fb_id);
		}
		
		String id = req.getParameter("id");
		// System.out.println("25: " + id);
		
		long tweetId = 0;
		
		try{
			tweetId = Long.parseLong(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// System.out.println("35: " + tweetId);
		
		Entity tweet = null;
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Key tweetKey = KeyFactory.createKey("Tweet", tweetId);
		
		try {
			tweet = ds.get(tweetKey);
			
			// Update  counter
			if((Long)tweet.getProperty("user_id") != fb_id && fb_id != 0) {
				tweet.setProperty("view_counter", (Long)tweet.getProperty("view_counter") + 1);
				ds.put(tweet);
				
				//System.out.println("63: " + (Long)tweet.getProperty("view_counter"));
			}
			
			System.out.println("FB_ID: " + fb_id);
			System.out.println("Tweet Owner: " + (Long)tweet.getProperty("user_id"));
			long tweet_owner_id = (Long)tweet.getProperty("user_id");
			
			if(tweet_owner_id == fb_id) {
				System.out.println("Line 69: TPLC");
				req.setAttribute("user_id", tweet_owner_id);
			}
			//System.out.println("72: " + (String)req.getSession().getAttribute("user_id"));
			resp.setContentType("text/html");
			req.setAttribute("tweet_id", tweetId);
			req.setAttribute("tweet", tweet);
			req.getRequestDispatcher("show_tweet.jsp").forward(req, resp);
		} catch (EntityNotFoundException e) {
			e.printStackTrace();
		}
	}

}