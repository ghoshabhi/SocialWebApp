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
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		List<Entity> tweets = null;
		
		if(req.getSession().getAttribute("fb_id") != null) {
			System.out.println("if");
			@SuppressWarnings("deprecation")
			Query queryAllTweets = new Query("Tweet").addFilter("user_id", FilterOperator.NOT_EQUAL, Long.valueOf((String)req.getSession().getAttribute("fb_id")));
			tweets = ds.prepare(queryAllTweets).asList(FetchOptions.Builder.withLimit(10));
			req.setAttribute("user", (String) req.getSession().getAttribute("fb_id"));
			
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
							tweetObj.put("tweet_id", (Long)tweet.getKey().getId());
							tweetObj.put("tweet_message", (String)tweet.getProperty("message"));
							dataArray.put(tweetObj);
							//System.out.println("53: " + dataArray.toString());
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
				}
				try {
					mainList.put((String)user.getProperty("name"), dataArray);
					System.out.println("57: " + mainList.toString());
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
			req.setAttribute("friends_tweets", mainList);
			
			@SuppressWarnings("unchecked")
			Iterator<String> keys = mainList.keys();
			while(keys.hasNext()){
				String key = keys.next();
				System.out.println("Tweets By: " + key);
				try {
					JSONArray arr = mainList.getJSONArray(key);
					//System.out.println("72: " + arr.toString());
					for(int i=0; i < arr.length(); i++) {
						JSONObject obj = arr.getJSONObject(i);
						System.out.println();
						System.out.println(obj.get("user_name"));
						System.out.println(obj.get("tweet_message"));
						System.out.println("-----------------------------------------");
						System.out.println();
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
			
			//System.out.println("66: " + mainList.toString());
			
		} else {
			System.out.println("else");
			Query queryAllTweets = new Query("Tweet");
			tweets = ds.prepare(queryAllTweets).asList(FetchOptions.Builder.withLimit(10));
			req.setAttribute("user", null);
			req.setAttribute("tweets", tweets);
		}
		
		resp.setContentType("text/html");
		req.getRequestDispatcher("friends.jsp").forward(req, resp);
	}

}
