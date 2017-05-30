package com.socialwebapp;

import java.io.IOException;
import java.util.Iterator;
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
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.labs.repackaged.org.json.JSONArray;
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;

@SuppressWarnings("serial")
public class FriendsTweetsPageController extends HttpServlet {
	@SuppressWarnings("deprecation")
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		List<Entity> tweets = null;
		Query queryAllTweets = null;
		
		if(req.getSession().getAttribute("fb_id") != null) {
			queryAllTweets = new Query("Tweet").addFilter("user_id", FilterOperator.NOT_EQUAL, Long.valueOf((String)req.getSession().getAttribute("fb_id")));
			req.setAttribute("user", (String) req.getSession().getAttribute("fb_id"));
		} else {
			queryAllTweets = new Query("Tweet");
			req.setAttribute("user", null);
		}

		tweets = ds.prepare(queryAllTweets).asList(FetchOptions.Builder.withLimit(10));
		
		Query queryAllUsers = new Query("User");
		List<Entity> users = ds.prepare(queryAllUsers).asList(FetchOptions.Builder.withDefaults());
		
		JSONObject mainList = new JSONObject();
		
		for(Entity user : users) {
			JSONArray dataArray = new JSONArray();
			for(Entity tweet : tweets) {
				if((Long)tweet.getProperty("user_id") == Long.parseLong((String)user.getProperty("fb_id"))) {
					JSONObject tweetObj = new JSONObject();
					try {
						tweetObj.put("user_name", (String)user.getProperty("name"));
						tweetObj.put("views_counter", (Long)tweet.getProperty("view_counter"));
						tweetObj.put("tweet_id", (Long)tweet.getKey().getId());
						tweetObj.put("tweet_message", (String)tweet.getProperty("message"));
						tweetObj.put("created_at", (String)tweet.getProperty("created_at"));
						dataArray.put(tweetObj);
					} catch (JSONException e) {
						e.printStackTrace();
					}
				} else {
					continue;
				}
			}
			try {
				mainList.put((String)user.getProperty("name"), dataArray);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		req.setAttribute("friends_tweets", mainList);		
		resp.setContentType("text/html");
		req.getRequestDispatcher("friends.jsp").forward(req, resp);
	}

}
