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
      var userID = response.authResponse.userID;
      console.log(accessToken, userID + " L111: index.jsp");
      FB.logout(function(response) {
        console.log(response);
        if (response.status === 'unknown') {

          $.ajax({
            method: 'post',
            url: '/logout',
            dataType: 'json',
            data: {
              fb_id: userID
            },
            success: function(resp) {
              console.log("123: " + resp)
              if (resp.success != "") {
                console.log("There was error clearing session on servlet");
              }
              console.log("Logout successfull!");
              $('.logoutMsg').html("");
              $('#fbResult').html("");
              $('.logoutErrorMsg').css("display", "none");
              $('.logoutMsg').css("display", "block");
              $('.logoutMsg').html("You have been logged out of the app. Login again to continue. Reloading...");
              setInterval(function() {
                location.reload();
              }, 1000);
            },
            error: function(err) {
              console.log("Oops something went wrong! Error: " + err);
              $('.logoutErrorMsg').html("");
              $('.logoutErrorMsg').css("display", "block");
              $('.logoutMsg').css("display", "none");
              $('.logoutErrorMsg').html("You are not logged into the app!");
            }
          });
        }
      });
    } else {
      $('.logoutErrorMsg').html("");
      $('.logoutErrorMsg').css("display", "block");
      $('.logoutMsg').css("display", "none");
      $('.logoutErrorMsg').html("You are not logged into the app!");
    }
  });
}

function fetchInfo(response) {
  //console.log(response.authResponse.accessToken);
  if (response.status === 'connected') {
    console.log('You are connected! Fetching your information 📡 📡');
    const pems = 'name, first_name, last_name, email, cover, birthday, age_range, gender, picture';
    FB.api('/me', {
      fields: pems
    }, function(data) {
      $('.logoutErrorMsg').html("");
      $('.logoutErrorMsg').css("display", 'none');
      $('.logoutMsg').css('display', 'block');
      $('.logoutMsg').html("Welcome to the app :)");
      $('#fbResult').html("");
      $('#fbResult').append("<img class='rounded' style='height:100px;width:100px' src='" + data.picture.data.url + "' />");
      $('#fbResult').append("<div>Name: " + data.name + "</div>");
      $('#fbResult').append("<div>Email: " + data.email + "</div>");
      var birthYear = data.birthday ? parseInt(data.birthday.split("/")[2]) : 0;
      var age = (birthYear != 0) ? new Date().getFullYear() - birthYear + " years" : 'Birth date not found';
      console.log(age);
      $('#fbResult').append("<div>Age: " + age + "</div>");

      // SCRIPT FOR REST FOR THE PROJECT. THIS SENDS DATA TO THE SERVLET.
      $.ajax({
        type: 'POST',
        url: '/home',
        dataType: 'json',
        data: {
          action: 'login',
          access_token: response.authResponse.accessToken,
          userID: response.authResponse.userID,
          name: data.name,
          email: data.email
        },
        success: function(data) {
          console.log("166");
          console.log(data);
        },
        error: function(err) {
          console.log(err);
        }
      });
    });
    // save access token
    if (typeof(Storage) !== 'undefined') {
      localStorage.setItem('access_token', response.authResponse.accessToken);
    } else {
      console.log('storage not supported');
    }
  } else if (response.status === 'unknown') {
    console.log('unknown_user_or_logged_out_user');
    FB.login(function(response) {
      if (response.authResponse) {
        console.log('Welcome!  Fetching your information.... ');
        const pems = 'publish_actions, name, first_name, last_name, email, cover, birthday, age_range, gender, picture';
        FB.api('/me', {
          fields: pems
        }, function(data) {
          $('.logoutErrorMsg').html("");
          $('.logoutErrorMsg').css("display", 'none');
          $('.logoutMsg').css('display', 'block');
          $('.logoutMsg').html("Welcome to the app :)");
          $('#fbResult').html("");
          $('#fbResult').append("<img class='rounded' style='height:100px;width:100px' src='" + data.picture.data.url + "' />");
          $('#fbResult').append("<div>Name: " + data.name + "</div>");
          $('#fbResult').append("<div>Name: " + data.name + "</div>");
          $('#fbResult').append("<div>Email: " + data.email + "</div>");
          var birthYear = data.birthday ? parseInt(data.birthday.split("/")[2]) : 0;
          var age = (birthYear != 0) ? new Date().getFullYear() - birthYear + " years" : 'Birth date not found';
          console.log(age);
          $('#fbResult').append("<div>Age: " + age + "</div>");

          // SCRIPT FOR REST FOR THE PROJECT. THIS SENDS DATA TO THE SERVLET.
          $.ajax({
            type: 'POST',
            url: '/home',
            dataType: 'json',
            data: {
              action: 'login',
              access_token: response.authResponse.accessToken,
              userID: response.authResponse.userID,
              name: data.name,
              email: data.email
            },
            success: function(data) {
              console.log("214");
              console.log(data);
            },
            error: function(err) {
              console.log(err);
            }
          });
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
        const pems = 'publish_actions, name, first_name, last_name, email, cover, birthday, age_range, gender, picture';
        FB.api('/me', {
          fields: pems
        }, function(data) {
          $('.logoutErrorMsg').html("");
          $('.logoutErrorMsg').css("display", 'none');
          $('.logoutMsg').css('display', 'block');
          $('.logoutMsg').html("Welcome to the app :)");
          $('#fbResult').html("");
          $('#fbResult').append("<img class='rounded' style='height:100px;width:100px' src='" + data.picture.data.url + "' />");
          $('#fbResult').append("<div>Name: " + data.name + "</div>");
          $('#fbResult').append("<div>Email: " + data.email + "</div>");
          var birthYear = data.birthday ? parseInt(data.birthday.split("/")[2]) : 0;
          var age = (birthYear != 0) ? new Date().getFullYear() - birthYear + " years" : 'Birth date not found';
          console.log(age);
          $('#fbResult').append("<div>Age: " + age + "</div>");

          $.ajax({
            type: 'POST',
            url: '/home',
            dataType: 'json',
            data: {
              action: 'login',
              access_token: response.authResponse.accessToken,
              userID: response.authResponse.userID,
              name: data.name,
              email: data.email
            },
            success: function(data) {
              console.log("258");
              console.log(data);
            },
            error: function(err) {
              console.log(err);
            }
          });
        });
      } else {
        console.log('User cancelled login or did not fully authorize.');
      }
    });
  }
}
