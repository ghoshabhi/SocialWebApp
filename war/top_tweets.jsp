<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<meta charset="UTF-8" />
	<title>Top Tweets</title>
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
			width: 100%;
		}
	</style>
	<script type="text/javascript" src="js/init.js"></script>
</head>
<body>
	<jsp:include page="partials/header.jsp"></jsp:include>
	
	<div class="container">
		<h2>Top Tweets Page</h2>
		<div style="display:flex; flex-flow:row wrap; jusitfy-content:space-between">
			<c:forEach items="${top_tweets}" var="tweet">			
			    <div class="card" style="margin-bottom:5px; width:20rem">
				  <div class="card-block">
				  	<div class="row">
				  		<div class="col-sm-9">
				  			<p class="card-text">${tweet.properties.message}</p>
				  		</div>
				  		<div class="col-sm-3">
				  			<div class="viewCounter">${tweet.properties.view_counter}</div>
				  		</div>
				  	</div>
				  	<br>
				  	<div class="card-footer text-muted">
				    	<a
					    	onclick="fbShare(this)"
					    	style="text-decoration: none;
					    	id="share"
					    	href="#" data-url="/tweet?id=${tweet.properties.tweet_id}"
					    >
					    	<i class="fa fa-facebook" aria-hidden="true"></i>
					    </a> |
					    <a style="text-decoration:none" href="/tweet?id=${tweet.properties.tweet_id}">
					    	View <i class="fa fa-arrow-circle-right" aria-hidden="true"></i> 
					    </a>
				  	</div>
				  	<%-- <hr>
				     --%>
				  </div>
				</div>
			</c:forEach>
		</div>
	</div>
	
	<!-- Dependencies -->
	<script
	  src="https://code.jquery.com/jquery-3.2.1.min.js"
	  integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
	  crossorigin="anonymous"></script>
	  <script src="js/fb_auth.js"></script>
	  <script src="js/fb_actions.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
	<!-- Dependencies End -->
</body>
</html>