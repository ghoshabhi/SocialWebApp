<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<meta charset="UTF-8" />
	<title>Delete Tweet</title>
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
		<c:if test="${not empty tweet_to_delete && owner}">
			<h2>Delete Tweet ? </h2>
			<p>Are you sure you want to delete the tweet: "<a href="/tweet?id=${tweet_to_delete.properties.tweet_id}">${tweet_to_delete.properties.message}</a>" ?</p>
			<form method="post">
				<a href="/new_tweet" class="btn btn-warning">Go Back</a>
				<input type="submit" value="Confirm" class="btn btn-danger"/>
			</form>
		</c:if>
		
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