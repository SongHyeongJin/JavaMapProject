<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="mvc.model.RecordDTO"%>

<%
    RecordDTO notice = (RecordDTO) request.getAttribute("record");
    int num = ((Integer) request.getAttribute("num")).intValue();
    int nowpage = ((Integer) request.getAttribute("page")).intValue();
    String name = (String) request.getAttribute("name"); 
%>
<html>
<head>
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ypeh0718cw&submodules=geocoder"></script>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>Record</title>
<script>
        let map; 
        let marker; 
        
        function initMap() {
            const defaultLocation = new naver.maps.LatLng(37.566, 126.978); 
            const address = "<%=notice.getAddress()%>"; 
            map = new naver.maps.Map('map', {
                center: defaultLocation,
                zoom: 10
            });
            marker = new naver.maps.Marker({
                position: defaultLocation,
                map: map
            });
            if (address && address.trim() !== "") {
                naver.maps.Service.geocode({ query: address }, function(status, response) {
                    if (status === naver.maps.Service.Status.OK) {
                        const result = response.v2.addresses[0];
                        const location = new naver.maps.LatLng(result.y, result.x);
                        map.setCenter(location);
                        marker.setPosition(location);
                        map.setZoom(20); 
                    } else {
                        console.log('초기 지도 표시 실패: ', status);
                    }
                });
            };
        }
        function openAddressSearch() {
            window.open("addressSearch.jsp", "주소 검색", "width=600,height=400");
        }
        function setAddress(address) {
            document.getElementById("address").value = address;

            naver.maps.Service.geocode({ query: address }, function(status, response) {
                if (status !== naver.maps.Service.Status.OK) {
                    return alert('지도 표시 실패: ' + status);
                }

                const result = response.v2.addresses[0];
                const location = new naver.maps.LatLng(result.y, result.x);

                // 지도에 위치 설정
                map.setCenter(location);
                marker.setPosition(location);
                map.setZoom(40);

                // 위도(lat)와 경도(lng) 값을 입력 필드에 자동 설정
                document.getElementById("lat").value = result.y;  // 위도
                document.getElementById("lng").value = result.x;  // 경도
            });
        }
        window.onload = initMap;
    </script>
</head>
<body>
    <jsp:include page="../menu.jsp" />
    <div class="jumbotron">
        <div class="container">
            <h1 class="display-3">글 보기</h1>
        </div>
    </div>

    <div class="container">
        <form name="newUpdate"
            action="RecordUpdateAction.do?num=<%=notice.getNum()%>&pageNum=<%=nowpage%>"
            class="form-horizontal" method="post">
            <div id="map" style="width: 100%; height: 400px; margin-top: 20px;"></div>
            <div class="form-group row">
                <label class="col-sm-2 control-label">제목</label>
                <div class="col-sm-5">
                    <input name="subject" class="form-control" value="<%=notice.getSubject()%>" >
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-2 control-label">주소</label>
                <div class="col-sm-5">
                    <input name="address" id="address" type="text" class="form-control" value="<%=notice.getAddress()%>" placeholder="address" readonly>
                    <button type="button" onclick="openAddressSearch()">주소 검색</button>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-2 control-label">위도 (Latitude)</label>
                <div class="col-sm-5">
                     <input name="lat" id="lat" type="text" class="form-control" value="<%=notice.getLat()%>" readonly>
                </div>
            </div>
            <div class="form-group row">
                 <label class="col-sm-2 control-label">경도 (Longitude)</label>
                 <div class="col-sm-5">
                      <input name="lng" id="lng" type="text" class="form-control" value="<%=notice.getLng()%>" readonly>
                 </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-2 control-label">내용</label>
                <div class="col-sm-8" style="word-break: break-all;">
                    <textarea name="content" class="form-control" cols="50" rows="5"><%=notice.getContext()%></textarea>
                </div>
            </div>
            <div class="form-group row">
                <div class="col-sm-offset-2 col-sm-10 ">
                    <c:set var="userId" value="<%=notice.getId()%>" />
                    <c:if test="${sessionId==userId}">
                        <p>
                            <a href="./RecordDeleteAction.do?num=<%=notice.getNum()%>&pageNum=<%=nowpage%>" class="btn btn-danger"> 삭제</a> 
                            <input type="submit" class="btn btn-success" value="수정">
                        </p>
                    </c:if>
                    <a href="./RecordListAction.do?pageNum=<%=nowpage%>" class="btn btn-primary"> 목록</a>
                </div>
            </div>
        </form>
        <hr>
    </div>
    <jsp:include page="../footer.jsp" />
</body>
</html>
