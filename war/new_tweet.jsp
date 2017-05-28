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
		<h3>New Tweet</h3>
		
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
	
	<script>
		function tweetLength(e) {
			const tweetMessage = e.target.value;
			
			if(tweetMessage.length >= 120) {
				alert("Stop it!")
			}
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
		    	      	  $('.success-message').append("<strong>Your message was successfully posted! \
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
			
			$.ajax({
				type: 'POST',
				url: '/new_tweet',
				dataType: 'json',
				data: { 
					action: 'respond',
					tweetMessage: message
				},
				success: function(data) {
					window.location = data.url;
				},
				 error: function(err) {
					console.log(err);
				}
			 });
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