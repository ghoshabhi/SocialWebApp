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
		
		.container {
			margin: 5px;
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
		
		@media only screen and (max-width: 500px) {
		    .container {
		    	flex-direction: column;
		    }
		}
	</style>
	<script
	  src="https://code.jquery.com/jquery-3.2.1.min.js"
	  integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
	  crossorigin="anonymous">
	</script>
	<script src="js/init.js"></script>
</head>
<body>
	<jsp:include page="partials/header.jsp"></jsp:include>
	
	<div class="container" style="display:flex; padding: 5px">
		<div class="col-md-5">
			<h3>New Tweet! </h3>
			<!-- FB Post To Wall -->
			<div style="margin:10px">
				<input
					class="col-sm-8"
					type="text"
					id="message"
					name="message"
					placeholder="Enter Your Tweet"
					style="padding:3px;"
				/>
				<br/>
				<span style="font-size:small; font-style:italic">(Max 120 characters)</span>
				<div style="display:flex;flex-direction:row; margin:10px">
					<button class="btn btn-info" style="margin:10px" id='postToWall' onclick="postToWall()">Post to FB</button>
					
					<button class="btn btn-info" style="margin:10px" id='saveToDB' onclick="saveToDB()">Save</button>	
				</div>
				
				<!-- FB Send PM -->
				<div style="margin:10px">
					<button class="btn btn-info" id="pm">
						Send Personal Message
					</button>
				</div>
				<!-- FB Send PM End -->
				
				<div style="display:none;margin:10px;" class="alert alert-success success-message" role="alert"></div>
				<div style="display:none;margin:10px;" id="error-message" class="alert alert-danger" role="alert"></div>
			</div>
			<!-- FB Post To Wall End -->
		</div>
		<div class="col-md-7">
			<h3>Tweets posted by you :) </h3>
			<c:choose>
			    <c:when test="${not empty user}">
			    	<c:if test="${not empty tweets}">
			    		<c:forEach items="${tweets}" var="tweet">
						    <div class="card" style="margin-bottom:2px; width:20rem">
							  <div class="card-block">
							  	<div class="row">
							  		<div class="col-sm-9">
							  			<p class="card-text">${tweet.properties.message}</p>
							  		</div>
							  		<div class="col-sm-3">
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
							    <a style="text-decoration:none" href="/tweet?id=${tweet.properties.tweet_id}">
							    	View <i class="fa fa-arrow-circle-right" aria-hidden="true"></i> 
							    </a> |
							    <a style="text-decoration:none;" class="delete" href="/delete?id=${tweet.properties.tweet_id}">
							    	Delete <i class="fa fa-trash-o" aria-hidden="true"></i>
							    </a>
							  </div>
							</div>
						</c:forEach>
			    	</c:if>
			    </c:when>
			    <c:otherwise>
			        <p>Either your session timed out or you're not logged in. Please return to <a href="/home">home page</a> and login again!</p>
			    </c:otherwise>
			</c:choose>
		</div>
	</div>
	
	<script>
	
		/* function sendPm() {
			FB.ui({
			  method: 'send',
			  link: 'http://www.nytimes.com/interactive/2015/04/15/travel/europe-favorite-streets.html',
			});
		} */
	</script>
	
	<!-- Dependencies -->
	<script src="js/fb_auth.js" ></script>
	<script src="js/fb_actions.js" ></script>
	  
	<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
	<!-- Dependencies End -->
</body>
</html>