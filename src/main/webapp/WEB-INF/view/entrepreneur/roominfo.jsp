<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<div id="demo" class="carousel roominfo_div_box mt-3" data-bs-ride="carousel" style="">
  	<!-- Indicators/dots -->
  	<div class="carousel-indicators">
	<c:forEach var="pic" items="${p_list}" varStatus="i">
		<button type="button" data-bs-target="#demo" data-bs-slide-to="${i.index}" <c:if test="${i.index == 0}"> class="active"</c:if> ></button>
	</c:forEach>
</div>
    
    <!-- The slideshow/carousel -->
<div class="carousel-inner ">
    		<c:forEach var="pic" items="${p_list}" varStatus="i">
		<div class="carousel-item  <c:if test="${i.index == 0}">active</c:if>">
        	<img class="top-img  rounded" src="${pic}" class="d-block" style="width:500px; object-fit: cover;">
        </div>
	</c:forEach>
</div>
    
    <!-- Left and right controls/icons -->
    <button class="carousel-control-prev" type="button" data-bs-target="#demo" data-bs-slide="prev">
      <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#demo" data-bs-slide="next">
      <span class="carousel-control-next-icon"></span>
    </button>
</div>

<div class = "roominfo_div_box">
    
	<div>
	<input type="hidden" name="pic_num" value="${pic_num}">
	<input type="hidden" name="ro_num" value="${room.ro_num}">
	
	<div class="rounded mt-3" style="text-align: center;">
			<div style="width:500px;  border-top: 1px solid #c8c8c8; border-bottom: 1px solid #c8c8c8;">
				<strong class="large_text" style="color:black;">${room.ro_name}</strong>
			</div>
		</div>
		<div class="rounded mt-3 mb-3" style="text-align: center; border:1px solid #c8c8c8;">
			<div class="large_text mt-3 mb-3"><strong style="color:grey">객실기본정보</strong></div>
			<table class="table table-borderless medium_text" style="text-align: center;">
				<tr>
					<td><strong>가격</strong></td>
					<td>${room.ro_price}원</td>
				</tr>
				<tr>
					<td><strong>체크인</strong></td>
					<td>${room.checkin}</td>
				</tr>
				<tr>
					<td><strong>체크아웃</strong></td>
					<td>${room.checkout}</td>
				</tr>
			</table>
			
			<hr>
			
			<div class="mt-3 mb-3 small_text">	
				${info}
			</div>
		</div>
		
	    <button class="default_btn rounded mt-1" onclick="location.href='${pageContext.request.contextPath}/room/roomUpdate?pic_num=${pic_num}&ro_num=${ro_num}'">정보수정</button>
    	<button class="default_btn rounded mt-1" onclick="location.href='${pageContext.request.contextPath}/room/roomDelete?ro_num=${ro_num}'">객실삭제</button>
	</div>
</div>
</body>
</html>