<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/navi.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
function validSubmit(result, memberNo){
	var f = document.frm;
	
	if(result == '승인'){
		f.result.value = "pass";
	} else if(result == '반려'){
		if(f.failReason.value == ""){
			alert("반려시에는 반려 이유를 작성해주세요.");
			f.failReason.focus();
			return false;
		}
		
		f.result.value = "fail";
		
	} else {
		alert("뭔가 이상합니다! 다시 눌러주세요");
		return false;
	}
	
	if(confirm("회원No가 "+memberNo+"인 해당 회원정보를 "+result+"하시겠습니까?")){
		$.ajax({
		   type : 'POST',  
		   data:"result="+ f.result.value + "&memberNo="+memberNo + "&failReason="+f.failReason.value,
		   dataType : 'text',
		   url : 'memberpass',  
		   success : function(rData, textStatus, xhr) {
			   if(rData == "true"){
				   //회원정보 심사 성공하면 페이지 리로드
				   alert(result+" 성공!");
				   location.reload();
			   }else if(rData == "false"){
				   alert("심사 실패! 다시 시도해주세요!!");
			   }
		   },
		   error : function(xhr, status, e) {  
		   		alert("심사처리를 할 수 없습니다!");
		   		console.log("심사처리 에러 원인 >> "+e);
		   }
		}); 
	}
}
</script>

</head>

<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        심사 대기 회원
        <small>심사를 기다리는 회원 목록입니다.</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i>ADMIN</a></li>
        <li class="active">MEMBER</li>
        <li class="active">READYPASS</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

	<center>
		<form name="frm" method="post">
		
			<table class="w3-table-all">
			    <thead>
					<tr class="w3-blue">
						<th>회원No</th>
						<th>이메일</th>
						<th>이름</th>
						<th>생년</th>
						<th>폰번</th>
						<th>닉넴</th>
						<th>지역</th>
						<th>사회적 역할</th>
						<th>소속</th>
						<th>혈액형</th>
						<th>메뉴</th>
						<th>반려이유</th>
					</tr>
			    </thead>
			    <c:choose>
			        <c:when test="${fn:length(list) > 0}">
			            <c:forEach items="${list }" var="row">
			            	<input type="hidden" name="result"/>
			                <tr>
			                	<td>${row.MEMBERNO }</td>
			                    <td>${row.EMAIL }</td>
			                    <td>${row.NAME }</td>
			                    <td>${row.BIRTHYEAR }</td>
			                    <td>${row.MOBILE }</td>
			                    <td>${row.NICKNAME }</td>
			                    <td>${row.REGION }</td>
			                    <td>${row.RELIGION }</td>
			                    <td>${row.COMPANY}</td>
			                    <td>${row.BLOODTYPE }</td>
			                    <td>
			                    	<input type="button" value="승인" onclick="validSubmit(this.value, ${row.MEMBERNO})"/>
			                    	<br>
			                    	<input type="button" value="반려" onclick="validSubmit(this.value, ${row.MEMBERNO})"/>
			                    </td>
			                    <td>
			                    	<textarea id="failReason" placeholder="반려 사유가 있는경우에만 작성"></textarea>
			                    </td>
		                    </tr>
		                </c:forEach>
		            </c:when>
		            <c:otherwise>
		                <tr>
		                    <td colspan="4">심사를 대기중인 회원이 없습니다.</td>
		                </tr>
		            </c:otherwise>
		        </c:choose>
			</table>
		</form>
	</center>
	
	</section>
	<!-- /.content -->
</div>

<%@ include file="/WEB-INF/include/bottom.jsp" %>
</html>