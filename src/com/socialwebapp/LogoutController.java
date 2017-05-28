package com.socialwebapp;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;

@SuppressWarnings("serial")
public class LogoutController extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		//long fb_id = Long.valueOf((String) req.getParameter("fb_id"));
		JSONObject obj = new JSONObject();
		PrintWriter out = resp.getWriter();
		
		if(req.getSession().getAttribute("fb_id") != null) {
			req.getSession().invalidate();
			try {
				obj.put("success", "True");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			out.write(obj.toString());
			out.close();
		} else {
			try {
				obj.put("success", "False");
				out.write(obj.toString());
				out.close();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}
