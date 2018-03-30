<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">

//좋아요,저와 맞지 않아요,더 알아가고 싶어요 누른 경우 처리
function expressMind(myMemberNo, matchMemberNo, mind, contents, payMethod){
	
	if(mind == 'love'){
		contents = document.getElementById("msgContents").value;
	}
	
	if(myMemberNo > 0 && matchMemberNo > 0 ){
		$.ajax({
		   type : 'POST',  
		   data:"myMemberNo="+ myMemberNo + "&matchMemberNo=" + matchMemberNo + "&mind=" + mind + "&contents=" + contents + "&payMethod=" + payMethod,
		   dataType : 'text',
		   url : 'expressmind',  
		   success : function(rData, textStatus, xhr) {
			   if(rData == "true"){
					alert("성공!");
					window.location.reload();
			   } else if(rData == "fail1"){
				   alert("실패 하였습니다. 이미 해당 유저가 님의 매칭상대가 아닙니다.");
				   window.location.reload();
			   } else if(rData == "fail2"){
				   alert("실패 하였습니다. 해당유저가 소개중단 상태입니다.");
				   window.location.reload();
			   } else if(rData == "fail3"){
				   if(confirm("보유한 비행기가 부족하여 실패하였습니다.\n아이템몰로 이동하시겠습니까?")){
					   location.replace("${pageContext.request.contextPath}/items");
				   }
			   } else if(rData == "fail4"){
				   if(confirm("사용가능한 아이템 없어 실패하였습니다.\n아이템몰로 이동하시겠습니까?")){
					   location.replace("${pageContext.request.contextPath}/items");
				   }
			   }
		   },
		   error : function(xhr, status, e) {  
		   		alert("처리도중 문제가 발생했습니다.");
		   		console.log("문제 원인 >> "+e);
		   }
		});  
	}
	
}

//인연끊기
function matchFail(myMemberNo, matchSuccessMemberNo){
	var matchFailReason = document.getElementById("matchFailReason").value;
	
	if(myMemberNo > 0 && matchSuccessMemberNo > 0 ){
		$.ajax({
		   type : 'POST',  
		   data:"myMemberNo="+ myMemberNo + "&matchSuccessMemberNo=" + matchSuccessMemberNo + "&matchFailReason=" + matchFailReason,
		   dataType : 'text',
		   url : 'matchfail',  
		   success : function(rData, textStatus, xhr) {
			  
			   if(rData == "true"){
					alert("다음 분과의 인연을 기대합니다:)");
					window.location.href = "/LOLweb/index";
			   }else if(rData == "false"){
				    alert("이미 상대방이 님과의 인연을 끊었습니다T^T");
				    window.location.href = "/LOLweb/index";
			   }
		   },
		   error : function(xhr, status, e) {  
		   		alert("처리도중 문제가 발생했습니다.");
		   		console.log("문제 원인 >> "+e);
		   }
		});  
	}
}
</script>

</head>

