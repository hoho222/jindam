<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>

<div class="container" style="padding:10% 0 10% 0; text-align:center;">
	<div class="w3-border">
		<div class="panel-heading" style="background-color: #f9d9e4;">
			<h3><span style="font-size:xx-large;">${noticeMap.TITLE}</span></h3>
		</div>
		<div class="panel-body">
			${noticeMap.CONTENTS}
		</div>
		<p style="text-align:right;font-size:15px;color:gray;"><span class="glyphicon glyphicon-eye-open">${noticeMap.HIT_CNT}</p>
		<p style="text-align:right;font-size:15px;color:gray;">${noticeMap.WRITER_ID}</p>
		<p style="text-align:right;font-size:15px;color:gray;"><span class="glyphicon glyphicon-pencil">${fn:substring(noticeMap.REGDATE,0,10)}</p>
		
	</div>
</div>

<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>