<html>
<head>
	<meta charset="UTF-8" />
	<title>Facebook Login</title>
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
	<!-- Partial Header Template Start -->
	<jsp:include page="partials/header.jsp"></jsp:include>
	<!-- Partial Header Template End -->
	
	<div class="container">
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
		
		<div style="display:flex;flex-direction:row">
			<!-- FB Button -->
			<div class="fb-login-button"
				 style="margin:10px"
				 id="fbLoginBtn"
				 data-max-rows="1"
				 data-size="large"
				 data-button-type="login_with"
				 data-show-faces="false"
				 data-auto-logout-link="false"
				 data-use-continue-as="true"
				 scope="public_profile,email,user_birthday,user_posts,publish_actions"
				 onlogin="checkLoginState();"
			></div>
			<!-- FB Button End -->
			
			<!-- FB Logout Button -->
			<button class="btn btn-danger fbLogout" style="cursor:pointer" type="button" onClick="fbLogout();">
				<i class="fa fa-power-off" aria-hidden="true"></i>Logout
			</button>
			<!-- FB Logout Button End -->
		</div>
		<div style="margin:10px;">
			<span class="badge badge-success logoutMsg" style="display:none;"></span>
			<span class="badge badge-danger logoutErrorMsg" style="display:none;"></span>
		</div>
		
		<!-- FB OAuth Results -->
		<div id="fbResult" style="margin:10px"></div>
		<!-- FB OAuth Results End -->
		
		<!-- FB Post To Wall -->
		<div style="margin:10px">
			<input type="text" id="message"  name="message" />
			<button class="btn btn-info" id='postToWall'>Post To Wall</button>
			<div style="display:none;margin:10px;" class="alert alert-success success-message" role="alert"></div>
			<div style="display:none;margin:10px;" id="error-message" class="alert alert-danger" role="alert"></div>
		</div>
		<!-- FB Post To Wall End -->
		
		<!-- FB Send PM -->
		<div style="margin:10px">
			<button class="btn btn-info" id="pm">
				Send Personal Message
			</button>
		</div>
		<!-- FB Send PM End-->
		
		<!-- Custom JS -->
		<script>
			function checkLoginState() {
				FB.getLoginStatus(function(response) {
					console.log(response);
					fetchInfo(response);		
				});
			}
			
			function fbLogout() {
				FB.getLoginStatus(function(response) {
					console.log(response.status);
					if (response.status === 'connected') {
						var accessToken = response.authResponse.accessToken;
						console.log(accessToken);
						FB.logout(function(response) {
							console.log(response);
							if(response.status === 'unknown') {
								console.log(1);
								$('.logoutMsg').html("");
								$('#fbResult').html("");
								$('.logoutErrorMsg').css("display","none");
								$('.logoutMsg').css("display","block");
								$('.logoutMsg').html("You have been logged out of the app. Login again to continue. Reloading...");
								setInterval(function() {
									location.reload();
								}, 3000);
							}
						});
					} else {
						$('.logoutErrorMsg').html("");
						$('.logoutErrorMsg').css("display","block");
						$('.logoutMsg').css("display","none");
						$('.logoutErrorMsg').html("You are not logged into the app!");
					} 
				});
			}
			
			function fetchInfo(response) {
				//console.log(response.authResponse.accessToken);
				if(response.status === 'connected') {
					console.log('You are connected! Fetching your information 📡 📡');
					const pems = 'name, first_name, last_name, email, cover, birthday, age_range, gender, picture';
					FB.api('/me', {fields: pems }, function(data) {
						$('.logoutErrorMsg').html("");
						$('.logoutErrorMsg').css("display",'none');
						$('.logoutMsg').css('display', 'block');
						$('.logoutMsg').html("Welcome to the app :)");
						$('#fbResult').html("");
						$('#fbResult').append("<img class='rounded' style='height:100px;width:100px' src='" + data.picture.data.url + "' />");
					  	$('#fbResult').append("<div>Name: "+ data.name + "</div>");
					  	$('#fbResult').append("<div>Email: " + data.email + "</div>");
					  	var birthYear = data.birthday ? parseInt(data.birthday.split("/")[2]): 0;
					  	var age = (birthYear != 0) ? new Date().getFullYear() - birthYear + " years" : 'Birth date not found';
					  	console.log(age);
					  	$('#fbResult').append("<div>Age: " + age + "</div>");
					  	
					  	// SCRIPT FOR REST FOR THE PROJECT. THIS SENDS DATA TO THE SERVLET.
					  	$.ajax({
							type: 'POST',
							url: '/dashboard',
							dataType: 'json',
							data: { 
								action: 'respond',
								access_token: response.authResponse.accessToken,
								response: JSON.stringify(data)
							},
							success: function(data){
								console.log("1"); 
								console.log(data);
							 },
							 error: function(err) {
								console.log(err);
							}
						 });
					});
					// save access token
					if(typeof(Storage) !== 'undefined') {
						localStorage.setItem('access_token', response.authResponse.accessToken);
					} else {
						console.log('storage not supported');
					}
				} else if(response.status === 'unknown') {
					console.log('unknown_user_or_logged_out_user');
					FB.login(function(response) {
					    if (response.authResponse) {
					     console.log('Welcome!  Fetching your information.... ');
					     const pems = 'name, first_name, last_name, email, cover, birthday, age_range, gender, picture';
					     FB.api('/me', {fields:pems}, function(response) {
					    	$('.logoutErrorMsg').html("");
					    	$('.logoutErrorMsg').css("display",'none');
					    	$('.logoutMsg').css('display', 'block');
							$('.logoutMsg').html("Welcome to the app :)");
							$('#fbResult').html("");
					    	$('#fbResult').append("<img class='rounded' style='height:100px;width:100px' src='" + data.picture.data.url + "' />");
					    	$('#fbResult').append("<div>Name: "+ data.name + "</div>");
						  	$('#fbResult').append("<div>Name: "+ data.name + "</div>");
						  	$('#fbResult').append("<div>Email: " + data.email + "</div>");
						  	var birthYear = data.birthday ? parseInt(data.birthday.split("/")[2]): 0;
						  	var age = (birthYear != 0) ? new Date().getFullYear() - birthYear + " years" : 'Birth date not found';
						  	console.log(age);
						  	$('#fbResult').append("<div>Age: " + age + "</div>");
					     });
					    } else {
					     console.log('User cancelled login or did not fully authorize.');
					    }
					});
				} else {
					console.log("not_authorized");
					FB.login(function(response) {
					    if (response.authResponse) {
					     console.log('Welcome!  Fetching your information.... ');
					     const pems = 'name, first_name, last_name, email, cover, birthday, age_range, gender, picture';
					     FB.api('/me', {fields:pems}, function(response) {
					    	 $('.logoutErrorMsg').html("");
					    	 $('.logoutErrorMsg').css("display",'none');
					    	 $('.logoutMsg').css('display', 'block');
							 $('.logoutMsg').html("Welcome to the app :)");
							 $('#fbResult').html("");
							 $('#fbResult').append("<img class='rounded' style='height:100px;width:100px' src='" + data.picture.data.url + "' />");
						  	 $('#fbResult').append("<div>Name: "+ data.name + "</div>");
						  	 $('#fbResult').append("<div>Email: " + data.email + "</div>");
						  	 var birthYear = data.birthday ? parseInt(data.birthday.split("/")[2]): 0;
						  	 var age = (birthYear != 0) ? new Date().getFullYear() - birthYear + " years" : 'Birth date not found';
						  	 console.log(age);
						  	 $('#fbResult').append("<div>Age: " + age + "</div>");
					     });
					    } else {
					     console.log('User cancelled login or did not fully authorize.');
					    }
					});
				}
			}
			
			function postToWall() {
				// const message = "Message from outside";
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
				    	      $('#error-message').append("<strong>There was some problem posting the message to your wall!</strong>");
			    	      }
			    	    }
			    	);
				});
			}
			
			function sendPm() {
				FB.ui({
				  method: 'send',
				  link: 'http://www.nytimes.com/interactive/2015/04/15/travel/europe-favorite-streets.html',
				});
			}
			
			window.onload = function() {
				console.log('onLoad');
				var button = document.getElementById("postToWall");
				var pmBtn = document.getElementById("pm");
				
				pmBtn.addEventListener("click", sendPm);
				button.addEventListener("click",postToWall);
				/* 
				FB.getLoginStatus(function(response) {
					console.log(response);
					if(response.status === 'connected') {
						$(".fbLogout").css("display","block");
					}		
				}); */
			}
		</script>
		<!-- Custom JS End -->
		
		<!-- Dependencies -->
		<script
		  src="https://code.jquery.com/jquery-3.2.1.min.js"
		  integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
		  crossorigin="anonymous"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
		<!-- Dependencies End -->
		
		<!-- <script>
			$(document).load(function(){
				alert(1);
				/* 
				}); */
			});
		</script> -->
	</div>
</body>
</html>
