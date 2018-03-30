<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<style type="text/css">
    
/*TAB CSS*/


</style>


 <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
 <script type="text/javascript">
 function matchSuccess(myMemberNo, matchSuccessMemberNo, method){
	if(myMemberNo > 0 && matchSuccessMemberNo > 0 ){
		$.ajax({
		   type : 'POST',  
		   data:"myMemberNo="+ myMemberNo + "&matchSuccessMemberNo=" + matchSuccessMemberNo + "&method=" + method,
		   dataType : 'text',
		   url : 'matchsuccess',  
		   success : function(rData, textStatus, xhr) {
			  
			   if(rData == "true"){
					alert("수락성공!");
					window.location.reload();
			   }else if(rData == "false"){
				   if(method == "cash"){
					   if(confirm("보유하고 계신 비행기가 부족합니다.\n아이템몰로 이동하시겠습니까?")){
				    		location.replace("${pageContext.request.contextPath}/items");
				    	} else {
				    		
				    	}
				   } else if(method == "item"){
					   if(confirm("해당 기능에 맞는 아이템을 갖고 있지 않습니다!\n아이템몰로 이동하시겠습니까?")){
				    		location.replace("${pageContext.request.contextPath}/items");
				    	} else {
				    		
				    	}
				   }
			   }
		   },
		   error : function(xhr, status, e) {  
		   		alert("수락하기 처리도중 문제가 발생했습니다.");
		   		console.log("문제 원인 >> "+e);
		   }
		});  
	}
	
}
 
 $(document).ready(function() {

     //When page loads...
     $(".tab_content").hide(); //Hide all content
     $("ul.tabs li:first").addClass("active").show(); //Activate first tab
     $(".tab_content:first").show(); //Show first tab content

     //On Click Event
     $("ul.tabs li").click(function() {

         $("ul.tabs li").removeClass("active"); //Remove any "active" class
         $(this).addClass("active"); //Add "active" class to selected tab
         $(".tab_content").hide(); //Hide all tab content

         var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
         $(activeTab).fadeIn(); //Fade in the active ID content
         return false;
     });

 });
 </script>


</head>

