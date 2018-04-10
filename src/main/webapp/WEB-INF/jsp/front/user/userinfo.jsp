<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/include/gnb.jsp" %>
<%@ include file="/WEB-INF/include/head.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
var slideIndex = 1;
showDivs(slideIndex);

function plusDivs(n, step) {
	var f = document.frm;
	
	if(step == "1"){
		
		if(f.name.value == ""){
			alert("이름을 입력해주세요!");
			f.name.focus();
			return false;
		}
		if(f.birthYear.value == ""){
			alert("태어난 해를 입력해주세요!");
			f.birthYear.focus();
			return false;
		}
		if(f.nickName.value == ""){
			alert("별명을 입력해주세요!");
			f.nickName.focus();
			return false;
		}
		if(f.region.value == ""){
			alert("지역을 선택해주세요!");
			f.region.focus();
			return false;
		}
		if(f.job.value == ""){
			alert("사회적 역할을 선택해주세요!");
			f.job.focus();
			return false;
		}
		if(f.company.value == ""){
			alert("소속을 입력해주세요!");
			f.company.focus();
			return false;
		}
		if(f.bloodType.value == ""){
			alert("혈액형을 선택해주세요!");
			f.bloodType.focus();
			return false;
		}
		if(f.stance.value == ""){
			alert("정치성향을 선택해주세요!");
			f.stance.focus();
			return false;
		}
		if(f.gender.value == ""){
			alert("성별을 선택해주세요!");
			f.gender.focus();
			return false;
		}
		if(f.ageGap.value == ""){
			alert("허용가능한 나이차이를 입력해주세요!");
			f.ageGap.focus();
			return false;
		}
	} 
	else if(step == "2"){
		if(f.favorite.value == ""){
			alert("좋아하는 것을 입력해주세요!");
			f.favorite.focus();
			return false;
		}
		if(f.favoriteReason.value == ""){
			alert("좋아하는 이유를 입력해주세요!");
			f.favoriteReason.focus();
			return false;
		}
	}
	else if(step == "3"){
		if(f.introduce.value == ""){
			alert("성격, 성향, 가치관, 장점에 대해 입력해주세요!");
			f.introduce.focus();
			return false;
		}
	}
	
	showDivs(slideIndex += n);
}

function showDivs(n) {
  var i;
  var x = document.getElementsByClassName("mySlides");
  if (n > x.length) {slideIndex = 1}    
  if (n < 1) {slideIndex = x.length}
  for (i = 0; i < x.length; i++) {
     x[i].style.display = "none";  
  }
  if(x[slideIndex-1] != undefined){
  	x[slideIndex-1].style.display = "block";
  }
}
</script>

</head>

