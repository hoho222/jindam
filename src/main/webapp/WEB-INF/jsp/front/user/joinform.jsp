<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script>

function validSubmit() {
	var f = document.frm;

	if(f.isOverlapCheck.value != "Y"){
		alert("이메일 중복 확인을 안했거나 중복된 이메일 입니다.\n이메일 주소를 다시 확인해 주세요!");
		f.email.focus();
		return false;
	}
	
	if(f.pw.value == ""){
		alert("비밀번호를 입력해주세요");
		f.pw.focus();
		return false;
	}
	
	if(f.rePw.value == ""){
		alert("비밀번호 확인을 입력해주세요");
		f.rePw.focus();
		return false;
	}
	
	if(f.pw.value != f.rePw.value){
		alert("비밀번호와 비밀번호 확인을 똑같이 입력해주세요!");
		return false;
	}
	
	f.target="_self";
	f.action="join";
	f.submit();
	
	
}

//이메일 아이디 중복확인(ajax로 구현)
function emailOverlap() {
	var f = document.frm;
	var email = f.email.value;
	var regExp = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
	
	if(!email.match(regExp)){
		alert("이메일 형식에 맞지않습니다.");
		return false;
	}
		
	$.ajax({
	   type : 'POST',  
	   data:"email="+ email,
	   dataType : 'text',
	   url : 'joinoverlap',  
	   success : function(rData, textStatus, xhr) {
		  
		   if(rData == "true"){
		   	document.getElementById("emailOverlapFin").innerHTML = "<font color='blue'>가능</font>";
		   	f.isOverlapCheck.value = "Y";
		   }else if(rData == "false"){
		   	document.getElementById("emailOverlapFin").innerHTML = "<font color='red'>불가능</font>";
		   	f.isOverlapCheck.value = "N";
		   }
	   },
	   error : function(xhr, status, e) {  
	   		alert("데이터 Access 에러! 중복확인을 할 수 없습니다!\n다시 시도해 주세요.");
	   		console.log("중복확인 에러 원인 >> "+e);
	   }
	});  
}

</script>

</head>

<center>
<section id="intro" class="container">
	<div id="" class="section">
		<div class="s-container">
			<h2 class="section-title" style="transform: translateY(0px); opacity: 1;">회원가입</h2>
		</div>
	</div>
	
	<form id="frm" name="frm" method="post">
		
		<table border="1">
			<tr>
				<td><div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-user"></i></div></td>
				<td>
				    <div class="w3-rest">
				      <input class="w3-input w3-border" name="email" type="text" placeholder="Your Email">
				    </div>
				    <div>
				    	<input type="hidden" id="isOverlapCheck" value="not" />
					    <input class="button alt" type="button" style="font-size: 13px;" onclick="emailOverlap();" value="이메일 중복확인"/>
					    <div id="emailOverlapFin" style="float: right;"><font color="red">이메일 중복확인을 해주세요.</font></div>
				    </div>
				    
				</td>
			</tr>
			<tr>
				<td><div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-lock"></i></div></td>
				<td>
					<div class="w3-rest">
				      <input class="w3-input w3-border" name="pw" type="password" placeholder="Your Password">
				    </div>
				</td>
			</tr>
			<tr>
				<td><div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-lock"></i></div></td>
				<td>
					<div class="w3-rest">
				      <input class="w3-input w3-border" name="rePw" type="password" placeholder="Your Password Confirm">
				    </div>
				</td>
			</tr>
			
		</table> 
		<input type="button" value="회원가입" onclick="validSubmit();"/>
	</form>
</center>
</section>
<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>