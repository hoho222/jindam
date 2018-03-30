<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/navi.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
function popupOpen(){
	var popUrl = "/LOLweb/matching";
	var popOption = "width=370, height=360, resizable=no, scrollbars=no, status=no;";
	window.open(popUrl,"",popOption);
}
</script>


</head>

<!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
       진담 어드민
        <small>Home 화면 입니다.</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i>ADMIN</a></li>
        <li class="active">HOME</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
		<input type="button" value="매칭 시키기" onclick="popupOpen();"/>          
    </section>
    <!-- /.content -->
  </div>

<%@ include file="/WEB-INF/include/bottom.jsp" %>

</html>