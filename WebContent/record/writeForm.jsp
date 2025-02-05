<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ypeh0718cw&submodules=geocoder"></script>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>Record</title>
<script>
    let map;
    let marker;
    function initMap() {
        const defaultLocation = new naver.maps.LatLng(37.566, 126.978); // 초기 위치 설정
        map = new naver.maps.Map('map', {
            center: defaultLocation,
            zoom: 10
        });
        marker = new naver.maps.Marker({
            position: defaultLocation,
            map: map
        });
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
            map.setCenter(location);
            marker.setPosition(location);
            map.setZoom(40);
            document.getElementById("lat").value = result.y;  
            document.getElementById("lng").value = result.x; 
        });
    }
    window.onload = initMap;
</script>
</head>

<script type="text/javascript">
    function checkForm() {
        if (!document.newWrite.address.value) {
            alert("주소를 입력하세요.");
            return false;
        }
        if (!document.newWrite.subject.value) {
            alert("제목을 입력하세요.");
            return false;
        }
        if (!document.newWrite.content.value) {
            alert("내용을 입력하세요.");
            return false;
        }       
    }
</script>

<body>
    <jsp:include page="../menu.jsp" />
    <div class="jumbotron">
        <div class="container">
            <h1 class="display-3">글 작성</h1>
        </div>
    </div>

    <div class="container">
        <form name="newWrite" action="./RecordAction.do"
            class="form-horizontal" method="post" onsubmit="return checkForm()">
            <input name="id" type="hidden" class="form-control" value="${sessionId}">
            <div id="map" style="width: 100%; height: 400px; margin-top: 20px;"></div>          
            <div class="form-group row">
                <label class="col-sm-2 control-label" >제목</label>
                <div class="col-sm-5">
                    <input name="subject" type="text" class="form-control" placeholder="subject">
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-2 control-label" >주소</label>
                <div class="col-sm-5">
                    <input name="address" id="address" type="text" class="form-control" placeholder="address" readonly>
                    <button type="button" onclick="openAddressSearch()">주소 검색</button>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-2 control-label" >위도 (Latitude)</label>
                <div class="col-sm-5">
                    <input name="lat" id="lat" type="text" class="form-control" readonly>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-2 control-label" >경도 (Longitude)</label>
                <div class="col-sm-5">
                    <input name="lng" id="lng" type="text" class="form-control" readonly>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-2 control-label" >내용</label>
                <div class="col-sm-8">
                    <textarea name="context" cols="50" rows="5" class="form-control" placeholder="context"></textarea>
                </div>
            </div>

            <div class="form-group row">
                <div class="col-sm-offset-2 col-sm-10 ">
                    <input type="submit" class="btn btn-primary" value="등록 ">              
                    <input type="reset" class="btn btn-primary" value="취소 ">
                </div>
            </div>
        </form>
        <hr>
    </div>
    <jsp:include page="../footer.jsp" />
</body>
</html>
