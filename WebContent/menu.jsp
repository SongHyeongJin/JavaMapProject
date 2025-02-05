<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% String sessionId = (String) session.getAttribute("sessionId");%>
<nav class="navbar navbar-expand  navbar-dark bg-dark">
    <div class="container">
        <div class="navbar-header">
            <c:choose>
                <c:when test="${empty sessionId}">
                    <a class="navbar-brand" href="<c:url value='/Welcome.jsp'/>">Home</a>
                </c:when>
                <c:otherwise>
                    <a class="navbar-brand" href="<c:url value='/Welcome.do'/>">Home</a>
                </c:otherwise>
            </c:choose>
        </div>
        <div>
            <ul class="navbar-nav mr-auto">
                <c:choose>
                    <c:when test="${empty sessionId}">
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/member/loginMember.jsp"/>">로그인 </a></li>
                        <li class="nav-item"><a class="nav-link" href='<c:url value="/member/addMember.jsp"/>'>회원 가입</a></li>
                    </c:when>
                    <c:otherwise>
                        <li style="padding-top: 7px; color: white">[<%=sessionId%>님]</li>
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/member/LogoutMember.do"/>">로그아웃 </a></li>
                        <li class="nav-item"><a class="nav-link" href="<c:url value="/member/updateMember.jsp"/>">회원 정보 수정</a></li>
                        <li class="nav-item"><a class="nav-link" href="<c:url value='/RecordWriteAction.do'/>">여행 기록하기</a></li>
                        <li class="nav-item"><a class="nav-link" href="<c:url value='/RecordListAction.do?pageNum=1'/>">여행 기록 관리</a></li>
                    </c:otherwise>    
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