<!-- Main -->
<section id="intro" class="container">
	<div id="main-wrapper">
		<div class="container">
			<div>
				<c:choose>
			      <c:when test="${!empty memberMap && memberMap.STATUS ne 'I'}">
					<form name="frm" id="frm" method="post">
						<input type="hidden" name="no" value="${memberMap.NO}"/>
						<input type="hidden" name="mode" value="${empty memberInfoMap ? 'REG' : 'EDIT'}"/>
						
						<c:if test="${memberMap.STATUS eq 'F' && memberMap.ISPASS eq 'F'}">
							<h2>심사 결과</h2>
							<i class="glyphicon glyphicon-remove-sign" style="font-size:100px;"></i>
							<span style="font-size:13px;">
								<br>안타깝게도 아래의 사유로 인해 심사가 반려되었습니다.<br>
								사유를 확인하시고 해당 부분을 다시 작성해 주시기 바랍니다.<br><br>
							</span>
							<span style="font-size:15px; font-weight: bold;"><c:if test="${!empty memberMap.FAIL_REASON}">${memberMap.FAIL_REASON}</c:if></span>
				      	</c:if>
				      	<c:if test="${memberMap.STATUS eq 'F' && memberMap.ISPASS eq 'T'}">
				      		<h2>심사 결과</h2>
				      		<i class="glyphicon glyphicon-ok-sign" style="font-size:100px;"></i>
							<span style="font-size:13px;">
				      			<br><br>심사가 완료 및 승인되었습니다 :)<br>
				      		</span>
				      	</c:if>
						
						<hr>
						
						<h2>
							<c:choose>
						      <c:when test="${!empty memberInfoMap}">
						      	정보 수정
						      </c:when>
						      <c:otherwise>
						      	정보 등록
						      </c:otherwise>
							</c:choose>
						</h2>	
						<br>
						
						<hr>
						
						<div id="info1" class="mySlides">
							<h5>기본적인 개인정보를 입력해주세요.</h5>
							<div style="font-size: 13px; padding: 5px 15px 15px 15px; color:#ff495b; ">이름, 생년, 혈액형, 성별은 바꿀수 없으므로 주의해주세요.</div>
							
							<div class="userInfoDiv">
							      <span style="font-weight: bold;">폰번호</span>
							      <%-- <div class="row">
   									<div class="col-sm">
							      		<input name="mobile1" type="text" size="3" maxlength="3" value="${memberInfoMap.mobile1 }" required>
							      	</div>
   									<div class="col-sm" style="padding-left: 1px;">
							      		<input name="mobile2" type="text" size="3" maxlength="4" value="${memberInfoMap.mobile2 }" required>
							      	</div>
							      	<div class="col-sm" style="padding-left: 1px;">
							      		<input name="mobile2" type="text" size="3" maxlength="4" value="${memberInfoMap.mobile3 }" required>
							      	</div>
							      </div> --%>
							      
							      <table>
							      	<tr>
							      		<td><input name="mobile1" type="text" size="3" maxlength="3" value="${memberInfoMap.mobile1 }" placeholder="010" required></td>
							      		<td><input name="mobile2" type="text" size="3" maxlength="4" value="${memberInfoMap.mobile2 }" placeholder="1234" required></td>
							      		<td><input name="mobile2" type="text" size="3" maxlength="4" value="${memberInfoMap.mobile3 }" placeholder="5678" required></td>
							      	</tr>
							      </table>
							</div>
							<div class="userInfoDiv">
							      <span style="font-weight: bold;">이름</span>
							      <br><input name="name" type="text" placeholder="홍길동" value="${memberMap.NAME}" readonly="readonly" required>
							      <%-- <c:choose>
								      <c:when test="${!empty memberInfoMap}">
								      	<br>${memberInfoMap.NAME }<br>
								      </c:when>
								      <c:otherwise>
								      	<input name="name" type="text" placeholder="홍길동" required>
								      </c:otherwise>
							      </c:choose> --%>
							</div>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">태어난 해</span> 
								<br><input name="birthYear" type="text" placeholder="1991" value="${memberMap.BIRTHYEAR}" readonly="readonly" required>
								<%-- <c:choose>
							      <c:when test="${!empty memberInfoMap}">
							      	<br>${memberInfoMap.BIRTHYEAR }<br>
							      </c:when>
							      <c:otherwise>
							      	<input name="birthYear" type="text" placeholder="1991" required>
							      </c:otherwise>
							    </c:choose> --%>
							</div>
							<div class="userInfoDiv">
							      <span style="font-weight: bold;">별명</span>
							      <input name="nickName" type="text" placeholder="10자 이내" maxlength="10" value="${memberInfoMap.NICKNAME }" required>
							</div>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">지역</span>
								<select name="region" required>
									<option value="">클릭하여 선택하세요</option>
									<option value="1" <c:if test="${memberInfoMap.REGION eq '1'}">selected</c:if>>인천</option>
									<option value="2" <c:if test="${memberInfoMap.REGION eq '2'}">selected</c:if>>경기 서남</option>
									<option value="3" <c:if test="${memberInfoMap.REGION eq '3'}">selected</c:if>>경기 서북</option>
									<option value="4" <c:if test="${memberInfoMap.REGION eq '4'}">selected</c:if>>서울</option>
									<option value="5" <c:if test="${memberInfoMap.REGION eq '5'}">selected</c:if>>경기 동북</option>
									<option value="6" <c:if test="${memberInfoMap.REGION eq '6'}">selected</c:if>>경기 동남</option>
									<option value="7" <c:if test="${memberInfoMap.REGION eq '7'}">selected</c:if>>강원</option>
									<option value="8" <c:if test="${memberInfoMap.REGION eq '8'}">selected</c:if>>충북</option>
									<option value="9" <c:if test="${memberInfoMap.REGION eq '9'}">selected</c:if>>대전</option>
									<option value="10" <c:if test="${memberInfoMap.REGION eq '10'}">selected</c:if>>충남</option>
									<option value="11" <c:if test="${memberInfoMap.REGION eq '11'}">selected</c:if>>전북</option>
									<option value="12" <c:if test="${memberInfoMap.REGION eq '12'}">selected</c:if>>광주</option>
									<option value="13" <c:if test="${memberInfoMap.REGION eq '13'}">selected</c:if>>전남</option>
									<option value="14" <c:if test="${memberInfoMap.REGION eq '14'}">selected</c:if>>경남</option>
									<option value="15" <c:if test="${memberInfoMap.REGION eq '15'}">selected</c:if>>부산</option>
									<option value="16" <c:if test="${memberInfoMap.REGION eq '16'}">selected</c:if>>울산</option>
									<option value="17" <c:if test="${memberInfoMap.REGION eq '17'}">selected</c:if>>대구</option>
									<option value="18" <c:if test="${memberInfoMap.REGION eq '18'}">selected</c:if>>경북</option>
								</select>
							</div>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">사회적 역할</span>
								<select name="job" required>
									<option value="">클릭하여 선택하세요</option>
									<option value="직장인" <c:if test="${memberInfoMap.JOB eq '직장인'}">selected</c:if>>직장인</option>
									<option value="자영업자" <c:if test="${memberInfoMap.JOB eq '자영업자'}">selected</c:if>>자영업자</option>
									<option value="대학생" <c:if test="${memberInfoMap.JOB eq '대학생'}">selected</c:if>>대학생</option>
									<option value="연구원" <c:if test="${memberInfoMap.JOB eq '연구원'}">selected</c:if>>연구원</option>
									<option value="기타" <c:if test="${memberInfoMap.JOB eq '기타'}">selected</c:if>>기타</option>
								</select>
							</div>
							<div class="userInfoDiv">
							      <span style="font-weight: bold;">소속</span>
							      <input name="company" type="text" value="${memberInfoMap.COMPANY}" required>
							</div>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">혈액형</span>
								<c:choose>
							      <c:when test="${!empty memberInfoMap}">
							      	<br>${memberInfoMap.BLOODTYPE } 형<br>
							      </c:when>
							      <c:otherwise>
							      	<select name="bloodType" required>
										<option value="">클릭하여 선택하세요</option>
										<option value="O">O형</option>
										<option value="A">A형</option>
										<option value="B">B형</option>
										<option value="AB">AB형</option>
									</select>
							      </c:otherwise>
							    </c:choose>
							</div>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">정치 성향</span>
								<select name="stance" required>
									<option value="">클릭하여 선택하세요</option>
									<option value="1" <c:if test="${memberInfoMap.STANCE eq '1'}">selected</c:if>>보수</option>
									<option value="2"<c:if test="${memberInfoMap.STANCE eq '2'}">selected</c:if>>중도보수</option>
									<option value="3"<c:if test="${memberInfoMap.STANCE eq '3'}">selected</c:if>>중도</option>
									<option value="4"<c:if test="${memberInfoMap.STANCE eq '4'}">selected</c:if>>중도진보</option>
									<option value="5"<c:if test="${memberInfoMap.STANCE eq '5'}">selected</c:if>>진보</option>
								</select>
							</div>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">성별</span>
									<input name="gender" type="hidden" value="${memberMap.GENDER}">
									<c:if test="${memberMap.GENDER eq 'male'}"><br>남자<br></c:if>
							      	<c:if test="${memberMap.GENDER eq 'female'}"><br>여자<br></c:if>
								<%-- <c:choose>
							      <c:when test="${!empty memberInfoMap}">
							      	<c:if test="${memberInfoMap.GENDER eq 'male'}"><br>남자<br></c:if>
							      	<c:if test="${memberInfoMap.GENDER eq 'female'}"><br>여자<br></c:if>
							      </c:when>
							      <c:otherwise>
							      	<select name="gender" required>
										<option value="">클릭하여 선택하세요</option>
										<option value="male">남자</option>
										<option value="female">여자</option>
									</select>
							      </c:otherwise>
							    </c:choose> --%>
							</div>
							<div class="userInfoDiv">
							      <span style="font-weight: bold;">허용가능한 나이차이(+,-)</span>
							      <input name="ageGap" type="text" value="${memberInfoMap.AGE_GAP}" placeholder="숫자만 입력" required>
							</div>
							
							<c:if test="${empty memberInfoMap}"><input type="button" value="확인" onclick="plusDivs(1, '1')"/></c:if>
							
							<hr>
						</div>
						
						<div id="info2" class="mySlides" <c:if test="${empty memberInfoMap}"> style="display: none;" </c:if> >
							<h5 class="userInfoDiv">외모를 제외한 당신이 보여주고 싶은 진짜 당신을 보여주세요.</h5>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">좋아하는 것을 작성해주세요</span>
								<input name="favorite" type="text" placeholder="(ex. 음악, 여행)" value="${memberInfoMap.FAVORITE }">
							</div>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">위에서 작성한 것을 왜 좋아하는지, 얼마나 좋아(자주)하는지, 어떤 즐거움이 있는지 상대방에게 설명해주세요.</span>
								<textarea name="favoriteReason" form="frm">${memberInfoMap.FAVORITE_REASON }</textarea>
							</div>
							
							<c:if test="${empty memberInfoMap}"><input type="button" value="확인" onclick="plusDivs(1, '2')"/></c:if>
							
							<hr>
						</div>
						
						
						<div id="info3" class="mySlides" <c:if test="${empty memberInfoMap}"> style="display: none;" </c:if> >
							<h5 class="userInfoDiv">본인을 잘 드러낼 수 있는 이야기를 써주세요.</h5>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">성격, 성향, 가치관, 장점에 대해서 이야기해주세요.</span>
								<textarea name="introduce" form="frm">${memberInfoMap.INTRODUCE }</textarea>
							</div>
							
							<c:if test="${empty memberInfoMap}"><input type="button" value="확인" onclick="plusDivs(1, '3')"/></c:if>
							
							<hr>
						</div>
						
						<div id="info4" class="mySlides" <c:if test="${empty memberInfoMap}"> style="display: none;" </c:if> >
							<h5 class="userInfoDiv">마지막입니다. 당신의 종교관에 대해 이야기해주세요 :)</h5>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">종교</span>
								<select name="religion" required>
									<option value="">클릭하여 선택하세요</option>
									<option value="1" <c:if test="${memberInfoMap.RELIGION eq '1'}">selected</c:if>>무교</option>
									<option value="2" <c:if test="${memberInfoMap.RELIGION eq '2'}">selected</c:if>>기독교</option>
									<option value="3" <c:if test="${memberInfoMap.RELIGION eq '3'}">selected</c:if>>불교</option>
									<option value="4" <c:if test="${memberInfoMap.RELIGION eq '4'}">selected</c:if>>천주교</option>
									<option value="5" <c:if test="${memberInfoMap.RELIGION eq '5'}">selected</c:if>>이슬람교</option>
									<option value="6" <c:if test="${memberInfoMap.RELIGION eq '6'}">selected</c:if>>기타</option>
								</select>
							</div>
							<div class="userInfoDiv">
								<span style="font-weight: bold;">종교관에 대해 자세하게 이야기해주세요.</span>
								<textarea name="religionThink" form="frm" required>${memberInfoMap.RELIGION_THINK }</textarea>
							</div>
							
							<c:choose>
							      <c:when test="${!empty memberInfoMap}">
							      	<input type="submit" value="정보 수정 완료"/>
							      </c:when>
							      <c:otherwise>
							      	<input type="submit" value="정보 입력 완료"/>
							      </c:otherwise>
							</c:choose>
							
						</div>
						
					</form>
				</c:when>
				<c:otherwise>
					<h2>심사가 진행중이므로 정보수정이 불가능합니다.</h2>
				</c:otherwise>
			  </c:choose>
			</div>
		</div>
	</div>
</section>
<%@ include file="/WEB-INF/include/foot.jsp" %>
</html>