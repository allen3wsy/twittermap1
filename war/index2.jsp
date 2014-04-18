<%@ page import="edu.cu.cloud.DatastoreAPI" %>
<%@ page import="edu.cu.cloud.Coordinate" %>
<%@ page import="edu.cu.cloud.PorterStemmer" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="../../assets/ico/favicon.ico">


    <!-- Bootstrap core CSS -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="offcanvas.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="starter-template.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy this line! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    
    	<title>Heatmaps</title>
	<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=visualization"></script>
	<script>


// Adding 500 Data Points
var map, pointarray, heatmap;

var alldata = {
	<%
	Hashtable<String,ArrayList<Coordinate>> list = (Hashtable<String,ArrayList<Coordinate>>)request.getAttribute("coordinateList");
	String[] keySet = null;
	if(list!=null && list.size() != 0){
		Set<String> set = list.keySet();
		keySet = set.toArray(new String[set.size()]);
		for(int i= 1 ; i < keySet.length; i++){
			out.println("\""+keySet[i]+"\":[");
			ArrayList<Coordinate> coordinateList = list.get(keySet[i]);
			for ( int j = 1 ; j < coordinateList.size(); j++){
				double lat = coordinateList.get(j).lat;
				double lon = coordinateList.get(j).lon;
				out.println("new google.maps.LatLng("+lat+","+lon+"),");
			}
	
			double lastLat = coordinateList.get(0).lat;
			double lastLon = coordinateList.get(0).lon;
			out.println("new google.maps.LatLng("+lastLat+","+lastLon+")");
			out.println("],");
		}
		String lastKey = keySet[0];
		out.println("\""+lastKey+"\":[");
		ArrayList<Coordinate> coordinateList = list.get(lastKey);
		for ( int j = 1 ; j < coordinateList.size(); j++){
			double lat = coordinateList.get(j).lat;
			double lon = coordinateList.get(j).lon;
			out.println("new google.maps.LatLng("+lat+","+lon+"),");
		}

		double lastLat = coordinateList.get(0).lat;
		double lastLon = coordinateList.get(0).lon;
		out.println("new google.maps.LatLng("+lastLat+","+lastLon+")");
		out.println("]");
	}
	%>
};


<%-- var taxiData = [
<% 
	Hashtable<String,ArrayList<Coordinate>> list = (Hashtable<String,ArrayList<Coordinate>>)request.getAttribute("coordinateList");
	ArrayList<Coordinate> coordinateList = new ArrayList<Coordinate>();
	for(String key : list.keySet()){
		coordinateList.addAll(list.get(key));
	}
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
]; --%>

function initialize() {

	var taxiData = new Array();

	for (var key in alldata) {
        taxiData = taxiData.concat.apply(taxiData, alldata[key]);
	}

  var mapOptions = {
    zoom: 5,
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
heatmap.set('radius', 20);
}


function filter(date){
	var list = alldata[date];
	var mapOptions = {
			zoom: 1,
			center: new google.maps.LatLng(37.774546, -122.433523),
			mapTypeId: google.maps.MapTypeId.SATELLITE
	};
	map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);
	var points = new google.maps.MVCArray(list);
	heatmap = new google.maps.visualization.HeatmapLayer({
		data: points
	});
	heatmap.setMap(map);
	heatmap.set('radius', 10);
	
}

google.maps.event.addDomListener(window, 'load', initialize);

    </script>
  </head>

  <body>

    <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <a class="navbar-brand" href="#">Twitter Map</a>
        </div>
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="#">Home</a></li>
            <li><a href="#about">About</a></li>
            <li><a href="#contact">Contact</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </div>
    
    
    <div class="container">
    
	<form class="navbar-form navbar-left" role="search" action="/search" method="GET">
        <div class="form-group">
          <input type="text" name="word" class="form-control" placeholder="Search">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
      </form>
	</div>
	<div class="container">
      <div class="row row-offcanvas row-offcanvas-right">

        <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
          <div class="list-group">
          <%
          if(keySet!=null && keySet.length!=0){
	          for ( int i = 0 ; i <keySet.length; i++){
	        	  out.println("<a onclick=\"filter(\'"+keySet[i]+ "\')\" href=\"javascript:void(0);\"class=\"list-group-item\">"+keySet[i]+"</a>");
	          }
          }
          %>
          </div>
        </div><!--/span-->
        
        <div class="col-xs-12 col-sm-9">
          <div class="jumbotron">
          <div id="map-canvas" style="position: relative;width: 100%;height: 0;padding-bottom: 70%;"></div>
          </div>
          </div><!--/row-->
        </div><!--/span-->

      </div><!--/row-->

      <hr>

      <footer>
        <p>&copy; Company 2014</p>
      </footer>
</div>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
  </body>
</html>
