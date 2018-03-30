<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<!-- jQuery -->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<!-- iamport.payment.js -->
<script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.5.js"></script>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<style type="text/css">
        
body {
    font-family:"Malgun Gothic";
    font-size: 0.8em;

}
/*TAB CSS*/

ul.tabs {
    margin: 0;
    padding: 0;
    float: left;
    list-style: none;
    height: 32px; /*--Set height of tabs--*/
    border-bottom: 1px solid #999;
    border-left: 1px solid #999;
    width: 100%;
}
ul.tabs li {
    float: left;
    margin: 0;
    padding: 0;
    height: 31px; /*--Subtract 1px from the height of the unordered list--*/
    line-height: 31px; /*--Vertically aligns the text within the tab--*/
    border: 1px solid #999;
    border-left: none;
    margin-bottom: -1px; /*--Pull the list item down 1px--*/
    overflow: hidden;
    position: relative;
    background: #e0e0e0;
}
ul.tabs li a {
    text-decoration: none;
    color: #000;
    display: block;
    font-size: 1.2em;
    padding: 0 20px;
    /*--Gives the bevel look with a 1px white border inside the list item--*/
    border: 1px solid #fff; 
    outline: none;
}
ul.tabs li a:hover {
    background: #ccc;
}
html ul.tabs li.active, html ul.tabs li.active a:hover  {
     /*--Makes sure that the active tab does not listen to the hover properties--*/
    background: #fff;
    /*--Makes the active tab look like it's connected with its content--*/
    border-bottom: 1px solid #fff; 
}

/*Tab Conent CSS*/
.tab_container {
    border: 1px solid #999;
    border-top: none;
    overflow: hidden;
    clear: both;
    float: left; 
    width: 100%;
    background: #fff;
}
.tab_content {
    padding: 20px;
    font-size: 1.2em;
}
</style>

<script type="text/javascript">
//아임포트
function buyItemForRealCash(myMemberNo, itemIdx, payMethod, payPrice, itemName){
	
	IMP.request_pay({ // param
	    pg: "danal_tpay",
	    pay_method: "card",
	    /* merchant_uid: "ORD20180131-0000011", */
	    name: itemName,
	    amount: payPrice,
	    buyer_email: "${sessionEmail}",
	}, function (rsp) { // callback
	    if (rsp.success) {
	        $.ajax({
	 		   type : 'POST',  
	 		   data:"myMemberNo="+ myMemberNo + "&itemIdx=" + itemIdx + "&payMethod=" + payMethod + "&payPrice=" + payPrice,
	 		   dataType : 'text',
	 		   url : 'items/purchase',  
	 		   success : function(rData, textStatus, xhr) {
	 			  
	 			   if(rData == "true"){
	 					alert("신용카드로 아이템 구매 성공! 구매하신 아이템은 보유 아이템 내역에서 확인하실 수 있습니다.");
	 					window.location.reload();
	 			   }else if(rData == "false"){
 				    	alert("신용카드 결제 실패!!!");
	 			   }
	 		   },
	 		   error : function(xhr, status, e) {  
	 		   		alert("아이템 구매 처리도중 문제가 발생했습니다.");
	 		   		console.log("문제 원인 >> "+e);
	 		   }
	 		});  
	    } else {
	    	alert("PG 결제실패 이유 > "+rsp.error_msg);
	    }
	});
}


function buyItemForCash(myMemberNo, itemIdx, payMethod, payPrice){
	if(myMemberNo > 0){
		$.ajax({
		   type : 'POST',  
		   data:"myMemberNo="+ myMemberNo + "&itemIdx=" + itemIdx + "&payMethod=" + payMethod + "&payPrice=" + payPrice,
		   dataType : 'text',
		   url : 'items/purchase',  
		   success : function(rData, textStatus, xhr) {
			  
			   if(rData == "true"){
					alert("비행기로 아이템 구매 성공! 구매하신 아이템은 보유 아이템 내역에서 확인하실 수 있습니다.");
					window.location.reload();
			   }else if(rData == "false"){
			    	if(confirm("보유하고 계신 비행기가 부족합니다!\n아이템몰로 이동하시겠습니까?")){
			    		location.replace("${pageContext.request.contextPath}/items");
			    	};
			   }
		   },
		   error : function(xhr, status, e) {  
		   		alert("아이템 구매 처리도중 문제가 발생했습니다.");
		   		console.log("문제 원인 >> "+e);
		   }
		});  
	}
}

