<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<link rel="stylesheet" href="../resources/css/bootstrap.min.css" />
<script type="text/javascript">
    var isIdChecked = false;

    function checkForm() {
        if (!document.newMember.id.value) {
            alert("아이디를 입력하세요.");
            return false;
        }

        if (!isIdChecked) {
            alert("아이디 중복 확인을 해주세요.");
            return false;
        }

        if (!document.newMember.password.value) {
            alert("비밀번호를 입력하세요.");
            return false;
        }

        if (document.newMember.password.value != document.newMember.password_confirm.value) {
            alert("비밀번호를 동일하게 입력하세요.");
            return false;
        }

        if (!document.newMember.name.value) {
            alert("이름을 입력하세요.");
            return false;
        }
    }

    function checkId() {
        var id = document.getElementById("idInput").value;
        var idPtrn = /^[a-zA-Z]{1}[\w_!]{3,19}$/;
        if (!id) {
            alert("아이디를 입력하세요.");
            return;
        }
        if (!idPtrn.test(id)) {
            alert("아이디 형식에 맞지 않습니다.\n영문자로 시작하여 숫자, !, _로 4~20자 이내로 구성해주세요.");
            return;
        }
        window.open("checkMember.jsp?id=" + id, "중복확인", "width=700,height=200");
    }

    function resetIdCheck() {
        isIdChecked = false;
    }
</script>

<title>회원 가입</title>
</head>
<body>
	<jsp:include page="/menu.jsp" />
	<div class="jumbotron">
		<div class="container">
			<h1 class="display-3">회원 가입</h1>
		</div>
	</div>

	<div class="container">
		<form name="newMember" class="form-horizontal"  action="./AddMember.do" method="post" onsubmit="return checkForm()">
			<div class="form-group  row">
				<label class="col-sm-2 ">아이디</label>
				<div class="col-sm-3">
					<input name="id" type="text" class="form-control" placeholder="id" id="idInput" oninput="resetIdCheck()">
				</div>
				<div class="col-sm-2">
                    <button type="button" class="btn btn-secondary" onclick="checkId()">아이디 중복확인</button>
                </div>
			</div>
			<div class="form-group  row">
				<label class="col-sm-2">비밀번호</label>
				<div class="col-sm-3">
					<input name="password" type="text" class="form-control" placeholder="password" >
				</div>
			</div>
			<div class="form-group  row">
				<label class="col-sm-2">비밀번호확인</label>
				<div class="col-sm-3">
					<input name="password_confirm" type="text" class="form-control" placeholder="password confirm" >
				</div>
			</div>
			<div class="form-group  row">
				<label class="col-sm-2">성명</label>
				<div class="col-sm-3">
					<input name="name" type="text" class="form-control" placeholder="name" >
				</div>
			</div>
				<div class="col-sm-offset-2 col-sm-10 ">
					<input type="submit" class="btn btn-primary " value="등록 " > 
					<input type="reset" class="btn btn-primary " value="취소 " onclick="reset()" >
				</div>
			</div>
		</form>
	</div>
</body>
</html>