<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
var slideIndex = 1;
showDivs(slideIndex);

function plusDivs(n) {
  showDivs(slideIndex += n);
}

function showDivs(n) {
  var i;
  var x = document.getElementsByClassName("mySlides");
  if (n > x.length) {slideIndex = 1}    
  if (n < 1) {slideIndex = x.length}
  for (i = 0; i < x.length; i++) {
     x[i].style.display = "none";  
  }
  if(x[slideIndex-1] != undefined){
  	x[slideIndex-1].style.display = "block";
  }
}

function validSubmit() {
	var f = document.loginFrm;
	
	if(f.email.value == ""){
		alert("이메일을 입력해주세요.");
		f.email.focus();
		return false;
	}
	if(f.pw.value == ""){
		alert("비번을 입력해주세요!.");
		f.pw.focus();
		return false;
	}
	
	$.ajax({
	   type : 'POST',  
	   data:"email="+ f.email.value + "&pw=" + f.pw.value,
	   dataType : 'text',
	   url : '/LOLweb/users/login',  
	   success : function(rData, textStatus, xhr) {
		   if(rData == "true"){
			   //로그인 성공하면 index 페이지로 리로드
			   location.replace(f.contextPath.value + "/index");
		   }else if(rData == "false"){
			   alert("아이디 또는 비밀번호가 일치하지 않습니다!");
			   location.replace(f.contextPath.value + "/index");
		   }
	   },
	   error : function(xhr, status, e) {  
	   		alert("데이터 Access 실패! 다시 한번 로그인 해주세요.");
	   		console.log("로그인 처리 에러 원인 >> "+e);
	   }
	});  
}

function viewAd(myMemberNo){
	var popUrl = "http://naver.com";
	var popOption = "width=370, height=360, resizable=no, scrollbars=no, status=no;";
	window.open(popUrl,"",popOption);
	
	$.ajax({
	   type : 'POST',  
	   data:"no="+ myMemberNo,
	   dataType : 'text',
	   url : '/LOLweb/users/adreward',  
	   success : function(rData, textStatus, xhr) {
		   if(rData == "true"){
			   //오늘 한번도 광고로 비행기 받은적 없으면 비행기 +10
			   location.replace(f.contextPath.value + "/index");
		   }else if(rData == "false"){
			   //이미 오늘 광고로 비행기 지급받았을땐 그냥 광고만 보고 끝임.
		   }
	   },
	   error : function(xhr, status, e) {  
	   		alert("데이터 Access 실패! 다시 한번 시도 해주세요.");
	   		console.log("광고 리워드 처리 에러 원인 >> "+e);
	   }
	});
	
	document.getElementById('AdModal').style.display='none';
}

function goDetail(matchMemberNo){
	window.location.href = "../LOLweb/users/matchuserinfo/"+matchMemberNo;
}

function setCookie( name, value, expiredays ) {
    var todayDate = new Date();
    todayDate.setDate( todayDate.getDate() + expiredays ); 
    document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}

function getCookie(cname) {
	var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
} 

function closeAdModal(){
	if ( document.getElementById("todayChk").checked ){
        setCookie( "AdModal", "done" , 1 );
    }
	document.getElementById('AdModal').style.display='none';
}

$(document).ready(function() {
	if(document.getElementById('sessionNo').value != 'null' && document.getElementById('sessionEmail').value != 'null'){
		if(getCookie("AdModal")!="done"){
			document.getElementById('AdModal').style.display='block';
		}
	}
});

</script>

</head>

<!-- Banner -->
<!-- <section id="banner">
	<header>
		<h2>진심을 담아<br>진심을 담은 당신을 만나고 싶어요. </h2>
		<p>인연을 만날 땐 사진은 필요없습니다. <br>진실 된 당신의 이야기면 충분합니다.</p>
	</header>
</section> -->

