package edu.cu.cloud;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SearchServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			{
		
		String word =(String) req.getParameter("word");
		if(word!=null){
			word = word.toLowerCase();
			PorterStemmer ps = new PorterStemmer();
			String stemmedWord = ps.stem(word);
			Hashtable<String,ArrayList<Coordinate>> coordinateList = DatastoreAPI.getLocationList(stemmedWord);
			req.setAttribute("coordinateList", coordinateList);
		}
		
		try {
			req.getRequestDispatcher("index2.jsp").forward(req, resp);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		resp.setStatus(200);
	}
}
