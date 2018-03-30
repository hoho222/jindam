<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>진담 ADMIN</title>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Tell the browser to be responsive to screen width -->
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<!-- Bootstrap 3.3.6 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" type="text/css" />  
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
<!-- Ionicons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
<!-- Theme style -->
<link rel="stylesheet" type="text/css" href="/LOLweb/css/AdminLTE.min.css" />
<link rel="stylesheet" type="text/css" href="/LOLweb/css/skins/skin-blue.min.css" />

<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

<link rel="stylesheet" href="/LOLweb/css/skins/_all-skins.min.css">
<!-- iCheck -->
<link rel="stylesheet" href="/LOLweb/css/blue.css">
<!-- Morris chart -->
<link rel="stylesheet" href="/LOLweb/css/morris.css">
<!-- jvectormap -->
<link rel="stylesheet" href="/LOLweb/css/jquery-jvectormap-1.2.2.css">
<!-- bootstrap wysihtml5 - text editor -->
<link rel="stylesheet" href="/LOLweb/css/bootstrap3-wysihtml5.min.css">


<c:set var="sessionAdminId"><%= (String)session.getAttribute("adminLoginId") %></c:set>
<c:set var="sessionAdminName"><%= (String)session.getAttribute("adminLoginName") %></c:set>
<c:set var="sessionAdminNo"><%= session.getAttribute("adminLoginNo") %></c:set>


</head>

<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  <!-- Main Header -->
  <header class="main-header">

    <!-- Logo -->
    <a href="${pageContext.request.contextPath}/admin/index" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>A</b>LT</span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b>Admin</b>진담</span>
    </a>

    <!-- Header Navbar -->
    <nav class="navbar navbar-static-top" role="navigation">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>
      <!-- Navbar Right Menu -->
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
          
          <!-- User Account Menu -->
          <li class="dropdown user user-menu">
            <!-- Menu Toggle Button -->
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <!-- hidden-xs hides the username on small devices so only the image appears. -->
              <span class="hidden-xs">
              	<c:choose>
					<c:when test="${sessionAdminId != 'null' && sessionAdminName != 'null'}">
						<c:out value="${adminLoginId}"></c:out>&nbsp;(<c:out value="${adminLoginName}"></c:out>)
					</c:when>
					<c:otherwise>
					</c:otherwise>
				</c:choose>
              </span>
            </a>
            <ul class="dropdown-menu">
              <!-- The user image in the menu -->
              <li class="user-header">
                <p>
                  <c:choose>
					<c:when test="${sessionAdminId != 'null' && sessionAdminName != 'null'}">
						<c:out value="${adminLoginId}"></c:out>&nbsp;(<c:out value="${adminLoginName}"></c:out>)
					</c:when>
					<c:otherwise>
					</c:otherwise>
				  </c:choose>
                  <small>어드민ㅎㅎ</small>
                </p>
              </li>
              <!-- Menu Body -->
              <li class="user-body">
                <div class="row">
                  <div class="col-xs-4 text-center">
                    <a href="#">Followers</a>
                  </div>
                  <div class="col-xs-4 text-center">
                    <a href="#">Sales</a>
                  </div>
                  <div class="col-xs-4 text-center">
                    <a href="#">Friends</a>
                  </div>
                </div>
                <!-- /.row -->
              </li>
              <!-- Menu Footer-->
              <li class="user-footer">
                <div class="pull-left">
                  <a href="#" class="btn btn-default btn-flat">Profile</a>
                </div>
                <div class="pull-right">
                  <a href="#" class="btn btn-default btn-flat">Sign out</a>
                </div>
              </li>
            </ul>
          </li>
          
          <!-- sign out -->
          <li>
            <a href="${pageContext.request.contextPath}/admin/logout">Sign out</a>
          </li>
          
          <!-- Control Sidebar Toggle Button -->
          <li>
            <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>
          </li>
          
        </ul>
      </div>
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">

    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">

      <!-- Sidebar user panel (optional) -->
      <div class="user-panel">
      	<div class="pull-left image">
      		<img src="/LOLweb/resources/imgs/logo.png" class="img-circle" alt="logo Image">
      	</div>
        <div class="pull-left info">
          <p>
          	<c:choose>
				<c:when test="${sessionAdminId != 'null' && sessionAdminName != 'null'}">
					<c:out value="${adminLoginId}"></c:out>&nbsp;(<c:out value="${adminLoginName}"></c:out>)
				</c:when>
				<c:otherwise>
				</c:otherwise>
		  	</c:choose>
          </p>
          <!-- Status -->
          <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
        </div>
      </div>

      <!-- search form (Optional) -->
      <form action="#" method="get" class="sidebar-form">
        <div class="input-group">
          <input type="text" name="q" class="form-control" placeholder="Search...">
              <span class="input-group-btn">
                <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
                </button>
              </span>
        </div>
      </form>
      <!-- /.search form -->

      <!-- Sidebar Menu -->
      <ul class="sidebar-menu">
        <li class="header">관리 메뉴</li>
        
        <li><a href="${pageContext.request.contextPath}/admin/index"><i class="fa fa-th"></i> <span>Home</span></a></li>
        <li><a href="${pageContext.request.contextPath}/admin/items"><i class="fa fa-files-o"></i> <span>아이템 관리</span></a></li>
        <li><a href="${pageContext.request.contextPath}/admin/notices"><i class="fa fa-edit"></i> <span>공지사항 관리</span></a></li>
        
        <li class="treeview">
          <a href="#"><i class="fa fa-link"></i> <span>회원관리</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="${pageContext.request.contextPath}/admin/memberpass"><i class="fa fa-circle-o">  심사를 기다리는 회원</i></a></li>
            <li><a href="#"><i class="fa fa-circle-o">  어드민 회원</i></a></li>
          </ul>
        </li>
        
        <li class="header">Copyright &copy; 경호원 All rights reserved.</li>
        
      </ul>
      <!-- /.sidebar-menu -->
    </section>
    <!-- /.sidebar -->
    
    
  </aside>

</html>