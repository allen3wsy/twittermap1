<%@ page import="edu.cu.cloud.DatastoreAPI" %>
<%@ page import="edu.cu.cloud.Coordinate" %>
<%@ page import="edu.cu.cloud.PorterStemmer" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>


<html>
	<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap 101 Template</title>

    <!-- Bootstrap -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>Heatmaps</title>
	<style>
      html, body, #map-canvas {
        height: 800px;   // changed the code here
        margin: 0px;
        padding: 0px
      }
      #panel {
        position: absolute;
        top: 5px;
        left: 50%;
        margin-left: -180px;
        z-index: 5;
        background-color: #fff;
        padding: 5px;
        border: 1px solid #999;
      }
    </style>
	<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=visualization"></script>
	<script>


// Adding 500 Data Points
var map, pointarray, heatmap;

var taxiData = [
<% 
	List<Coordinate> coordinateList = (List<Coordinate>)request.getAttribute("coordinateList");
	
	if(coordinateList!=null && coordinateList.size() != 0){
	
		for ( int i = 1 ; i < coordinateList.size(); i++){
			double lat = coordinateList.get(i).lat;
			double lon = coordinateList.get(i).lon;
			out.println("new google.maps.LatLng("+lat+","+lon+"),");
		}
		
		double lastLat = coordinateList.get(0).lat;
		double lastLon = coordinateList.get(0).lon;
		out.println("new google.maps.LatLng("+lastLat+","+lastLon+")");
	} 
%>
];

function initialize() {
  var mapOptions = {
    zoom: 13,
    center: new google.maps.LatLng(37.774546, -122.433523),
    mapTypeId: google.maps.MapTypeId.SATELLITE
  };

  map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);

  var pointArray = new google.maps.MVCArray(taxiData);

  heatmap = new google.maps.visualization.HeatmapLayer({
    data: pointArray
  });

  heatmap.setMap(map);
}

function toggleHeatmap() {
  heatmap.setMap(heatmap.getMap() ? null : map);
}

function changeGradient() {
  var gradient = [
    'rgba(0, 255, 255, 0)',
    'rgba(0, 255, 255, 1)',
    'rgba(0, 191, 255, 1)',
    'rgba(0, 127, 255, 1)',
    'rgba(0, 63, 255, 1)',
    'rgba(0, 0, 255, 1)',
    'rgba(0, 0, 223, 1)',
    'rgba(0, 0, 191, 1)',
    'rgba(0, 0, 159, 1)',
    'rgba(0, 0, 127, 1)',
    'rgba(63, 0, 91, 1)',
    'rgba(127, 0, 63, 1)',
    'rgba(191, 0, 31, 1)',
    'rgba(255, 0, 0, 1)'
  ]
  heatmap.set('gradient', heatmap.get('gradient') ? null : gradient);
}

function changeRadius() {
  heatmap.set('radius', heatmap.get('radius') ? null : 20);
}

function changeOpacity() {
  heatmap.set('opacity', heatmap.get('opacity') ? null : 0.2);
}

google.maps.event.addDomListener(window, 'load', initialize);

    </script>
	</head>

	<body>
    <div id="panel">
      <button onclick="toggleHeatmap()">Toggle Heatmap</button>
      <button onclick="changeGradient()">Change gradient</button>
      <button onclick="changeRadius()">Change radius</button>
      <button onclick="changeOpacity()">Change opacity</button>
    </div>
	<div>
		<form class="navbar-form navbar-left" role="search" action="/search" method="get">
	  		<div class="form-group">
	    		<input type="text" name="word" class="form-control" placeholder="Search">
	  		</div>
	  		<button type="submit" class="btn btn-default">Submit</button>
		</form>
 	  </div>
    <div id="map-canvas" style = "height:500px"></div>


	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="bootstrap/js/bootstrap.min.js"></script>
  </body>
</html>