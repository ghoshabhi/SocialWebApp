<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<meta charset="UTF-8" />
	<title>Home</title>
	<link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
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
	<script src="js/init.js"></script>
</head>
<body>
	<!-- Partial Header Template Start -->
	<jsp:include page="partials/header.jsp"></jsp:include>
	<!-- Partial Header Template End -->
	
	<div class="container">
		<% if (session.getAttribute("fb_id") != null) { %>
			<p class="">Welcome, ${user.properties.name} !</p>
			<div class="col-md-5">
				<% if (request.getAttribute("tweets_by_user") != null) { %>
					<c:forEach items="${tweets_by_user}" var="tweet">
						<div class="card" style="margin-bottom:2px; width:20rem">
						  <div class="card-block">
						    <div class="row">
						  		<div class="col-md-9 col-sm-5 col-xs-2">
						  			<p class="card-text">${tweet.properties.message}</p>
						  		</div>
						  		<div class="col-md-3 col-sm-7 col-xs-2">
						  			<div class="viewCounter">${tweet.properties.view_counter}</div>
						  		</div>
						  	</div>
						    <hr>
						    <a
							    onclick="fbShare(this)"
						    	style="text-decoration: none;
						    	id="share"
						    	href="#" data-url="/tweet?id=${tweet.properties.tweet_id}"
						    >
						    	<i class="fa fa-facebook" aria-hidden="true"></i>
						    </a> |
						    <a style="text-decoration:none;" class="delete" href="/delete?id=${tweet.properties.tweet_id}">
						    	Delete <i class="fa fa-trash-o" aria-hidden="true"></i>
						    </a>
						  </div>
						</div>
					</c:forEach>
				<% } %>
			</div>
		<% } else { %>
			<p>Please login to continue</p>
		<% } %>
		<div style="margin:10px;">
			<span class="badge badge-success logoutMsg" style="width: 100%;display:none;"></span>
			<span class="badge badge-danger logoutErrorMsg" style="width: 100%;display:none;"></span>
		</div>
		
		<!-- FB OAuth Results -->
		<div id="fbResult" style="margin:10px"></div>
		<!-- FB OAuth Results End -->
		
		<!-- Dependencies -->
		<script
		  src="https://code.jquery.com/jquery-3.2.1.min.js"
		  integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
		  crossorigin="anonymous"></script>
		<!-- Custom JS Start -->
		<script src="js/fb_auth.js"></script>
		<script src="js/fb_actions.js"></script>
		<!-- Custom JS End -->
		<script src="https://use.fontawesome.com/c3761a5d7c.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
		<!-- Dependencies End -->
	</div>
</body>
</html>
