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
					onInput="tweetLength(event)"
				/>
				<br/>
				<span style="font-size:small; font-style:italic">(Max 120 characters)</span>
				<div style="display:flex;flex-direction:row; margin:10px">
					<button class="btn btn-info" style="margin:10px" id='postToWall' onclick="postToWall()">Post to FB</button>
					
					<button class="btn btn-info" style="margin:10px" id='saveToDB' onclick="saveToDB()">Save</button>	
				</div>
				
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
		function tweetLength(e) {
			const tweetMessage = e.target.value;
			
			if(tweetMessage.length >= 120) {
				alert("Stop it! Will you ?")
			}
		}	
		
		function fbShare(el) {
			var url = el.getAttribute("data-url");
			const shareUrl = window.location.host + url
			console.log(shareUrl);
			 FB.ui({
			    method: 'share',
			    display: 'popup',
			    href: shareUrl,
			  }, function(response){});
		}
		
		function postToWall() {
			var message = document.getElementById("message").value;
			console.log(message);
			FB.login(function() {
				FB.api(
		    	    "/me/feed",
		    	    "POST",
		    	    {
		    	        "message": message
		    	    },
		    	    function (response) {
		    	      if (!response.error) {
		    	    	  console.log(response);
		    	          $('#message').html("");
		    	          $('#error-message').css('display','none');
		    	          $('.success-message').html("");
		    	          $('.success-message').css('display','block');
		    	      	  $('.success-message').append("<strong>Your tweet was successfully posted! \
		    	      			  Check your <a href='https://www.facebook.com' target='_blank'>Facebook Feed :)</a></strong>");
		    	      }
		    	      else {
		    	    	  console.log(response.error.message);
		    	    	  // $('#message').val("");
		    	    	  $('.success-message').css('display','none');
		    	    	  $('#error-message').html("");
		    	    	  $('#error-message').css('display', 'block');
			    	      $('#error-message').append("<strong>There was some problem posting the message to your wall! Error: " +  response.error.message  +" </strong>");
		    	      }
		    	    }
		    	);
			});
		}
		
		function saveToDB() {
			var message = document.getElementById("message").value;
			
			if(message.length === 0) {
				// $('#message').val("");
  	    	  	$('.success-message').css('display','none');
  	    	 	$('#error-message').html("");
  	    	 	$('#error-message').css('display', 'block');
	    	    $('#error-message').append("<strong>Please enter at least one character!</strong>");
	    	    return;
			}
			
			var userID = null;
			
			FB.getLoginStatus(function(response) {
				if(response.status === 'connected') {
					userID = response.authResponse.userID;
				}
			});
			
			if(userID != null) {
				$.ajax({
					type: 'POST',
					url: '/new_tweet',
					dataType: 'json',
					data: { 
						userID: userID,
						tweetMessage: message
					},
					success: function(data) {
						//window.location = data.url;
						$('#message').html("");
		    	        $('#error-message').css('display','none');
		    	        $('.success-message').html("");
		    	        $('.success-message').css('display','block');
		    	      	$('.success-message').append("<strong>Your tweet was successfully posted! \
		    	      			  Click <a href=' " + data.url + "'>here :)</a> to view it</strong>");
					},
					 error: function(err) {
						console.log(err);
					}
				});	
			} else {
				// login user and then do the save operation
				console.log("user not connected");
				FB.login(function(response) {
					if (response.authResponse) {
						userID = response.authResponse.userID;
						console.log(userID + " is now connected");
						$.ajax({
							type: 'POST',
							url: '/new_tweet',
							dataType: 'json',
							data: { 
								userID: userID,
								tweetMessage: message
							},
							success: function(data) {
								//window.location = data.url;
								$('#message').html("");
				    	        $('#error-message').css('display','none');
				    	        $('.success-message').html("");
				    	        $('.success-message').css('display','block');
				    	      	$('.success-message').append("<strong>Your tweet was successfully posted! \
				    	      			  Click <a href=' " + data.url + "'>here :)</a> to view it</strong>");
							},
							 error: function(err) {
								console.log(err);
							}
						});	
					}
				})
			}
		}
		
		function sendPm() {
			FB.ui({
			  method: 'send',
			  link: 'http://www.nytimes.com/interactive/2015/04/15/travel/europe-favorite-streets.html',
			});
		}
	</script>
	
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