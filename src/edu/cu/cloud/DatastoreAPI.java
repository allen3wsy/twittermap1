package edu.cu.cloud;

import java.util.ArrayList;
import java.util.Date;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;

public class DatastoreAPI {

	public static void addRecord(String word, double lat, double lon)	{
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Entity employee = new Entity("Tweet");

		employee.setProperty("word", word);
		employee.setProperty("Latitude", lat);
		employee.setProperty("Longitude", lon);

		Date tweetDate = new Date();
		employee.setProperty("tweetDate", tweetDate);

		Key k = datastore.put(employee);
		
	}
	
	public static ArrayList<Coordinate> getLocationList(String word)	{
		ArrayList<Coordinate> result = new ArrayList<Coordinate>();
		
		return result;
	}
}
