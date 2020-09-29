<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	if (session.getAttribute("loginMemberEmail") != null) {
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>login</title>
		
		<!-- 부트스트랩 사용 -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		<!-- FontAwesome Icon 사용 -->
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
	</head>
	
	<%
		request.setCharacterEncoding("UTF-8");
		System.out.println(request.getParameter("loginRequired")+"<-request.getParameter(\"loginRequired\")");
		System.out.println(request.getParameter("loginFailed")+"<-request.getParameter(\"loginFailed\")");
		System.out.println(request.getParameter("signupSuccess")+"<-request.getParameter(\"signupSuccess\")");
		System.out.println(request.getParameter("logout")+"<-request.getParameter(\"logout\")");
		
		String messageClasses = "";
		String message = "";
		if (request.getParameter("loginFailed") != null) {
			messageClasses = "btn btn-outline-danger btn-block disabled";
			message = "로그인에 실패했습니다";
		} else if (request.getParameter("loginRequired") != null) {
			messageClasses = "btn btn-outline-danger btn-block disabled";
			message = "로그인이 필요합니다";
		} else if (request.getParameter("signupSuccess") != null) {
			messageClasses = "btn btn-outline-success btn-block disabled";
			message = "성공적으로 회원가입했습니다. 로그인해주세요";
		} else if (request.getParameter("logout") != null) {
			messageClasses = "btn btn-outline-success btn-block disabled";
			message = "성공적으로 로그아웃했습니다";
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
				<a class="btn btn-sm btn-light ml-1" href="<%=request.getContextPath()%>/member/signup.jsp">회원가입</a>
			</div>
		</div>
		
		<!-- 네비게이션 아래 (컨텐츠) 표시 부분 -->
		<div class="container-lg mt-4 mb-5">
			<h2 class="font-weight-bolder">로그인</h2>
			
			<hr>
			
			<form method="post" action="<%=request.getContextPath()%>/member/loginAction.jsp">
				<div class="row">
					<div class="col">
						<div class="form-group">
							<label>E-mail:</label>
							<input class="form-control" type="text" name="memberEmail">
						</div>
					</div>
					
					<div class="col">
						<div class="form-group">
							<label>비밀번호:</label>
							<input class="form-control" type="password" name="memberPw">
						</div>
					</div>
				</div>
				
				<hr>
				
				<div><button class="btn btn-primary btn-block mb-3" type="submit">로그인</button></div>
				<div><a class="btn btn-outline-secondary btn-block" href="<%=request.getContextPath()%>/member/signup.jsp">회원가입</a></div>
			</form>
							
			<%
				if (!message.equals("")) {
			%>
					<hr>
					
					<span class="<%=messageClasses%>">
						<%=message %>
					</span>
			<%
				}
			%>
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