$(document).ready(function() {

	//아임포트 설정
	IMP.init("imp21083653");
	
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

<section id="intro" class="container">
	<div id="main-wrapper">
	
	<!--탭 메뉴 영역 -->
    <ul class="tabs">
        <li style="font-size: 13px;"><a href="#tab1">아이템 구매</a></li>
        <li style="font-size: 13px;"><a href="#tab2">보유 아이템</a></li>
    </ul>
	
	<!--탭 콘텐츠 영역 -->
    <div class="tab_container">
        <div id="tab1" class="tab_content">
        	<h2>아이템 구매</h2>
        	
        	<c:if test="${!empty myMemberMap }">
				<br>
				<span class="glyphicon glyphicon-send"></span> 보유 비행기  ${myMemberMap.CASH } 비행기
			</c:if>
			
			<c:choose>
		        <c:when test="${fn:length(itemList) > 0}">
		            <c:forEach items="${itemList }" var="row" varStatus="vs">
		            	<div class="container" style="padding-top:20px;">
			                <div class="w3-border w3-round-xlarge" style="background-color: white;box-shadow: 5px 5px 2px grey;">
		                  		<div class="panel-body" >
		                  			<img alt="${row.IMG_ORIGIN_FILENAME }" src="<c:url value='/resources/item_imgs/${row.IMG_STORED_FILENAME }'/>" onerror='this.src="/LOLweb/resources/imgs/cannotloadimg.jpg"' style="width: 50px; height: 50px;" >
		                			${row.NAME }<br>
		                			${row.EXPLANATION}<br>
		                			<input type="button" style="font-size:13px;" value="구매하기(비행기 ${row.NEED_CASH}개 or ${row.NEED_REAL_CASH}원)" onclick="document.getElementById('buyModal${vs.index}').style.display='block'"/>
		                		</div>
		                	</div>
		                	
		                	<div id="buyModal${vs.index}" class="w3-modal">
							    <div class="w3-modal-content">
							      <div class="w3-container">
							        <span onclick="document.getElementById('buyModal${vs.index}').style.display='none'" class="w3-button w3-display-topright">&times;</span>
							        
							        <div style="padding: 5px 5px 15px 5px;">
							        	<h4>아이템 구매</h4>
								        <p style="font-size: 13px;">
								        	'${row.NAME}' 아이템을 구매하시겠습니까?
								        </p>
								        
								        <br>
								        
								        <input type="button" value="비행기로 구매하기(${row.NEED_CASH}개)" style="font-size: 15px;" onclick="buyItemForCash(${sessionNo}, ${row.IDX}, 'cash', ${row.NEED_CASH})"/>
							        	<span class="button alt" style="font-size: 15px;" onclick="buyItemForRealCash(${sessionNo}, ${row.IDX}, 'realCash', ${row.NEED_REAL_CASH}, '${row.NAME}')">신용카드로 구매하기(${row.NEED_REAL_CASH}원)</span>
							        </div>
							        
							      </div>
							    </div>
						  	</div>
		                </div>
		               </c:forEach>
		           </c:when>
		           <c:otherwise>
		           등록된 아이템이 없습니다.
		           </c:otherwise>
		       </c:choose>
       </div>
       
       <div id="tab2" class="tab_content">
	       <h2>보유한 아이템 내역</h2>
	       
	       <c:choose>
	        <c:when test="${fn:length(myItemList) > 0}">
	            <c:forEach items="${myItemList }" var="row" varStatus="vs">
	            	<!-- 사용가능한 아이템만 보임 -->
	            	<c:choose>
		            	<c:when test="${row.POSSIBLE_USE_CNT - row.USE_CNT gt 0}">
			            	<div class="container" style="padding-top:20px;">
			            		<div class="w3-border w3-round-xlarge" style="background-color: white;box-shadow: 5px 5px 2px grey;">
			                  		<div class="panel-body" >
			                  			<img alt="${row.IMG_ORIGIN_FILENAME }" src="<c:url value='/resources/item_imgs/${row.IMG_STORED_FILENAME }'/>" onerror='this.src="/LOLweb/resources/imgs/cannotloadimg.jpg"' style="width: 50px; height: 50px;" >
			                			${row.NAME }<br>
			                			${row.EXPLANATION}<br>
			                			현재 사용가능한 횟수 ${row.POSSIBLE_USE_CNT - row.USE_CNT } / 총 사용가능 횟수 ${row.POSSIBLE_USE_CNT}<br>
			                		</div>
			                	</div>
			                </div>
		                </c:when>
	                </c:choose>
	               </c:forEach>
	           </c:when>
	           <c:otherwise>
	           회원님이 현재 보유하고 있는 아이템이 없습니다.
	           </c:otherwise>
	       </c:choose>
      </div>
	  </div>     
</div>
</section>
<hr/>
<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>