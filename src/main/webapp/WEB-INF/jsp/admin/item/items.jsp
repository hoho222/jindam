<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@ include file="/WEB-INF/include/navi.jsp" %>

</head>
<body>

<!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        아이템 관리
        <small>아이템을 관리하세요.</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i>ADMIN</a></li>
        <li class="active">ITEM</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

		<center>
			<table class="boardlist" style="border:1px solid #ccc"  align="center">
				<!-- <colgroup>
				    <col width="15%"/>
				    <col width="20%"/>
				    <col width="30%"/>
				    <col width="20%"/>
				    <col width="20%"/>
				    <col width="40%"/>
				</colgroup> -->
				<thead>
				    <tr>
				    	<th>이미지</th>
				        <th>아이템명</th>
				        <th>아이템 설명</th>
				        <th>사용 가능한 갯수</th>
				        <th>해당 아이템 구매 시 필요 비행기 수</th>
				        <th>해당 아이템 구매 시 필요 현금(원)</th>
				        <th>등록일</th>
				    </tr>
				</thead>
				<tbody>
			    	<c:choose>
				        <c:when test="${fn:length(list) > 0}">
				            <c:forEach items="${list }" var="row">
				                <tr>
				                	<td><img alt="${row.IMG_ORIGIN_FILENAME }" src="<c:url value='/resources/item_imgs/${row.IMG_STORED_FILENAME }'/>" onerror='this.src="/LOLweb/resources/imgs/cannotloadimg.jpg"' style="width: 50px; height: 50px;" ></td>
				                    <td>${row.NAME}</td>
				                    <td>${row.EXPLANATION }</td>
				                    <td>${row.POSSIBLE_USE_CNT}개</td>
				                    <td>${row.NEED_CASH }개</td>
				                    <td>${row.NEED_REAL_CASH }원</td>
				                    <td>${fn:substring(row.REGDATE, 0, 10) }</td>
			                    </tr>
			                </c:forEach>
			            </c:when>
			            <c:otherwise>
			                <tr>
			                    <td colspan="5">등록된 아이템이 없습니다.</td>
			                </tr>
			            </c:otherwise>
			        </c:choose>
			        
			    </tbody>
			</table>
		</center>

<a href="${pageContext.request.contextPath}/admin/itemsform"><input type="button" class="btn btn-primary" value="아이템 등록"/></a>

	</section>
    <!-- /.content -->
  </div>

<%@ include file="/WEB-INF/include/bottom.jsp" %>

</html>