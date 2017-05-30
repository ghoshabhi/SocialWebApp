<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-toggleable-md navbar-light bg-faded">
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo01" aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarTogglerDemo01">
    <a class="navbar-brand" href="/home">Social Network</a>
    <ul id="myNavBar" class="navbar-nav mr-auto mt-2 mt-lg-0">
      <li class="nav-item active">
        <a class="nav-link" href="/home">Home</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="/new_tweet">New Tweet</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="/friends">Friends</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="/top_tweets">Top Tweets</a>
      </li>
      <li style="float:right">
      	<c:choose>
      		<c:when test="${empty user}">
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
			</c:when>
			<c:when test="${not empty user}">
				<!-- FB Logout Button -->
				<button class="btn btn-danger fbLogout" style="cursor:pointer" type="button" onClick="fbLogout();">
					<i class="fa fa-power-off" aria-hidden="true"></i>Logout
				</button>
				<!-- FB Logout Button End -->
			</c:when>
			<c:otherwise>
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
			</c:otherwise>
		</c:choose>	
      </li>
    </ul>
  </div>
</nav>