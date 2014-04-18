package edu.cu.cloud;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.*;


@SuppressWarnings("serial")

public class TwitterMapServlet extends HttpServlet {
	
	private static final Logger log = Logger.getLogger(TwitterMapServlet.class.getName());

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		log.warning("test");
		try {
			req.getRequestDispatcher("index2.jsp").forward(req, resp);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
