<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<meta charset="UTF-8" />
	<title>New Tweet</title>
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
</head>
<body>
	<!-- Init FB JS SDK -->
	<script>
	  window.fbAsyncInit = function() {
	    FB.init({
	      appId      : '1828138897506637',
	      cookie     : true,
	      xfbml      : true,
	      version    : 'v2.8'
	    });
	    FB.AppEvents.logPageView();   
	  };
	
	  (function(d, s, id){
	     var js, fjs = d.getElementsByTagName(s)[0];
	     if (d.getElementById(id)) {return;}
	     js = d.createElement(s); js.id = id;
	     js.src = "//connect.facebook.net/en_US/sdk.js";
	     fjs.parentNode.insertBefore(js, fjs);
	   }(document, 'script', 'facebook-jssdk'));
	</script>
	<!-- Init end -->
	
	<jsp:include page="partials/header.jsp"></jsp:include>
	
	<div class="container">
		<h2>Show Single Tweet</h2>
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
		    <c:choose>
			    <c:when test="${not empty user_id}">
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
				</c:when>
				<c:otherwise>
					<p>Thank you for viewing this tweet!</p>
				</c:otherwise>
			</c:choose>
		  </div>
		</div>
	</div>
	
	<!-- Dependencies -->
	<script
	  src="https://code.jquery.com/jquery-3.2.1.min.js"
	  integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
	  crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
	<!-- Dependencies End -->
</body>
</html>