<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
		<title>addOrders</title>
		
		<!-- 부트스트랩 사용 -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		<!-- FontAwesome Icon 사용 -->
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
	</head>
	
	<%
		Member paramMember = new Member();
		paramMember.setMemberEmail((String)(session.getAttribute("loginMemberEmail")));
		
		MemberDao memberDao = new MemberDao();
		Member member = memberDao.selectMemberOne(paramMember);
		
		Product paramProduct = new Product();
		paramProduct.setProductId(Integer.parseInt(request.getParameter("productId")));
		
		ProductDao productDao = new ProductDao();
		Product product = productDao.selectProductOne(paramProduct);
		
		if (product.getProductSoldout().equals("Y")) {
			response.sendRedirect(request.getContextPath()+"/product/productOne.jsp?productId="+product.getProductId());
			return;
		}
	%>
	
	<body>
		<!-- 네비게이션 위 (제목/검색/유틸리티) 표시 부분 -->
		<div class="container-lg mt-5 mb-4">
			<br>
			
			<form method="post" action="<%=request.getContextPath()%>/product/productList.jsp">
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
						<input class="form-control" type="text" name="searchProductName" placeholder="이름으로 상품 검색">
					</div>
					
					<!-- 검색 버튼 + 유틸리티(마이페이지, 장바구니) -->
					<div class="col d-flex">
						<div class="row flex-fill">
							<div class="col-4 d-flex align-items-center">
								<button class="btn btn-dark btn-block" type="submit">검색</button>
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
				<h2 class="font-weight-bolder">주문하기</h2>
				
				<hr>
				
				<form method="post" action="<%=request.getContextPath()%>/orders/addOrdersAction.jsp">
					<input type="hidden" value="<%=product.getProductId()%>" name="productId">
					<input type="hidden" value="<%=product.getProductPrice()%>" name="productPrice">
					
					<div class="row d-flex align-items-center mb-3">
						<div class="col-1">
							<img class="img-fluid border" src="http://<%=request.getServerName()%>/mall-admin/image/<%=product.getProductPic()%>">
						</div>
						
						<div class="col-11">
							<div class="d-flex justify-content-between">
								<div>
									<h5><%=product.getProductName() %></h5>
								</div>
								
								<div class="mr-4">
									<h5>￦<%=product.getProductPrice() %></h5>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="col-3">
							<div class="form-group">
								<label>주문수량:</label>
								<select class="form-control" name="ordersAmount">
									<%
										for (int i=1; i<11; i+=1) {
									%>
											<option value="<%=i%>"><%=i %></option>
									<%
										}
									%>
								</select>
							</div>
						</div>
						
						<div class="col-9">
							<div class="form-group">
								<label>배송지:</label>
								<input class="form-control" type="text" name="ordersAddr">
							</div>
						</div>
					</div>
					
					<div class="form-group">
						<button class="btn btn-primary btn-block" type="submit">주문하기</button>
					</div>
				</form>
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
		
		<!-- 
		<form method="post" action="<%=request.getContextPath()%>/orders/addOrdersAction.jsp">
			<input type="hidden" value="<%//=product.productId%>" name="productId">
			<input type="hidden" value="<%//=product.productPrice%>" name="productPrice">
			<div>
				주문수량:
				<select name="ordersAmount">
					<%
						for (int i=1; i<11; i+=1) {
					%>
							<option value="<%=i%>"><%=i %></option>
					<%
						}
					%>
				</select>
			</div>
			<div>
				배송주소:
				<input type="text" name="ordersAddr">
			</div>
			<div>
				<button type="submit">주문</button>
			</div>
		</form>
		 -->
	</body>
</html>