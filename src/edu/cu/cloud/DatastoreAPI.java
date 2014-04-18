package edu.cu.cloud;

import java.text.DateFormat;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.logging.Logger;

import com.google.appengine.api.datastore.*;
import com.google.appengine.api.datastore.Query.*;

public class DatastoreAPI {

	private static final Logger log = Logger.getLogger(DatastoreAPI.class.getName());

	public static void addRecord(Hashtable<String, ArrayList<String>> tweetList) {
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		List<Entity> employees = new ArrayList<Entity>();
		for (String word : tweetList.keySet()) {

			ArrayList<String> coordinate = tweetList.get(word);

			Entity employee = new Entity("Tweet");

			employee.setProperty("word", word);
			employee.setUnindexedProperty("List", coordinate);

			Date tweetDate = new Date();
			employee.setUnindexedProperty("tweetDate", tweetDate);

			employees.add(employee);
		}
		datastore.put(employees);

	}

	public static Hashtable<String, ArrayList<Coordinate>> getLocationList(
			String word) {
		Hashtable<String, ArrayList<Coordinate>> result = new Hashtable<String, ArrayList<Coordinate>>();

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();

		// filter first..
		Filter wordFilter = new FilterPredicate("word", FilterOperator.EQUAL,
				word);

		Query query = new Query("Tweet").setFilter(wordFilter);

		List<Entity> tweets = datastore.prepare(query).asList(
				FetchOptions.Builder.withLimit(100000));

		// get the location out of all the tweets
		for (int i = 0; i < tweets.size(); i++) {
			List<String> coordinateList = (List<String>) tweets.get(i)
					.getProperty("List");
			Date date = (Date) tweets.get(i).getProperty("tweetDate");
			Format formatter = new SimpleDateFormat("yyyy-MM-dd");
			String dateString = formatter.format(date);

			for (String s : coordinateList) {
				String[] coor = s.split("\t");
				double lat = Double.parseDouble(coor[0]);
				double lon = Double.parseDouble(coor[1]);
				Coordinate c = new Coordinate(lat, lon);
				
				if (result.containsKey(dateString)) {
					ArrayList<Coordinate> temp  = result.get(dateString);
					temp.add(c);
					result.put(dateString, temp);
				} else {
//					log.warning(dateString);
					ArrayList<Coordinate> temp  = new ArrayList<Coordinate>();
					temp.add(c);
					result.put(dateString, temp);
				}
			}
		}

		return result;
	}
}