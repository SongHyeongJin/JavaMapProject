<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%@ page import="mvc.model.RecordDTO"%>
<%
    String sessionId = (String) session.getAttribute("sessionId");
    List recordList = (List) request.getAttribute("recordlist");
    if (recordList == null) {
        recordList = new ArrayList();  
    }
    List allrecordList = (List) request.getAttribute("allrecordlist");
    if (allrecordList == null) {
        allrecordList = new ArrayList();  
    }
    int total_record = ((Integer) request.getAttribute("total_record")).intValue();
    int pageNum = ((Integer) request.getAttribute("pageNum")).intValue();
    int total_page = ((Integer) request.getAttribute("total_page")).intValue();
    int recordsPerPage = 5;
    int startNum = (pageNum - 1) * recordsPerPage + 1;
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
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <title>Record</title>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ypeh0718cw&submodules=geocoder"></script>
    <script type="text/javascript">
        function initmap() {
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
        }

        function checkForm() {  
            if ('<%=sessionId%>' == '') {
                alert("로그인 해주세요.");
                return false;
            }
            location.href = "./RecordWriteAction.do";
        }

        window.onload = initmap;
    </script>
</head>
<body>
    <jsp:include page="../menu.jsp" />
    <div class="jumbotron">
        <div class="container">
            <h1 class="display-3">글 목록</h1>
        </div>
    </div>
    <div class="container">
        <form action="<c:url value='./RecordListAction.do'/>" method="post">
            <div>
                <div id="map" style="width:100%; height:400px; margin-bottom: 20px;"></div>
                <div class="text-right">
                    <span class="badge badge-success">전체 <%= total_record %>건 </span>
                </div>
            </div>
            <div style="padding-top: 50px">
                <table class="table table-hover">
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>주소</th>
                        <th>작성/수정일</th>
                    </tr>
                    <%
                        int recordIndex = startNum;
                        for (int j = 0; j < recordList.size(); j++) {
                            RecordDTO record = (RecordDTO) recordList.get(j);
                    %>
                    <tr>
                        <td><%= recordIndex++%></td>
                        <td><a href="./RecordViewAction.do?num=<%= record.getNum() %>&pageNum=<%= pageNum %>"><%= record.getSubject() %></a></td>
                        <td><%= record.getAddress() %></td>
                        <td><%= record.getDate() %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
            <div align="center">
                <c:set var="pageNum" value="<%= pageNum %>" />
                <c:forEach var="i" begin="1" end="<%= total_page %>">
                    <a href="<c:url value='./RecordListAction.do?pageNum=${i}' />">
                        <c:choose>
                            <c:when test="${pageNum == i}">
                                <font color='4C5317'><b> [${i}]</b></font>
                            </c:when>
                            <c:otherwise>
                                <font color='4C5317'> [${i}]</font>
                            </c:otherwise>
                        </c:choose>
                    </a>
                </c:forEach>
            </div>
            <div align="left">
                <table>
                    <tr>
                        <td width="100%" align="left">&nbsp;&nbsp; 
                        <select name="items" class="txt">
                            <option value="subject">제목에서</option>
                            <option value="address">주소로</option>
                        </select> 
                        <input name="text" type="text" /> 
                        <input type="submit" id="btnAdd" class="btn btn-primary" value="검색 " />
                        </td>
                        <td width="100%" align="right">
                            <a href="#" onclick="checkForm(); return false;" class="btn btn-primary">&laquo;글쓰기</a>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
        <hr>
    </div>
    <jsp:include page="../footer.jsp" />
</body>
</html>
