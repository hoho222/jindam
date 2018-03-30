<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/include/gnb.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
</head>

<body class="homepage">
	<div id="page-wrapper">
	
		<!-- Header -->
		<div id="header-wrapper">
			<div id="header">

				<!-- Logo -->
					<h1 style="color:white;"><a href="${pageContext.request.contextPath}/index">진담</a></h1>

				<!-- Nav -->
					<nav id="nav">
						<c:choose>
							<c:when test="${sessionNo ne 'null' && sessionEmail ne 'null'}">
								<ul>
									<li><a href="#">${sessionEmail }</a></li>
									<li class="current"><a href="${pageContext.request.contextPath}/notices">공지사항</a></li>
									<c:if test="${sessionAuth eq 'T'}">
									<li>
										<a href="#">마이페이지</a>
										<ul>
											<li><a href="${pageContext.request.contextPath}/users/userinfo/${sessionNo}">매칭을 위한 개인정보 수정</a></li>
											<li><a href="${pageContext.request.contextPath}/users/mypage/${sessionNo}">기본정보 수정</a></li>
										</ul>
									</li>
									<li><a href="${pageContext.request.contextPath}/messages/${sessionNo}">메시지함</a></li>
									<li><a href="${pageContext.request.contextPath}/items">아이템몰</a></li>
									</c:if>
									<li><a href="${pageContext.request.contextPath}/users/logout">로그아웃</a></li>
								</ul>
							</c:when>	
					
							<c:otherwise>
								<ul>
									<li class="current"><a href="${pageContext.request.contextPath}/notices">공지사항</a></li>
									<li><a href="${pageContext.request.contextPath}/index">로그인</a></li>
									<li><a href="${pageContext.request.contextPath}/users/joinform">회원가입</a></li>
								</ul>
							</c:otherwise>
						</c:choose>
					</nav>
			</div>
		</div>
		
		
		
