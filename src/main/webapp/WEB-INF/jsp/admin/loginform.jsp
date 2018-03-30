<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />

<%@ include file="/WEB-INF/include/gnb.jsp" %>

<script type="text/javascript">
function validSubmit() {
	var f = document.loginFrm;
	
	if(f.adminId.value == ""){
		alert("아이디 입력하셈");
		f.adminId.focus();
		return false;
	}
	
	if(f.adminPw.value == ""){
		alert("비번 입력하셈");
		f.adminPw.focus();
		return false;
	}
	
	$.ajax({
		   type : 'POST',  
		   data:"adminId="+ f.adminId.value + "&adminPw=" + f.adminPw.value,
		   dataType : 'text',
		   url : 'login',  
		   success : function(rData, textStatus, xhr) {
			   if(rData == "true"){
				   
				   //로그인 성공하면 index 페이지로 리로드
				   location.replace(f.contextPath.value + "/admin/index");
			   }else if(rData == "false"){
				   alert("로그인 실패! 아이디 또는 비밀번호를 다시 확인해주세요!!");
			   }
		   },
		   error : function(xhr, status, e) {  
		   		alert("로그인 처리를 할 수 없습니다!");
		   		console.log("로그인 처리 에러 원인 >> "+e);
		   }
		});  
	
}

</script>

</head>
<body>
<center>

<h2>어드민 로그인</h2>

	<form name="loginFrm" method="post">
		<input type="hidden" name="contextPath" value="${pageContext.request.contextPath}"/>
		<input type="text" name="adminId" placeholder="아이디" style="width:222px; height:49px;"/>
		<input type="password" name="adminPw" placeholder="비밀번호" style="width:222px; height:49px;"/>
		<div id="loginResult"></div>
		<input type="button" value="로그인" onclick="validSubmit();" style="width:222px; height:49px;"/>
	</form>
</center>
</body>
</html>