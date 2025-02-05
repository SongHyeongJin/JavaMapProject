<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.*"%>
<%@ page import="mvc.model.RecordDTO"%>
<%
    List allrecordList = (List) request.getAttribute("allrecordlist");
    if (allrecordList == null) {
        allrecordList = new ArrayList();
    }
    List latitudes = new ArrayList();
    List longitudes = new ArrayList();
    for (Object obj : allrecordList) {
        RecordDTO record = (RecordDTO) obj;
        latitudes.add(record.getLat());
        longitudes.add(record.getLng());
    }
%>
<html>
  <head>
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
      <title>Welcome</title>
      <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ypeh0718cw"></script>
      <script>
          function updateTime() {
              var now = new Date();
              var hour = now.getHours();
              var minute = now.getMinutes();
              var second = now.getSeconds();
              var am_pm = "AM"; 
              if (hour >= 12) {
                  am_pm = "PM";
                  if (hour > 12) {
                      hour -= 12;
                  }
              } else if (hour == 0) {
                  hour = 12;
              }
              hour = ('0' + hour).slice(-2);
              minute = ('0' + minute).slice(-2);
              second = ('0' + second).slice(-2);
              var currentTime = hour + ":" + minute + ":" + second + " " + am_pm;
              document.getElementById('currentTime').innerHTML = "현재 접속 시각: " + currentTime;
          }
          window.onload = function() {
              updateTime(); 
              setInterval(updateTime, 1000);
              var sessionId = "<%= (String) session.getAttribute("sessionId") %>";

              if (sessionId) {
                  var mapOptions = {
                      center: new naver.maps.LatLng(37.566, 126.978),
                      zoom: 10
                  };
                  var map = new naver.maps.Map('map', mapOptions);
                  var latitudes = <%= latitudes %>;  
                  var longitudes = <%= longitudes %>;  
                  var markers = [];
                  var path = [];
                  for (var i = 0; i < latitudes.length; i++) {
                      var lat = latitudes[i];
                      var lng = longitudes[i];
                      var marker = new naver.maps.Marker({
                          position: new naver.maps.LatLng(lat, lng),
                          map: map
                      });
                      markers.push(marker);
                      path.push(new naver.maps.LatLng(lat, lng));
                  }
                  var polyline = new naver.maps.Polyline({
                      path: path,
                      strokeColor: "#0000FF",
                      strokeOpacity: 1.0,
                      strokeWeight: 3,
                      map: map
                  });
              } else{
                  var mapOptions = {
                      center: new naver.maps.LatLng(37.566, 126.978),
                      zoom: 10
                  };
                  var map = new naver.maps.Map('map', mapOptions);
              }
          };
        
      </script>
  </head>
  <body>
      <%@ include file="menu.jsp"%>
      <%!String greeting = "Travel Diary";
      String tagline = "Welcome to Travel Diary!";%>
      <div class="jumbotron">
            <div class="container">
              <h1 class="display-3">
                  <%=greeting%>
              </h1>
          </div>
      </div>  
      <div class="container">
          <div class="text-center">
              <div id="map" style="width:100%; height:400px; margin-bottom: 20px;"></div>
              <h4 id="currentTime"></h4>
              <h3>
                <%=tagline%>
              </h3>
          </div>
          <hr>
      </div>  
      <%@ include file="footer.jsp"%>
  </body>
</html>