<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>


<!-- Main -->
<section id="intro" class="container">
	<div id="main-wrapper">
		<h2>정보 심사</h2>
		<i class="glyphicon glyphicon-search" style="font-size:100px;"></i>
		<br>
		<br>
		정말 진실된 분을 소개 시켜드리기 위해 입력해주신 정보를 심사하는 과정이 필요합니다.
		심사기간은 약 1일 정도이고, 심사가 끝난 다음날부터 소개가 시작됩니다.
		<br>
		<br>
		<span class="button alt"><a href="${pageContext.request.contextPath}/index">메인페이지로 돌아가기</a></span>
	</div>
</section>
<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>