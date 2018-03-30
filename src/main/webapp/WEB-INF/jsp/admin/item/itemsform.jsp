<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/navi.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
function validSubmit() {
	var f = document.itemFrm;
	
	f.action="items"
	f.submit();
}
</script>

</head>
<!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        아이템 등록하기
        <small>아이템을 등록하세요.</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i>ADMIN</a></li>
        <li class="active">ITEM REG</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
		<form name="itemFrm" method="POST" enctype="multipart/form-data">
			아이템명 : <input type="text" name="name" maxlength="100" required/><br>
			아이템 소개 : <input type="text" name="explanation" maxlength="1000" required/><br>
			해당 아이템 구매 시, 필요한 비행기 수 : <input type="text" name="needCash" placeholder="숫자만 입력" required/>개<br>
			아이템 유형 :
			<select name="kind">
				<option value="matchSuccess">메세지 전송 및 수락</option>
			</select>
			해당 아이템 구매 시, 필요한 현금(원) : <input type="text" name="needRealCash" placeholder="숫자만 입력" required/>원<br>
			사용가능한 갯수 : <input type="text" name="possibleUseCnt" placeholder="숫자만 입력, 입력안할 시 1개로 셋팅" required/>개<br>
			아이템 이미지 <input type="file" id="fileuploaderResult" name="fileuploaderResult" required/>
			<input type="submit" class="btn btn-default btn-sm" value="등록" onclick="validSubmit();"/>
		</form>

	</section>
    <!-- /.content -->
  </div>

<%@ include file="/WEB-INF/include/bottom.jsp" %>

</html>