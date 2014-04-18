package edu.cu.cloud;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DownloadTweetServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger log = Logger.getLogger(DownloadTweetServlet.class.getName());

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		URL url;
		HttpURLConnection conn;
		BufferedReader rd = null;
		
		log.warning("int the doget");
		try {
			url = new URL("http://allen-ryan.elasticbeanstalk.com");
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setConnectTimeout(60000);
			rd = new BufferedReader(
					new InputStreamReader(conn.getInputStream()));

			log.warning("get the bufferedreader");
		} catch (IOException e) {
			log.warning("1. "+e.toString());
		} catch (Exception e) {
			log.warning("2. "+e.toString());
		}
		StringBuilder sb = new StringBuilder();

		Hashtable<String,ArrayList<String>> tweetList = new Hashtable<String,ArrayList<String>>();
		try {
			String read = rd.readLine();

			
			while (read != null) {
				if (read.startsWith(">")) {
					String word = read.substring(1);

					read = rd.readLine();
					ArrayList<String> coordinateList = new ArrayList<String>();
					while (read != null && !read.startsWith(">")) {
						String coor[] = read.split("\t");
						double lat = Double.parseDouble(coor[0]);
						double lon = Double.parseDouble(coor[1]);
						
						Coordinate coordinate = new Coordinate(lat,lon);
						coordinateList.add(""+lat+"\t"+lon);
						
						sb.append(word + ":\t[" + lat + ", " + lon + "]\n");
						// write into datastore
						read = rd.readLine();
					}
					tweetList.put(word,coordinateList);
				}

			}
			DatastoreAPI.addRecord(tweetList);
			String content = sb.toString();
			log.warning(content);
			log.warning("before send mail");
//			SendEmail.send(content);
			
			
			log.warning("after send mail");
			// do something useful
		}catch(Exception e){
			log.warning("3. "+e.toString());
		}finally{
			log.warning("in finally");
			rd.close();
		}
		resp.setStatus(200);
		resp.getWriter().write("success");
	}

}
