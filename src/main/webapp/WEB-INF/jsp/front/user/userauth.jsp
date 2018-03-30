<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1" />
</head>

<!-- jQuery -->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<!-- iamport.payment.js -->
<script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.5.js"></script>

<script type="text/javascript">
IMP.init('imp21083653');

//IMP.certification(param, callback) 호출
IMP.certification({ // param
	min_age: 19	// 만 나이로 최소 나이 제한
}, function (rsp) { // callback
	if (rsp.success) { // 인증 성공 시
        $.ajax({
 		   type : 'POST',  
 		   data: { imp_uid: rsp.imp_uid },
 		   dataType: "text",
 		   url : '',  
 		   success : function(rData, textStatus, xhr) {
 			  if(rData == "success") {
					alert("본인인증에 성공하셨습니다!");
					location.replace("${pageContext.request.contextPath}/index");
			  } else if(rData == "fail_dup"){
				    alert("본인인증 실패! 이미 해당 정보를 가진 고객이 있습니다.");
					location.replace("${pageContext.request.contextPath}/index");
			  } else {
				    alert("본인인증 실패! 다시 시도해주세요.");
					location.replace("${pageContext.request.contextPath}/index");
			  }
 		   },
 		   error : function(xhr, status, e) {  
 		   		alert("본인인증 처리도중 문제가 발생했습니다..");
 		   		console.log("문제 원인 >> "+e);
 		   }
 		});
    } else {
        alert("인증에 실패하였습니다. 에러 내용: " +  rsp.error_msg);
    }
});

</script>

<body>

</body>
</html>