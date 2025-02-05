<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
%>

<sql:setDataSource var="dataSource"
    url="jdbc:mysql://localhost:3306/mapprojectdb"
    driver="com.mysql.jdbc.Driver" user="mapproject" password="pwd1234" />

<sql:query dataSource="${dataSource}" var="resultSet">
   SELECT * FROM MEMBER WHERE BINARY ID=?   
   <sql:param value="<%=id%>" />
</sql:query>

<c:choose>
    <c:when test="${empty resultSet.rows}">
        <script type="text/javascript">
            alert("사용 가능한 아이디입니다.");
            opener.isIdChecked = true;
            window.close();
        </script>
    </c:when>
    <c:otherwise>
        <script type="text/javascript">
            alert("이미 사용 중인 아이디입니다.");
            opener.isIdChecked = false;
            window.close();
        </script>
    </c:otherwise>
</c:choose>
