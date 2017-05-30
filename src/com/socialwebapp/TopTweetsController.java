package com.socialwebapp;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.SortDirection;

@SuppressWarnings("serial")
public class TopTweetsController extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		DatastoreService ds =  DatastoreServiceFactory.getDatastoreService();
		Query queryAllTweets = new Query("Tweet").addSort("view_counter", SortDirection.DESCENDING);
		List<Entity> tweets = ds.prepare(queryAllTweets).asList(FetchOptions.Builder.withLimit(30));
		
		for(Entity tweet : tweets) {
			System.out.print(tweet.getProperty("message"));
			System.out.print(tweet.getProperty("view_counter") + "  | ");
		}
		
		req.setAttribute("top_tweets", tweets);
		res.setContentType("text/html");
		req.getRequestDispatcher("top_tweets.jsp").forward(req, res);
	}
}
