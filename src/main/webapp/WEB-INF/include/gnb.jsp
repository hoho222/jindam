<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!-- 외부 API -->
<!-- jQuery UI CSS파일  -->
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />  
<!-- jQuery 기본 js파일 -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>  
<!-- jQuery UI 라이브러리 js파일 -->
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>  



<!-- 부트스트랩 파일들은 받아놓긴 했지만(/doto/src/main/webapp/resources에 있음), 일단은 절대경로로 가져옴 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" type="text/css" />  
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
<!-- 부트스트랩 -->

<!-- css 파일 import -->
<link rel="stylesheet" type="text/css" href="<c:url value='/css/main.css'/>" />
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

<title>진심을담아 : 진담</title>
</head>

<c:set var="sessionNo"><%= session.getAttribute("loginNo") %></c:set>
<c:set var="sessionEmail"><%= (String)session.getAttribute("loginEmail") %></c:set>
<c:set var="sessionAuth"><%= (String)session.getAttribute("loginAuth") %></c:set>

<div id="gnb" style="background-color:#FFD8D8">

</div>

</html>