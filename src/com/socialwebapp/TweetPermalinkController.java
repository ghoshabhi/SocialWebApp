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
		String id = req.getPathInfo().split("/")[1];
		System.out.println("25: " + id);
		
		long tweetId = 0;
		
		try{
			tweetId = Long.parseLong(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		System.out.println("35: " + tweetId);
		
		Entity tweet = null;
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Key tweetKey = KeyFactory.createKey("Tweet", tweetId);
		
		try {
			tweet = ds.get(tweetKey);
			
			System.out.println((String) tweet.getProperty("message"));
			
			resp.setContentType("text/html");
			req.setAttribute("id", tweetId);
			req.setAttribute("tweet", tweet);
			req.getRequestDispatcher("show_tweet.jsp").forward(req, resp);
		} catch (EntityNotFoundException e) {
			e.printStackTrace();
		}
	}

}
