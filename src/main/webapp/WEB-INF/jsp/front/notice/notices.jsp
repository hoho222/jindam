<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<center>
	<div id="" class="section">
		<div class="s-container">
			<h2 class="section-title" style="transform: translateY(0px); opacity: 1;">공지사항</h2>
		</div>
	</div>
	
   	<c:choose>
        <c:when test="${fn:length(list) > 0}">
            <c:forEach items="${list }" var="row">
            	<div class="container" style="padding-top:20px;text-align:left;">
	                <div class="w3-border w3-round-xlarge" style="background-color: white;box-shadow: 5px 5px 2px grey;">
                  		<a href="${pageContext.request.contextPath}/notices/${row.IDX}">
	                  		<div class="panel-body" >
	           					<div><span style="font-size:20px; font-weight: bold;">${row.TITLE }</span></div>
	         					<div><span style="font-size:10px;">${fn:substring(row.REGDATE, 0, 10) }</span></div>
	           				
	           					<div><span class="glyphicon glyphicon-eye-open" style="font-size:10px;">&nbsp;${row.HIT_CNT }</span></div>
	           					<div><span class="glyphicon glyphicon-pencil" style="font-size:10px;">&nbsp;${row.WRITER_ID }</span></div>
	                		</div>
                		</a>
                	</div>
                </div>
           </c:forEach>
           
           
			<div class="pagination">
				<!-- 시작페이지가 1부터면 이전 표시("<<") ​ 안함 -->
				<c:if test="${start-1 ==0 }">
				</c:if>
				
				<!-- 시작페이지가 1이 아니면 << 이전 표시.  링크는 시작페이지가 6부터 10까지일 경우 5페이지를 가르킴 -->​
				<c:if test="${start-1!=0 }">
				<a href="${pageContext.request.contextPath}/notices?seq=${start-1}">&laquo;</a>
				</c:if>
				
				<!-- 5개씩 페이지 표시-->​
				<c:forEach var="i" begin="${start }" end="${end }">
					<c:choose>
						<c:when test="${seq == i}">
						<a class="active" href="notices?seq=${i}">${i}</a>
						</c:when>
						<c:otherwise>
						<a href="${pageContext.request.contextPath}/notices?seq=${i}">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				
				<!-- end페이지 번호가 5, 10 인데 전체 페이지 갯수가 end페이지 보다 크면 다음 페이징 바로가기 표시  (">>")​ .-->​
				<c:if test="${end % 5 == 0 && pageNum > end}">
					<a href="${pageContext.request.contextPath}/notices?seq=${end+1}">&raquo;</a>
				</c:if>
				
				<!-- 마지막 페이지 번호와 전체 페이지 번호가 같으면서 5개 단위가 아니면 다음바로가기 표시 안함 -->​​
				<c:if test="${end % 5 != 0 && end == pageNum }">
				</c:if>
			</div>
        </c:when>
        <c:otherwise>
        공지사항이 없습니다.
        </c:otherwise>
    </c:choose>
	        
</center>
<hr/>
<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>