<!-- Main -->
<section id="intro" class="container">
	<div id="main-wrapper">
		<div>
		
		<input type="hidden" id="sessionNo" value="${sessionNo }"/>
		<input type="hidden" id="sessionEmail" value="${sessionEmail }"/>
		
		<!-- 광고모달 -->
		<div id="AdModal" class="w3-modal">
		    <div class="w3-modal-content">
		      <div class="w3-container">
		        <span onclick="document.getElementById('AdModal').style.display='none'" class="w3-button w3-display-topright">&times;</span>
		        
		        <div style="padding: 5px 5px 15px 5px;">
		        	<h4>광고</h4>
			        <p style="font-size: 15px; color: #ff495b">
			        	<a onclick="viewAd(${sessionNo});">10비행기 받고 보러가기 Click! (1일 1회 제한)</a>
			        </p>
			        <br>
			        
			        <div id="check" style="font-size: 11px;"><input type="checkbox" id="todayChk" value="checkbox" style="margin-right:5px;">오늘 하루동안 보지 않기</div>
			        <br>
			        <span class="button alt" onclick="closeAdModal();" style="font-size: 15px;">확인</span>
		        </div>
		        
		      </div>
		    </div>
	  	</div>
	  	
	  	<c:choose>  		
			<c:when test="${myMemberMap.ISAUTH eq 'F'}">
				<!-- 비 본인인증 회원 -->
				<h2>본인인증</h2>
				
				<div style="margin:20px 0 20px 0;">당신을 보여주기 위해 본인인증이 필요합니다.<br>귀찮더라도 진실된 만남을 위해 본인인증을 부탁드립니다.</div>
				
				<div style="margin:20px 0 20px 0;"><i class="glyphicon glyphicon-ok-circle" style="font-size:100px;"></i></div>
				
				<a href="${pageContext.request.contextPath}/users/userauth/${sessionNo}" class="button alt">본인 인증하기</a>
				<!-- <input type="button" value="본인 인증하기"/> -->
			</c:when>
			
			<c:otherwise>
				<c:choose>
					<c:when test="${sessionNo != 'null' && sessionEmail != 'null'}">
						<div style="font-size: 13px; margin-bottom:50px;">${sessionEmail} 로 로그인 하셨네요!</div>
								
							<c:if test="${!empty myMemberMap && myMemberMap.MATCH_SUCCESS_MEMBERNO eq null && myMemberMap.MATCHSUCCESSDATE eq null }">
								
								<c:if test="${!empty matchMemberMap }">
								
								<!-- 현재 매칭유저 정보 -->
								<div class="mySlides">
									<h3>현재 매칭유저 정보</h3>
									
									<c:if test="${myMemberMap.STATUS ne 'F' || myMemberMap.ISPASS ne 'T'}">
										<div style="border: 1px solid grey;border-radius: 1em;font-size: 14px; padding: 5px 5px 5px 5px; margin:15px 15px 15px 15px;">
											<span style="color:#ff495b;">이런!</span><br>
											현재 회원님이 개인정보를 수정하여 심사중에 있거나<br>
											개인정보 수정결과가 반려당한 상태입니다.<br>
											수정결과가 승인되면 더 멋진 상대를 소개해 드릴게요.
										</div>
									</c:if>
									
									<c:if test="${myMemberMap.STATUS eq 'F' && myMemberMap.ISPASS eq 'T'}">
									<c:choose>
									<c:when test="${matchMemberMap.STATUS ne 'F' || matchMemberMap.ISPASS ne 'T'}">
										<div style="border: 1px solid grey;border-radius: 1em;font-size: 14px; padding: 5px 5px 5px 5px; margin:15px 15px 15px 15px;">
											<span style="color:#ff495b;">이런!</span><br>
											현재 매칭된 유저가 개인정보를 수정하여 심사중에 있거나<br>
											개인정보 수정결과가 반려당한 상태입니다.<br>
											내일 더 멋진 상대를 소개해 드릴게요.
										</div>
									</c:when>
									
									<c:otherwise>
									<table>
										<tr>
										  <td>
										  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<c:choose>
										  			<c:when test="${matchMemberMap.REGION eq '1'}">인천</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '2'}">경기 서남</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '3'}">경기 서북</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '4'}">서울</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '5'}">경기 동북</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '6'}">경기 동남</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '7'}">강원</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '8'}">충북</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '9'}">대전</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '10'}">충남</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '11'}">전북</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '12'}">광주</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '13'}">전남</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '14'}">경남</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '15'}">부산</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '16'}">울산</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '17'}">대구</c:when>
										  			<c:when test="${matchMemberMap.REGION eq '18'}">경북</c:when>
										  			<c:otherwise>-</c:otherwise>
										  		</c:choose>
										  		
										  	</div>
										  </td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberMap.COMPANY }</div></td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberMap.JOB }</div></td>
									    </tr>
										<tr>
										  <td><div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;"><span class="glyphicon glyphicon-chevron-left" onclick="plusDivs(-1)" title="이전으로 이동"></span></div></td>
										  <td>
										  	<div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<span class="glyphicon glyphicon-user"></span>
										  		<c:if test="${matchMemberMap.GENDER eq 'male'}">남성</c:if>
										  		<c:if test="${matchMemberMap.GENDER eq 'female'}">여성</c:if>
										  		<br>${matchMemberMap.NICKNAME }
										  	</div>
										  </td>
										  <td><div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;"><span class="glyphicon glyphicon-chevron-right" onclick="plusDivs(1)" title="이후로 이동"></span></div></td>
										</tr>
										<tr>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberMap.BIRTHYEAR }년생</div></td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberMap.BLOODTYPE }형</div></td>
										  <td>
										  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<c:choose>
										  			<c:when test="${matchMemberMap.STANCE eq '1'}">보수</c:when>
										  			<c:when test="${matchMemberMap.STANCE eq '2'}">중도보수</c:when>
										  			<c:when test="${matchMemberMap.STANCE eq '3'}">중도</c:when>
										  			<c:when test="${matchMemberMap.STANCE eq '4'}">중도진보</c:when>
										  			<c:when test="${matchMemberMap.STANCE eq '5'}">진보</c:when>
										  			<c:otherwise>-</c:otherwise>
										  		</c:choose>
										  		
										  	</div>
										  </td>
										</tr>
										
										
									</table>
									<input type="button" value="더 알아보러 가기" onclick="goDetail(${matchMemberMap.MEMBERNO})"/>
									</c:otherwise>
									
									</c:choose>
									</c:if>
								</div>
								
								
								</c:if>
								
								<c:if test="${empty matchMemberMap }">
									<br><br>이런! 오늘은 회원님과 맞는 상대가 없습니다 ㅠㅠ.<br>
								</c:if>
								
								<!-- 이전 매칭유저 정보 -->
								<c:if test="${!empty myOlderMatchMemberMap }">
								<div class="mySlides"style="display: none;">
									<h3>이전 매칭유저 정보</h3>
									<table>
										<tr>
										  <td>
										  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<c:choose>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '1'}">인천</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '2'}">경기 서남</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '3'}">경기 서북</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '4'}">서울</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '5'}">경기 동북</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '6'}">경기 동남</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '7'}">강원</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '8'}">충북</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '9'}">대전</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '10'}">충남</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '11'}">전북</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '12'}">광주</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '13'}">전남</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '14'}">경남</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '15'}">부산</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '16'}">울산</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '17'}">대구</c:when>
										  			<c:when test="${myOlderMatchMemberMap.REGION eq '18'}">경북</c:when>
										  			<c:otherwise>-</c:otherwise>
										  		</c:choose>
										  		
										  	</div>
										  </td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${myOlderMatchMemberMap.COMPANY }</div></td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${myOlderMatchMemberMap.JOB }</div></td>
									    </tr>
										<tr>
										  <td><div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;"><span class="glyphicon glyphicon-chevron-left" onclick="plusDivs(-1)"></span></div></td>
										  <td>
										  	<div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<span class="fa fa-user-o"></span>
										  		<c:if test="${myOlderMatchMemberMap.GENDER eq 'male'}">남성<span class="glyphicon glyphicon-user"></span></c:if>
										  		<c:if test="${myOlderMatchMemberMap.GENDER eq 'female'}">여성<span class="glyphicon glyphicon-user"></span></c:if>
										  		<br>${myOlderMatchMemberMap.NICKNAME }
										  	</div>
										  </td>
										  <td><div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;"><span class="glyphicon glyphicon-chevron-right" onclick="plusDivs(1)"></span></div></td>
										</tr>
										<tr>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${myOlderMatchMemberMap.BIRTHYEAR }년생</div></td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${myOlderMatchMemberMap.BLOODTYPE }형</div></td>
										  <td>
										  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<c:choose>
										  			<c:when test="${myOlderMatchMemberMap.STANCE eq '1'}">보수</c:when>
										  			<c:when test="${myOlderMatchMemberMap.STANCE eq '2'}">중도보수</c:when>
										  			<c:when test="${myOlderMatchMemberMap.STANCE eq '3'}">중도</c:when>
										  			<c:when test="${myOlderMatchMemberMap.STANCE eq '4'}">중도진보</c:when>
										  			<c:when test="${myOlderMatchMemberMap.STANCE eq '5'}">진보</c:when>
										  			<c:otherwise>-</c:otherwise>
										  		</c:choose>
										  		
										  	</div>
										  </td>
										</tr>
									</table>
								</div>
								</c:if>
								
								<!-- 이전전 매칭유저 정보 -->
								<c:if test="${!empty myOldestMatchMemberMap }">
								<div class="mySlides"style="display: none;">
									<h3>이전전 매칭유저 정보</h3>
									<table>
										<tr>
										  <td>
										  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<c:choose>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '1'}">인천</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '2'}">경기 서남</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '3'}">경기 서북</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '4'}">서울</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '5'}">경기 동북</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '6'}">경기 동남</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '7'}">강원</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '8'}">충북</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '9'}">대전</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '10'}">충남</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '11'}">전북</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '12'}">광주</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '13'}">전남</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '14'}">경남</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '15'}">부산</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '16'}">울산</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '17'}">대구</c:when>
										  			<c:when test="${myOldestMatchMemberMap.REGION eq '18'}">경북</c:when>
										  			<c:otherwise>-</c:otherwise>
										  		</c:choose>
										  		
										  	</div>
										  </td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${myOldestMatchMemberMap.COMPANY }</div></td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${myOldestMatchMemberMap.JOB }</div></td>
									    </tr>
										<tr>
										  <td><div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;"><span class="glyphicon glyphicon-chevron-left" onclick="plusDivs(-1)"></span></div></td>
										  <td>
										  	<div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<span class="fa fa-user-o"></span>
										  		<c:if test="${myOldestMatchMemberMap.GENDER eq 'male'}">남성<span class="glyphicon glyphicon-user"></span></c:if>
										  		<c:if test="${myOldestMatchMemberMap.GENDER eq 'female'}">여성<span class="glyphicon glyphicon-user"></span></c:if>
										  		<br>${myOldestMatchMemberMap.NICKNAME }
										  	</div>
										  </td>
										  <td><div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;"><span class="glyphicon glyphicon-chevron-right" onclick="plusDivs(1)"></span></div></td>
										</tr>
										<tr>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${myOldestMatchMemberMap.BIRTHYEAR }년생</div></td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${myOldestMatchMemberMap.BLOODTYPE }형</div></td>
										  <td>
										  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<c:choose>
										  			<c:when test="${myOldestMatchMemberMap.STANCE eq '1'}">보수</c:when>
										  			<c:when test="${myOldestMatchMemberMap.STANCE eq '2'}">중도보수</c:when>
										  			<c:when test="${myOldestMatchMemberMap.STANCE eq '3'}">중도</c:when>
										  			<c:when test="${myOldestMatchMemberMap.STANCE eq '4'}">중도진보</c:when>
										  			<c:when test="${myOldestMatchMemberMap.STANCE eq '5'}">진보</c:when>
										  			<c:otherwise>-</c:otherwise>
										  		</c:choose>
										  		
										  	</div>
										  </td>
										</tr>
									</table>
								</div>
								</c:if>
							</c:if>
							
							<c:if test="${!empty myMemberMap && myMemberMap.MATCH_SUCCESS_MEMBERNO ne null && myMemberMap.MATCHSUCCESSDATE ne null && !empty matchSuccessMemberMap}">
								<h3>성사된 소개팅 유저 정보</h3>
									<table>
										<tr>
										  <td>
										  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<c:choose>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '1'}">인천</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '2'}">경기 서남</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '3'}">경기 서북</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '4'}">서울</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '5'}">경기 동북</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '6'}">경기 동남</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '7'}">강원</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '8'}">충북</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '9'}">대전</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '10'}">충남</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '11'}">전북</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '12'}">광주</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '13'}">전남</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '14'}">경남</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '15'}">부산</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '16'}">울산</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '17'}">대구</c:when>
										  			<c:when test="${matchSuccessMemberMap.REGION eq '18'}">경북</c:when>
										  			<c:otherwise>-</c:otherwise>
										  		</c:choose>
										  		
										  	</div>
										  </td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchSuccessMemberMap.COMPANY }</div></td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchSuccessMemberMap.JOB }</div></td>
									    </tr>
										<tr>
										  <td colspan="3">
										  	<div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<span class="fa fa-user-o"></span>
										  		<c:if test="${matchSuccessMemberMap.GENDER eq 'male'}">남성<span class="glyphicon glyphicon-user"></span></c:if>
										  		<c:if test="${matchSuccessMemberMap.GENDER eq 'female'}">여성<span class="glyphicon glyphicon-user"></span></c:if>
										  		<br>${matchSuccessMemberMap.NICKNAME }
										  	</div>
										  </td>
										</tr>
										<tr>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchSuccessMemberMap.BIRTHYEAR }년생</div></td>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchSuccessMemberMap.BLOODTYPE }형</div></td>
										  <td>
										  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
										  		<c:choose>
										  			<c:when test="${matchSuccessMemberMap.STANCE eq '1'}">보수</c:when>
										  			<c:when test="${matchSuccessMemberMap.STANCE eq '2'}">중도보수</c:when>
										  			<c:when test="${matchSuccessMemberMap.STANCE eq '3'}">중도</c:when>
										  			<c:when test="${matchSuccessMemberMap.STANCE eq '4'}">중도진보</c:when>
										  			<c:when test="${matchSuccessMemberMap.STANCE eq '5'}">진보</c:when>
										  			<c:otherwise>-</c:otherwise>
										  		</c:choose>
										  		
										  	</div>
										  </td>
										</tr>
										<tr>
										  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchSuccessMemberMap.NAME }</div></td>
										  <td colspan="2"><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchSuccessMemberMap.MOBILE }</div></td>
										</tr>
									</table>
									<input type="button" value="더 알아보러 가기" onclick="goDetail(${matchSuccessMemberMap.MEMBERNO})"/>
							</c:if>
								
						</c:when>
									
						<c:otherwise>
							<form id="loginFrm" name="loginFrm" method="post">
							<input type="hidden" name="contextPath" value="${pageContext.request.contextPath}">
								<div>
									<h3>진심을 담아<br>당신과 만나고 싶어요.</h3>
									<p>인연을 만날 땐 사진은 필요없습니다. <br>진실 된 당신의 이야기면 충분합니다.</p>
								</div>
								<div>
									<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-user"></i></div>
								    <div class="w3-rest">
								      <input class="w3-input w3-border" name="email" type="text" placeholder="Your Email">
								    </div>
								</div>
								<div>
									<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-lock"></i></div>
								    <div class="w3-rest">
								      <input class="w3-input w3-border" name="pw" type="password" placeholder="Your Password">
								    </div>
								</div>
								<div style="margin-top: 10px;">
									<ul class="actions">
										<li><input type="button" value="로그인" onclick="validSubmit();"/></li>
										<li><a href="${pageContext.request.contextPath}/users/joinform" class="button alt">회원가입</a></li>
									</ul>
								</div>
							</form>
						</c:otherwise>
						
					</c:choose>
				
				<c:if test="${!empty myMemberMap }">
					<br>
					<span class="glyphicon glyphicon-send"></span> 보유 비행기  ${myMemberMap.CASH } 비행기
				</c:if>
			
			</c:otherwise>
	  	</c:choose>
			
		
		</div>
	</div>
</section>
<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>