package edu.cu.cloud;

public class Tweet {

	public Coordinate coordinate;
	public String word;
	
	public Tweet(String w, double lat, double lon){
		coordinate = new Coordinate(lat,lon);
		word = w;
	}
}
