function sendPm() {
  var message = document.getElementById("message").value;

  if (message.length === 0) {
    // $('#message').val("");
    $('.success-message').css('display', 'none');
    $('#error-message').html("");
    $('#error-message').css('display', 'block');
    $('#error-message').append("<strong>Please enter at least one character!</strong>");
    return;
  }

  var userID = null;

  FB.getLoginStatus(function(response) {
    if (response.status === 'connected') {
      userID = response.authResponse.userID;
    }
  });

  if (userID != null) {
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
        sendPmV2(data.url);
//        $('#message').html("");
//        $('#error-message').css('display', 'none');
//        $('.success-message').html("");
//        $('.success-message').css('display', 'block');
//        $('.success-message').append("<strong>Your tweet was successfully posted! \
//			    	      			  Click <a href=' " + data.url + "'>here :)</a> to view it</strong>");
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
            console.log(data.url);
            sendPmV2(data.url);
          },
          error: function(err) {
            console.log(err);
          }
        });
      }
    });
  }
}

function sendPmV2(tweetUrl) {
	const shareURL = window.location.host + tweetUrl;
	console.log("74: ", shareURL);
	FB.ui({
		method: 'send',
		link: shareURL
	});
}

function saveToDB() {
  var message = document.getElementById("message").value;

  if (message.length === 0) {
    // $('#message').val("");
    $('.success-message').css('display', 'none');
    $('#error-message').html("");
    $('#error-message').css('display', 'block');
    $('#error-message').append("<strong>Please enter at least one character!</strong>");
    return;
  }

  var userID = null;

  FB.getLoginStatus(function(response) {
    if (response.status === 'connected') {
      userID = response.authResponse.userID;
    }
  });

  if (userID != null) {
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
        $('#error-message').css('display', 'none');
        $('.success-message').html("");
        $('.success-message').css('display', 'block');
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
            $('#error-message').css('display', 'none');
            $('.success-message').html("");
            $('.success-message').css('display', 'block');
            $('.success-message').append("<strong>Your tweet was successfully posted! \
				    	      			  Click <a href=' " + data.url + "'>here :)</a> to view it</strong>");
          },
          error: function(err) {
            console.log(err);
          }
        });
      }
    });
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
  }, function(response) {});
}


function postToWall() {
  // const message = "Message from outside";
  var message = document.getElementById("message").value;
  console.log(message);
  FB.login(function() {
    FB.api(
      "/me/feed",
      "POST", {
        "message": message
      },
      function(response) {
        if (!response.error) {
          console.log(response);
          $('#message').html("");
          $('#error-message').css('display', 'none');
          $('.success-message').html("");
          $('.success-message').css('display', 'block');
          $('.success-message').append("<strong>Your message was successfully posted! \
			      			  Check your <a href='https://www.facebook.com' target='_blank'>Facebook Feed :)</a></strong>");
        } else {
          console.log(response.error.message);
          // $('#message').val("");
          $('.success-message').css('display', 'none');
          $('#error-message').html("");
          $('#error-message').css('display', 'block');
          $('#error-message').append("<strong>There was some problem posting the message to your wall!</strong>");
        }
      }
    );
  }, {
	  scope: 'publish_actions'
  });
}

document.addEventListener("DOMContentLoaded", function(event) {
  console.log("Ready");
  var button = document.getElementById("postToWall");
  console.log("1:", button);
  var pmBtn = document.getElementById("pm");

  pmBtn.addEventListener("click", sendPm);
  button.addEventListener("click", postToWall);

  var max = 120;
  $('input#message').keyup(function(e) {

    switch (e.keyCode) {
      case 8:
        {
          if (e.keyCode === 8) {
            if (this.value.length < max) {
              this.style.borderColor = "";
            }
          }
        }
      default:
        {
          if (e.which < 0x20) {
            // e.which < 0x20, then it's not a printable character
            // e.which === 0 - Not a character
            return; // Do nothing
          }

          if (this.value.length < max) {
            this.style.borderColor = "";
          }

          if (this.value.length == max) {
            e.preventDefault();
            this.style.borderColor = "red";
          } else if (this.value.length > max) {
            // Maximum exceeded
            this.value = this.value.substring(0, max);
          }
        }
    }
  });
});
