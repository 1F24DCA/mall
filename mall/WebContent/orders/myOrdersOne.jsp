<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%@ page import="commons.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>

<%
	if (session.getAttribute("loginMemberEmail") == null) {
		response.sendRedirect(request.getContextPath()+"/member/login.jsp?loginRequired=true");
		return;
	}
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>myOrdersOne</title>
		
		<!-- 부트스트랩 사용 -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		<!-- FontAwesome Icon 사용 -->
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
		
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
		<script>
			$(document).ready(function() {
				console.log("document ready");
				
				$("#searchProductSubmit").click(function() {
					console.log("started search product");
					
					if ($("#searchProductName").val() == "") {
						alert("검색어를 입력해주세요!");
						return;
					}
					
					$("#searchProductForm").submit();
				});
			});
		</script>
	</head>
	
	<%
		Member paramMember = new Member();
		paramMember.setMemberEmail((String)(session.getAttribute("loginMemberEmail")));
		
		MemberDao memberDao = new MemberDao();
		Member member = memberDao.selectMemberOne(paramMember);
		
		request.setCharacterEncoding("UTF-8");
		
		ListPage listPage = new ListPage();
		listPage.setCurrentPage(1);
		listPage.setRowPerPage(10);
		listPage.setNaviAmount(5);
		
		Orders paramOrders = new Orders();
		paramOrders.setOrdersId(Integer.parseInt(request.getParameter("ordersId")));
		
		OrdersDao ordersDao = new OrdersDao();
		OrdersAndProduct oap = ordersDao.selectOrdersAndProductOne(paramOrders);
	%>
	
	<body>
		<!-- 네비게이션 위 (제목/검색/유틸리티) 표시 부분 -->
		<div class="container-lg mt-5 mb-4">
			<br>
			
			<form method="post" action="<%=request.getContextPath()%>/product/productList.jsp" id="searchProductForm">
				<div class="row">
					<!-- 쇼핑몰 이름 표시 -->
					<div class="col text-left align-middle">
						<!-- font-weight-bolder: 글자 두께를 조금 더 두껍게 만듭니다 -->
						<h1 class="font-weight-bolder">
							<!-- text-reset으로 링크의 색깔을 리셋시키고, text-decoration-none으로 링크에 마우스를 가져갔을때 밑줄을 없앱니다 -->
							<a class="text-reset text-decoration-none" href="<%=request.getContextPath()%>/index.jsp">Goodee Shop</a>
						</h1>
					</div>
					
					<!-- 검색 창(입력폼 한개) -->
					<div class="col d-flex align-items-center">
						<input class="form-control" type="text" name="searchProductName" placeholder="이름으로 상품 검색" id="searchProductName">
					</div>
					
					<!-- 검색 버튼 + 유틸리티(마이페이지, 장바구니) -->
					<div class="col d-flex">
						<div class="row flex-fill">
							<div class="col-4 d-flex align-items-center">
								<button class="btn btn-dark btn-block" type="button" id="searchProductSubmit">검색</button>
							</div>
							
							<div class="col-8 text-right align-middle">
								<a class="btn" href="<%=request.getContextPath()%>/member/memberOne.jsp"><i class='fas fa-user-alt' style='font-size:36px'></i></a>
								<a class="btn" href="<%=request.getContextPath()%>/notice/noticeList.jsp"><i class='fas fas fa-file-alt' style='font-size:36px'></i></a>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
		
		<!-- 네비게이션 표시 부분 -->
		<div class="container-fluid bg-dark py-2">
			<div class="container-lg text-right align-middle">
				<a class="text-light text-decoration-none ml-1" href="<%=request.getContextPath()%>/member/memberOne.jsp"><%=member.getMemberName() %>님</a>
				<a class="btn btn-sm btn-primary ml-1" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a>
			</div>
		</div>
		
		<!-- 네비게이션 아래 (컨텐츠) 표시 부분 -->
		<div class="container-lg mt-4 mb-5">
			<div class="container-lg mt-4 mb-5">
				<h2 class="font-weight-bolder">주문 상세 정보</h2>
				
				<hr>
				
				<table class="table table-borderless align-middle">
					<tr>
						<td><h5 class="font-weight-bolder">주문한 날짜</h5></td>
						<td><%=oap.getOrders().getOrdersDate().replace(".0", "") %></td>
					</tr>
					<tr>
						<td><h5 class="font-weight-bolder">상품 이름</h5></td>
						<td><%=oap.getProduct().getProductName() %></td>
					</tr>
					<tr>
						<td><h5 class="font-weight-bolder">갯수</h5></td>
						<td><%=oap.getOrders().getOrdersAmount() %></td>
					</tr>
					<tr>
						<td><h5 class="font-weight-bolder">가격</h5></td>
						<td><%=oap.getOrders().getOrdersPrice() %></td>
					</tr>
					<tr>
						<td><h5 class="font-weight-bolder">배송지</h5></td>
						<td><%=oap.getOrders().getOrdersAddr() %></td>
					</tr>
					<tr>
						<td><h5 class="font-weight-bolder">상태</h5></td>
						<td><%=oap.getOrders().getOrdersState() %></td>
					</tr>
				</table>
			</div>
		</div>
		
		<hr>
		
		<!-- 하단 바 표시 부분 -->
		<div class="container-lg">
			<!-- 하단 네비게이션 부분 -->
			<div class="clearfix mt-4 mb-1">
				<div class="float-left">
					<h6 class="small">(주)Goodee Shop</h6>
					<h6 class="small">08505) 서울시 금천구 가산디지털2로 115, 811호(가산동, 대륭테크노타운3차)</h6>
					<h6 class="small">Copyright ⓒ 2020 GoodeeShop Co.,Ltd All Rights Reserved.</h6>
				</div>
				<div class="float-right">
					<div class="d-inline-flex">
						<h6 class="font-weight-bolder ml-4">
							문의 
							<span class="font-weight-normal ml-2">010-6415-1647</span>
						</h6>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>