<!-- Main -->
<section id="intro" class="container">
	<div id="main-wrapper">							
		<!-- 현재 매칭유저 정보 상세 -->
		<c:choose>
		<c:when test="${myMemberMap.MATCH_MEMBERNO ne null || myMemberMap.MATCH_SUCCESS_MEMBERNO ne null}">
		<div>
			<h2>현재 매칭유저 정보</h2>
			<table>
				<tr>
				  <td colspan="3">
				  	<div style="padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
				  		<span class="glyphicon glyphicon-user" style="font-size: 80px;"></span>
				  		
				  		<c:if test="${!empty myMemberMap && myMemberMap.MATCH_SUCCESS_MEMBERNO eq null && myMemberMap.MATCHSUCCESSDATE eq null }">
				  		
				  		<!-- 좋아요 표현 했으면 채워진 하트 -->
				  		<c:if test="${myMemberMap.EXPRESS_STATUS eq 'L'}">
				  		<br><span class="glyphicon glyphicon-heart" style="font-size: 25px;"></span>
				  		</c:if>
				  		
				  		<!-- 관심 표현 안했거나, 저와 맞지 않아요 했을경우 빈 하트 -->
				  		<c:if test="${myMemberMap.EXPRESS_STATUS ne 'L'}">
				  		<br><span class="glyphicon glyphicon-heart-empty" style="font-size: 25px;"></span>
				  		</c:if>
				  		
				  		<!-- 상대방이 나한테 좋아요 표현 했으면 채워진 별 -->
				  		<c:if test="${matchMemberMap.EXPRESS_STATUS eq 'L'}">
				  		<br><span class="glyphicon glyphicon-star" style="font-size: 25px;"></span>
				  		</c:if>
				  		
				  		<!-- 상대방이 나한테 관심 표현 안했거나, 저와 맞지 않아요 했을경우 빈 별 -->
				  		<c:if test="${matchMemberMap.EXPRESS_STATUS ne 'L'}">
				  		<br><span class="glyphicon glyphicon-star-empty" style="font-size: 25px;"></span>
				  		</c:if>
				  		
				  		</c:if>
				  		
				  		<br>${matchMemberInfoMap.NICKNAME }
				  	</div>
				  </td>
				</tr>
				<tr>
				  <td>
				  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
				  		<c:choose>
				  			<c:when test="${matchMemberInfoMap.REGION eq '1'}">인천</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '2'}">경기 서남</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '3'}">경기 서북</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '4'}">서울</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '5'}">경기 동북</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '6'}">경기 동남</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '7'}">강원</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '8'}">충북</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '9'}">대전</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '10'}">충남</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '11'}">전북</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '12'}">광주</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '13'}">전남</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '14'}">경남</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '15'}">부산</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '16'}">울산</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '17'}">대구</c:when>
				  			<c:when test="${matchMemberInfoMap.REGION eq '18'}">경북</c:when>
				  			<c:otherwise>-</c:otherwise>
				  		</c:choose>
				  		
				  	</div>
				  </td>
				  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberInfoMap.COMPANY }</div></td>
				  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberInfoMap.JOB }</div></td>
			    </tr>
				<tr>
				  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberInfoMap.BIRTHYEAR }년생</div></td>
				  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberInfoMap.BLOODTYPE }형</div></td>
				  <td>
				  	<div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">
				  		<c:choose>
				  			<c:when test="${matchMemberInfoMap.STANCE eq '1'}">보수</c:when>
				  			<c:when test="${matchMemberInfoMap.STANCE eq '2'}">중도보수</c:when>
				  			<c:when test="${matchMemberInfoMap.STANCE eq '3'}">중도</c:when>
				  			<c:when test="${matchMemberInfoMap.STANCE eq '4'}">중도진보</c:when>
				  			<c:when test="${matchMemberInfoMap.STANCE eq '5'}">진보</c:when>
				  			<c:otherwise>-</c:otherwise>
				  		</c:choose>
				  	</div>
				  </td>
				</tr>
				
				<!-- 성사된 소개팅 상대가 있을 경우 이름과 폰번호 노출 -->
				<c:if test="${!empty myMemberMap && myMemberMap.MATCH_SUCCESS_MEMBERNO ne null && myMemberMap.MATCHSUCCESSDATE ne null}">
				<tr>
				  <td><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberInfoMap.NAME }</div></td>
				  <td colspan="2"><div style="background-color: #EAEAEA; padding: 5px 0 5px 0; margin: 5px 5px 5px 5px;">${matchMemberInfoMap.MOBILE }</div></td>
				</tr>
				</c:if>
				
				<tr>
				  <td colspan="3">
				  	<div style="padding:10px 0 10px 0;">
				  		<strong>좋아하는 것</strong>
				  		<br><span  style="font-size: 12px;">${matchMemberInfoMap.FAVORITE_REASON }</span>
				  	</div>
				  </td>
				</tr>
				<tr>
				  <td colspan="3">
				  	<div style="padding:10px 0 10px 0;">
				  		<strong>성격</strong>
				  		<br><span  style="font-size: 12px;">${matchMemberInfoMap.INTRODUCE }</span>
				  	</div>
				  </td>
				</tr>
				<tr>
				  <td colspan="3">
				  	<div style="padding:10px 0 10px 0;">
				  		<strong>종교관</strong>
				  		<br><span  style="font-size: 12px;">${matchMemberInfoMap.RELIGION_THINK }</span>
				  	</div>
				  </td>
				</tr>
				
			</table>
			
			<c:if test="${!empty myMemberMap && myMemberMap.MATCH_SUCCESS_MEMBERNO eq null && myMemberMap.MATCHSUCCESSDATE eq null }">
			
			<input type="button" value="더 알아보고 싶어요" onclick="document.getElementById('MsgModal').style.display='block'"/>
			
			<c:if test="${!empty myMemberMap && myMemberMap.EXPRESS_STATUS eq 'B'}">
			<a onclick="document.getElementById('judgeModal').style.display='block'" class="button alt">좋아요/저와 맞지 않아요.</a>
			</c:if>
			
			</c:if>
			
			<c:if test="${!empty myMemberMap && myMemberMap.MATCH_SUCCESS_MEMBERNO ne null && myMemberMap.MATCHSUCCESSDATE ne null}">
			<a onclick="document.getElementById('matchFailModal').style.display='block'" class="button alt">저와 인연이 아닌 것 같습니다.</a>
			</c:if>
			
			<div id="judgeModal" class="w3-modal">
			    <div class="w3-modal-content">
			      <div class="w3-container">
			        <span onclick="document.getElementById('judgeModal').style.display='none'" class="w3-button w3-display-topright">&times;</span>
			        
			        <div style="padding: 5px 5px 15px 5px;">
				        <h4>관심 표현</h4>
				        <p style="font-size: 13px;">
				        	관심이 있다면 '좋아요' 표현을 눌러주세요.<br>
				        	관심이 없다면 '저와 맞지 않아요' 버튼을 눌러주세요.<br>
				        	상대방에게 넌지시 내 마음을 전달할 수 있습니다.
				        </p>
				        <input type="button" value="좋아요(+10 비행기)" style="font-size: 15px;" onclick="expressMind(${sessionNo}, ${matchMemberInfoMap.MEMBERNO}, 'like', '', '')"/>
				        <a onclick="expressMind(${sessionNo}, ${matchMemberInfoMap.MEMBERNO}, 'notlike', '', '')" class="button alt" style="font-size: 15px;">저와 맞지 않아요.(+10 비행기)</a>
			        </div>
			        
			      </div>
			    </div>
		  	</div>
		  	
		  	<div id="MsgModal" class="w3-modal">
			    <div class="w3-modal-content">
			      <div class="w3-container">
			        <span onclick="document.getElementById('MsgModal').style.display='none'" class="w3-button w3-display-topright">&times;</span>
			        
			        <div style="padding: 5px 5px 15px 5px;">
			        	<h4>더 알아보고 싶어요</h4>
				        <p style="font-size: 13px;">
				        	상대방을 조금 더 알아보기 위해 메세지를 보내주세요.<br>
				        	상대방에게 답장이 오면, 연락 할 수 있는 번호가 서로에게 제공됩니다.<br><br>
				        	<textarea id="msgContents" cols="20" rows="5" placeholder="내용을 입력해주세요."></textarea>
				        </p>
				        <br>
				        <input type="button" value="메세지 보내기(-50 비행기)" style="font-size: 15px;" onclick="expressMind(${sessionNo}, ${matchMemberInfoMap.MEMBERNO}, 'love', '', 'cash')"/>
				        <input type="button" value="메세지 보내기(아이템사용)" style="font-size: 15px;" onclick="expressMind(${sessionNo}, ${matchMemberInfoMap.MEMBERNO}, 'love', '', 'item')"/>
				        <span class="button alt" onclick="document.getElementById('MsgModal').style.display='none'" style="font-size: 15px;">조금 더 생각해 볼게요 :)</span>
			        </div>
			        
			      </div>
			    </div>
		  	</div>
		  	
		  	<div id="matchFailModal" class="w3-modal">
			    <div class="w3-modal-content">
			      <div class="w3-container">
			        <span onclick="document.getElementById('matchFailModal').style.display='none'" class="w3-button w3-display-topright">&times;</span>
			        
			        <div style="padding: 5px 5px 15px 5px;">
			        	<h4>인연끊기</h4>
				        <p style="font-size: 13px;">
				        	잘 되지 않은 이유를 작성해주세요.<br>
				        	조금 더 잘 맞는 인연을 소개시켜드립니다.
				        	<textarea id="matchFailReason" cols="20" rows="5" placeholder="내용을 입력해주세요."></textarea>
				        </p>
				        <br>
				        <input type="button" value="끊기" style="font-size: 15px;" onclick="matchFail(${sessionNo}, ${matchMemberInfoMap.MEMBERNO})"/>
				        <span class="button alt" style="font-size: 15px;" onclick="document.getElementById('matchFailModal').style.display='none'">조금 더 생각해 볼게요 :)</span>
			        </div>
			        
			      </div>
			    </div>
		  	</div>
			
		</div>
		</c:when>
		
		<c:otherwise>
		<h2><span style="font-size:20px;" class="glyphicon glyphicon-remove-sign"></span>&nbsp;현재 매칭됐거나 성사된 상대방이 없습니다</h2>
		</c:otherwise>
		</c:choose>
	</div>
</section>
<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>