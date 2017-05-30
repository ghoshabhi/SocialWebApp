package com.socialwebapp;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key; 
import com.google.appengine.api.datastore.Query; 
import com.google.appengine.api.datastore.Query.FilterOperator;

@SuppressWarnings("serial")
public class DeleteTweetController extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		Entity tweetToDelete = null;
		long tweetId = Long.parseLong((String)req.getParameter("id"));
		
		if(req.getSession().getAttribute("fb_id") != null) {
			long loggedInUserId = Long.parseLong((String) req.getSession().getAttribute("fb_id"));
			if(tweetId != 0) {
				Query queryUser = new Query("Tweet").setFilter(FilterOperator.EQUAL.of("tweet_id", tweetId));
				tweetToDelete = ds.prepare(queryUser).asSingleEntity();
				if(tweetToDelete != null) {
					if((Long)tweetToDelete.getProperty("user_id") == loggedInUserId) {
						req.setAttribute("owner", true);
					} else {
						req.setAttribute("owner", false);
					}
					req.setAttribute("tweet_to_delete", tweetToDelete);
				} else {
					req.setAttribute("tweet_to_delete", null);
				}
			} else {
				req.setAttribute("tweet_to_delete", null);
			}
		} else {
			req.setAttribute("owner", false);
		}
		req.getRequestDispatcher("delete_tweet.jsp").forward(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		boolean userDeleted = false;
		try {
			userDeleted = deleteEntity(req, res);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		res.sendRedirect("/new_tweet?delete=" + userDeleted);
	}
	
	private boolean deleteEntity(HttpServletRequest req, HttpServletResponse res) throws InterruptedException {
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		Entity tweetToDelete = null;
		boolean operationStatus = false;
		
		long tweetId = Long.parseLong((String)req.getParameter("id"));
		
		if(tweetId != 0) {
			Query queryUser = new Query("Tweet").setFilter(FilterOperator.EQUAL.of("tweet_id", tweetId));
			tweetToDelete = ds.prepare(queryUser).asSingleEntity();
			if(tweetToDelete != null) {
				Key key = tweetToDelete.getKey();
				ds.delete(key);
				Thread.sleep(2000);
				operationStatus = true;
				
			}
		} else {
			operationStatus = false;
		}
		return operationStatus;
	}
}
