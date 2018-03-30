<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
<script type="text/javascript">
function validSubmit(){
	var f = document.frm;
	
	if(f.newPw.value == f.nowPw.value){
		alert("기존 비밀번호와 같은 비밀번호로는 수정하실 수 없습니다.");
		f.newPw.focus();
		return false;
	}
	
	if(f.newPw.value != f.newPwRe.value){
		alert("새로운 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
		f.newPwRe.focus();
		return false;
	}
	
	
	$.ajax({
	   type : 'POST',  
	   data:"no="+ f.no.value + "&mode=" + f.mode.value + "&pw=" + f.nowPw.value + "&newPw=" + f.newPw.value + "&newPwRe=" + f.newPwRe.value,
	   dataType : 'text',
	   url : '/LOLweb/users/mypage/'+f.no.value,  
	   success : function(rData, textStatus, xhr) {
		   if(rData == "true"){
			   location.replace(f.contextPath.value + "/mypage/"+f.no.value);
		   }else if(rData == "false"){
			   alert("올바르지 않는 기존 비밀번호 입니다!");
			   location.replace(f.contextPath.value + "/index");
		   }
	   },
	   error : function(xhr, status, e) {  
	   		alert("데이터 Access 실패! 다시 한번 로그인 해주세요.");
	   		console.log("로그인 처리 에러 원인 >> "+e);
	   }
	}); 
}

function isMatch(no, mode){
	var msg = "중단";
	
	if(mode == "START_MATCH"){
		msg = "재개";
	}
	
	$.ajax({
	   type : 'POST',  
	   data:"no="+ no + "&mode=" + mode,
	   dataType : 'text',
	   url : '/LOLweb/users/mypage/'+no,  
	   success : function(rData, textStatus, xhr) {
		   if(rData == "true"){
			   alert("소개가 "+msg+"되었습니다.");
			   window.location.reload();
		   }else if(rData == "false"){
			   window.location.reload();
		   }
	   },
	   error : function(xhr, status, e) {  
	   		alert("데이터 Access 실패! 다시 한번 로그인 해주세요.");
	   		console.log("로그인 처리 에러 원인 >> "+e);
	   }
	}); 
}

function delMember(no){
	if(confirm("정말 탈퇴하시겠습니까?\n이전의 정보는 모두 삭제됩니다.")){
		$.ajax({
		   type : 'POST',  
		   data:"no="+ no,
		   dataType : 'text',
		   url : '/LOLweb/users/secession',  
		   success : function(rData, textStatus, xhr) {
			   if(rData == "true"){
				   alert("탈퇴 완료 되었습니다.");
				   location.replace("${pageContext.request.contextPath}/users/logout");
			   }else if(rData == "false"){
				   alert("탈퇴 실패!");
				   window.location.reload();
			   }
		   },
		   error : function(xhr, status, e) {  
		   		alert("데이터 Access 실패! 다시 한번 시도해주세요.");
		   		console.log("탈퇴 처리 에러 원인 >> "+e);
		   }
		}); 
	}
}

$(document).ready(function() {

    //When page loads...
    $(".tab_content").hide(); //Hide all content
    $("ul.tabs li:first").addClass("active").show(); //Activate first tab
    $(".tab_content:first").show(); //Show first tab content

    //On Click Event
    $("ul.tabs li").click(function() {

        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(this).addClass("active"); //Add "active" class to selected tab
        $(".tab_content").hide(); //Hide all tab content

        var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
        $(activeTab).fadeIn(); //Fade in the active ID content
        return false;
    });

});

</script>

</head>

<!-- Main -->
<section id="intro" class="container">
	<div id="main-wrapper">
	
		<!--탭 메뉴 영역 -->
	    <ul class="tabs">
	        <li style="font-size: 13px;"><a href="#tab1">비밀번호 변경</a></li>
	        <li style="font-size: 13px;"><a href="#tab2">소개중단</a></li>
	    </ul>

	
		<!--탭 콘텐츠 영역 -->
	    <div class="tab_container">
	
	        <div id="tab1" class="tab_content">
	
				<c:choose>
			      <c:when test="${!empty myMemberMap}">
			      
					<form name="frm" id="frm" method="post">
						<input type="hidden" name="contextPath" value="${pageContext.request.contextPath}">
						<input type="hidden" name="no" value="${myMemberMap.NO}"/>
						<input type="hidden" name="mode" value="EDIT_PW"/>
						
						<div style="padding: 20px 20px 20px 20px;">
							<h2 id="pwEdit">비밀번호 변경</h2>
							
							<div class="w3-row w3-section">
							      <span style="font-size:16px;">이메일</span><br>
							      <span style="font-size:12px;">${myMemberMap.EMAIL }</span>
							</div>
							<div class="w3-row w3-section">
							      <span style="font-size:16px;">기존 비밀번호</span>
							      <input name="nowPw" type="password" value="${myMemberMap.PW }"/>
							</div>
							<div class="w3-row w3-section">
							      <span style="font-size:16px;">새로운 비밀번호</span>
							      <input name="newPw" type="password"/>
							</div>
							<div class="w3-row w3-section">
							      <span style="font-size:16px;">새로운 비밀번호 확인</span>
							      <input name="newPwRe" type="password"/>
							</div>
							<input type="submit" value="정보 수정 완료" onclick="validSubmit();"/>
						</div>
						
					</form>
				</c:when>
				<c:otherwise>
					정보가 없습니다.
				</c:otherwise>
			  </c:choose>
			</div>
		
	
		 <div id="tab2" class="tab_content">
			 <div style="padding: 20px 20px 20px 20px;">
				<h2 id="possibleMatch">소개중단/재개</h2>
				<c:if test="${!empty myMemberMap}">
					<c:choose>
					<c:when test="${myMemberMap.ISPOSSIBLEMATCH eq 'T'}">
						개인적인 사정으로 소개를 당분간 그만 받고 싶습니다. <br>
						<input type="button" value="소개 중단 요청" onclick="isMatch(${myMemberMap.NO},'STOP_MATCH');"/>
					</c:when>
					<c:when test="${myMemberMap.ISPOSSIBLEMATCH eq 'F'}">
						소개를 다시 받고 싶습니다. <br>
						<input type="button" value="소개 재개 요청" onclick="isMatch(${myMemberMap.NO},'START_MATCH');"/>
					</c:when>
					</c:choose>
				</c:if>
				
				<hr>
				
				<h2>회원 탈퇴</h2>
				진담 서비스가 더 이상 필요하지 않으신가요?<br>
				<span class="button alt" onclick="delMember(${myMemberMap.NO})">회원 탈퇴</span>
				
			</div>
		</div>
	</div>
</div>
</section>
<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>