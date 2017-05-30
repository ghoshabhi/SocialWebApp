# Social Webapp 
Live App: https://fb-login-166722.appspot.com (Maxed out on project IDs)

Facebook App: https://apps.facebook.com/1828138897506637

## Description 
This project is a Twitter like interface where you can write a tweet and interact with it my sharing it to your Facebook timeline or sending it to a friend. This app uses Facebook's JavaScript SDK for authentication. The app follows a strict MVC framework guideline

## Technologies Used
Front-End: JSP, JSTL, HTML, CSS
JavaScript: Facebook JavaScript SDK, jQuery, Vanilla JS
Backend: Servlets
Database: Google App Engine's Datastore

## Folder Structure

1. `src` houses all the Java code for Servlets. I have kept in mind __separation of concern__ and have put logic for each page into a separate controller file.

2. `war` has all the project dependencies for the **View** portion of the MVC; i.e. the JSP files.

3. I have extracted all the JavaScript code and put it into `/war/js` and subsequent files like `init.js` for initializing Facebook's SDK, `fb_auth.js` for authentication code and `fb_actions.js` has functions for each action performed with Facebook.

## Developer

This project is developed by me, Abhishek Ghosh and reserve the rights to the redistribution and usage of any and all code in this repository.
