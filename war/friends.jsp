<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.google.appengine.labs.repackaged.org.json.JSONArray" %>
<%@ page import="com.google.appengine.labs.repackaged.org.json.JSONObject" %>
<%@ page import="com.google.appengine.labs.repackaged.org.json.JSONException" %>
<%@ page import="java.util.Iterator" %>
<html>
<head>
	<meta charset="UTF-8" />
	<title>Friends Tweets Page</title>
	<link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
	<script src="https://use.fontawesome.com/c3761a5d7c.js"></script>
	<style>
		* {
			box-sizing: border-box;
			font-size: 14pt;
			font-family: 'Source Sans Pro', sans-serif;
		}
		.viewCounter {
			width: 30px;
			height: 30px;
			background: cornflowerblue;
			color: white;
			-moz-border-radius: 15px;
			-webkit-border-radius: 15px;
			border-radius: 15px;
		  	display: flex;
		  	align-items: center;
		  	justify-content: center;
		}
		
		.container {
			margin: 5px;
		}
	</style>
	<script type="text/javascript" src="js/init.js"></script>
</head>
<body>
	<jsp:include page="partials/header.jsp"></jsp:include>
	
	<div class="container">
		<h2>Friends Tweets Page</h2>
			<% 
				JSONObject friends_tweets = (JSONObject)request.getAttribute("friends_tweets");
			%>
			<%	Iterator<String> keys = friends_tweets.keys();
				while(keys.hasNext()){
					String key = keys.next(); 
			%>
				<h4>Tweets By: <%= key %></h4>
				  			
			<%
				try {
					JSONArray arr = friends_tweets.getJSONArray(key);
					if (arr.length() == 0) {
			%>
				<p> Either this person is logged in or doesn't have any tweets! :)</p>				
						
			<%	}
				//System.out.println("72: " + arr.toString());
				for(int i=0; i < arr.length(); i++) {
					JSONObject obj = arr.getJSONObject(i);
					String msg = (String)obj.get("tweet_message");
					long id = (Long)obj.get("tweet_id");
					long counter = (Long) obj.get("views_counter");
					//String posted_by = (String) obj.get("user_name");
					//String created_at = (String) obj.get("created_at");
			%>
				<div class="card" style="margin-bottom:2px; width:20rem">
					<div class="card-block">
						<div class="row">
							<div class="col-md-9 col-sm-5 col-xs-2">
							<p class="card-text"><%= msg %></p>
							</div>
					  		<div class="col-md-3 col-sm-7 col-xs-2">
					  			<div class="viewCounter"><%= counter %></div>
					  		</div>
					  	</div>
					    <hr>
					    <a
						    onclick="fbShare(this)"
					    	style="text-decoration: none;
					    	id="share"
					    	href="#" data-url="/tweet?id=<%= id %>"
					    >
					    	<i class="fa fa-facebook" aria-hidden="true"></i>
					    </a>
					  </div>
					</div>
				<%	}
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			%>
	</div>
	
	<!-- Dependencies -->
	<script
	  src="https://code.jquery.com/jquery-3.2.1.min.js"
	  integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
	  crossorigin="anonymous">
	</script>
	<script type="text/javascript" src="js/fb_auth.js"></script>
	  <script type="text/javascript" src="js/fb_actions.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
	<!-- Dependencies End -->
</body>
</html>