<!-- Main -->
<section id="intro" class="container">
<div id="main-wrapper">	
	<div id="wrapper">    
	    <!--탭 메뉴 영역 -->
	    <ul class="tabs">
	        <li style="font-size: 13px;"><a href="#tab1">받은 메세지함</a></li>
	        <li style="font-size: 13px;"><a href="#tab2">보낸 메세지함</a></li>
	    </ul>
	
	    <!--탭 콘텐츠 영역 -->
	    <div class="tab_container">
	
	        <div id="tab1" class="tab_content">
	            <!--Content-->
	            <h1>받은 메세지함</h1>
	            <c:choose>
	        		<c:when test="${fn:length(receiptMsgList) > 0}">
		            	<c:forEach items="${receiptMsgList }" var="row" varStatus="vs">
		            		<div class="container" style="padding-top:20px;text-align:center;">
		            		
		            			<c:if test="${row.KIND eq 'like'}">
		            				<div class="w3-border w3-round-xlarge" style="background-color: white;box-shadow: 5px 5px 2px grey;">
		            					<div class="panel-body" >
		            						<table>
		            							<tr>
	                								<td rowspan="3"><span class="glyphicon glyphicon-heart-empty" style="font-size:30px;"></span></td>
	                								<td style="font-size:15px;">${row.SENDER_NICKNAME }</td>
	                							</tr>
	                							<tr>
	                								<td colspan="2" style="font-size:12px;">관심이 있어요</td>
	                							</tr>
	                							<tr>
	                								<td colspan="2" style="font-size:10px;">${fn:substring(row.SENDDATE, 0, 10)}<td>
	                							</tr>
	                						</table>
	                					</div>
	                				</div>
	                			</c:if>
	                			
	                			<c:if test="${row.KIND eq 'common'}">
					                <div class="w3-border w3-round-xlarge" style="background-color:#ff495b2b; box-shadow: 5px 5px 2px grey;" onclick="document.getElementById('detailModal${vs.index}').style.display='block'" style="cursor:pointer;">
				                  		<div class="panel-body" >
				                  			<table>
		            							<tr>
	                								<td rowspan="3"><span class="glyphicon glyphicon-heart" style="font-size:30px;"></span></td>
	                								<td style="font-size:15px;">${row.SENDER_NICKNAME }</td>
	                							</tr>
	                							<tr>
	                								<td colspan="2" style="font-size:12px;">${row.CONTENTS }</td>
	                							</tr>
	                							<tr>
	                								<td colspan="2" style="font-size:10px;">${fn:substring(row.SENDDATE, 0, 10)}<td>
	                							</tr>
	                						</table>
				                		</div>
				                	</div>
				                	
				                	<div id="detailModal${vs.index}" class="w3-modal">
									    <div class="w3-modal-content">
									      <div class="w3-container" style="padding-top:20px;">
									        <span onclick="document.getElementById('detailModal${vs.index}').style.display='none'" class="w3-button w3-display-topright">&times;</span>
									        
									        <div style="padding: 5px 5px 15px 5px;">
									        	<h4>받은 메세지</h4>
										        <p style="font-size: 13px;">
											        <strong>${row.SENDER_NICKNAME }</strong>님이 보낸 메세지 입니다.<br>
											        읽어보신 후, 수락 여부를 결정해주세요.<br>
											        <div style="border: 1px solid grey;border-radius: 1em;font-size: 14px; padding: 5px 5px 5px 5px; margin:15px 15px 15px 15px;">${row.CONTENTS }</div>
										        </p>
										        
										        <input type="button" value="수락하기(-50 비행기)" style="font-size: 15px;"  onclick="matchSuccess(${sessionNo}, ${row.SENDER_NO}, 'cash')"/>
										        <input type="button" value="수락하기(아이템 사용)" style="font-size: 15px;" onclick="matchSuccess(${sessionNo}, ${row.SENDER_NO}, 'item')"/>
										        <span class="button alt" style="font-size: 15px;" onclick="document.getElementById('detailModal${vs.index}').style.display='none'">조금 더 생각해 볼게요 :)</span>
									        </div>
									        
									      </div>
									    </div>
								  	</div>
			                	</c:if>
			                	
			                </div>
		            	</c:forEach>
	            	</c:when>
	            </c:choose>
	        </div>
	        
	        <div id="tab2" class="tab_content">
	           <!--Content-->
	           <h1>보낸 메세지함</h1>
	           <c:choose>
	        		<c:when test="${fn:length(sendMsgList) > 0}">
		            	<c:forEach items="${sendMsgList }" var="row" varStatus="vs">
		            		<div class="container" style="padding-top:20px;text-align:center;">
		            		
		            		<c:if test="${row.KIND eq 'like'}">
	           				<div class="w3-border w3-round-xlarge" style="background-color: white;box-shadow: 5px 5px 2px grey;">
	           					<div class="panel-body" >
	           						<table>
            							<tr>
               								<td rowspan="3"><span class="glyphicon glyphicon-heart-empty" style="font-size:30px;"></span></td>
               								<td style="font-size:15px;">${row.RECIPIENT_NICKNAME }</td>
               							</tr>
               							<tr>
               								<td colspan="2" style="font-size:12px;">관심이 있어요</td>
               							</tr>
               							<tr>
               								<td colspan="2" style="font-size:10px;">${fn:substring(row.SENDDATE, 0, 10)}<td>
               							</tr>
               						</table>
	           					</div>
	           				</div>
	           				</c:if>
	           				
	           				<c:if test="${row.KIND eq 'common'}">
	           				<div class="w3-border w3-round-xlarge" style="background-color: #34495e54;box-shadow: 5px 5px 2px grey;" onclick="document.getElementById('detailModal2${vs.index}').style.display='block'">
	           					<div class="panel-body" >
	           						<table>
            							<tr>
               								<td rowspan="3"><span class="glyphicon glyphicon-heart" style="font-size:30px;"></span></td>
               								<td style="font-size:15px;">${row.RECIPIENT_NICKNAME }</td>
               							</tr>
               							<tr>
               								<td colspan="2" style="font-size:12px;">${row.CONTENTS }</td>
               							</tr>
               							<tr>
               								<td colspan="2" style="font-size:10px;">${fn:substring(row.SENDDATE, 0, 10)}<td>
               							</tr>
               						</table>
	           					</div>
	           				</div>
	           				</c:if>
	              			
	              			<div id="detailModal2${vs.index}" class="w3-modal">
							    <div class="w3-modal-content">
							      <div class="w3-container">
							        <span onclick="document.getElementById('detailModal2${vs.index}').style.display='none'" class="w3-button w3-display-topright">&times;</span>
							        
							        <div style="padding: 5px 5px 15px 5px;">
							        	<h4>보낸 메세지</h4>
								        <p style="font-size: 13px;">
									        <strong>${row.RECIPIENT_NICKNAME }</strong>님께 보낸 메세지 입니다.<br>
									        <div style="border: 1px solid grey;border-radius: 1em;font-size: 14px; padding: 5px 5px 5px 5px; margin:15px 15px 15px 15px;">${row.CONTENTS }</div>
								        </p>
								        
								        <span class="button alt" style="font-size: 15px;" onclick="document.getElementById('detailModal2${vs.index}').style.display='none'">닫기</span>
							        </div>
							        
							      </div>
							    </div>
						  	</div>
	              			
	              			</div>
		            	</c:forEach>
	            	</c:when>
	            </c:choose> 
	        </div>
	
	    </div>

	</div>
		
</div>
</section>
<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>