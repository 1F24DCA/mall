<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%@ page import="commons.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>productList</title>
		
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
						
						$("#searchProductName").focus();
						return;
					}
					
					$("#searchProductForm").submit();
				});
			});
		</script>
	</head>
	
	<%
			final String THIS_PAGE = request.getContextPath()+"/product/productList.jsp";
				
				Member paramMember = new Member();
				paramMember.setMemberEmail((String)(session.getAttribute("loginMemberEmail")));
				
				MemberDao memberDao = new MemberDao();
				Member member = memberDao.selectMemberOne(paramMember);
				
				request.setCharacterEncoding("UTF-8");
				
				int currentPage = 1;
				if (request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
				}
				
				int searchCategoryId = -1;
				if (request.getParameter("searchCategoryId") != null) {
			searchCategoryId = Integer.parseInt(request.getParameter("searchCategoryId"));
				}
				
				String searchProductName = "";
				if (request.getParameter("searchProductName") != null) {
			searchProductName = request.getParameter("searchProductName");
				}
				
				ListPage categoryListPage = new ListPage();
				categoryListPage.setCurrentPage(1);
				categoryListPage.setRowPerPage(30);
				categoryListPage.setNaviAmount(1);
				
				CategoryDao categoryDao = new CategoryDao();
				ArrayList<Category> categoryList = categoryDao.selectCategoryListWithPage(categoryListPage);
				
				ListPage productListPage = new ListPage();
				productListPage.setCurrentPage(currentPage);
				productListPage.setRowPerPage(12);
				productListPage.setNaviAmount(5);
				
				Product paramProduct = new Product();
				paramProduct.setCategoryId(searchCategoryId);
				paramProduct.setProductName(searchProductName);
				
				ProductDao productDao = new ProductDao();
				ArrayList<ProductAndCategory> productList = productDao.selectProductListWithPageAndSearch(productListPage, paramProduct);
				productListPage.setTotalRow(productDao.selectProductCountWithSearch(paramProduct));
		%>
	
	<body>
		<!-- 네비게이션 위 (제목/검색/유틸리티) 표시 부분 -->
		<div class="container-lg mt-5 mb-4">
			<br>
			
			<form method="post" action="<%=request.getContextPath()%>/product/productList.jsp" id="searchProductForm">
				<input type="hidden" name="searchCategoryId" value="<%=searchCategoryId%>">
				
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
						<input class="form-control" type="text" name="searchProductName" value="<%=searchProductName%>" placeholder="이름으로 상품 검색" id="searchProductName">
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
				<%
					if (session.getAttribute("loginMemberEmail") == null) {
				%>
						<a class="btn btn-sm btn-primary ml-1" href="<%=request.getContextPath()%>/member/login.jsp">로그인</a>
						<a class="btn btn-sm btn-light ml-1" href="<%=request.getContextPath()%>/member/signup.jsp">회원가입</a>
				<%
					} else {
				%>
						<a class="text-light text-decoration-none ml-1" href="<%=request.getContextPath()%>/member/memberOne.jsp"><%=member.getMemberName() %>님</a>
						<a class="btn btn-sm btn-primary ml-1" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a>
				<%
					}
				%>
			</div>
		</div>
		
		<!-- 네비게이션 아래 (컨텐츠) 표시 부분 -->
		<div class="container-lg mt-4 mb-5">
			<div class="container-lg mt-4 mb-5">
				<h2 class="font-weight-bolder">상품 목록</h2>
				
				<hr>
				
				<div class="row">
					<div class="col-2">
						<div class="d-flex flex-column">
							<div class="my-2">
								<%
									String categoryClasses = "";
									if (searchCategoryId == -1) {
										categoryClasses = "btn btn-primary btn-block";
									} else {
										categoryClasses = "btn btn-secondary btn-block";
									}
									
									String link = "";
									if (searchProductName.equals("")) {
										link = request.getContextPath()+"/product/productList.jsp";
									} else {
										link = request.getContextPath()+"/product/productList.jsp?searchProductName="+searchProductName;
									}
								%>
								<a class="<%=categoryClasses%>" href="<%=link%>">전체 카테고리</a>
							</div>
							<%
								for (Category c : categoryList) {
									categoryClasses = "";
									if (searchCategoryId == c.getCategoryId()) {
										categoryClasses = "btn btn-primary btn-block";
									} else {
										categoryClasses = "btn btn-secondary btn-block";
									}
									
									link = "";
									if (searchProductName.equals("")) {
										link = request.getContextPath()+"/product/productList.jsp?searchCategoryId="+c.getCategoryId();
									} else {
										link = request.getContextPath()+"/product/productList.jsp?searchCategoryId="+c.getCategoryId()+"&searchProductName="+searchProductName;
									}
							%>
									<div class="my-2">
										<a class="<%=categoryClasses%>" href="<%=link%>"><%=c.getCategoryName() %></a>
									</div>
							<%
								}
							%>
						</div>
					</div>
					
					<div class="col-10">
						<div class="row my-2">
								<%
									int i = 0;
									for (ProductAndCategory pac : productList) {
										if (i%3 == 0) {
								%>
											</div><div class="row">
								<%	
										}
								%>
										<div class="col-4">
											<a class="card mb-4 p-3 bg-light border-0 text-reset text-decoration-none" href="<%=request.getContextPath()%>/product/productOne.jsp?productId=<%=pac.getProduct().getProductId()%>">
												<img class="card-img-top border w-100" src="/mall-admin/image/<%=pac.getProduct().getProductPic()%>" alt="Card image">
												<div class="card-body">
													<h6 class="card-title text-right mx-n3 mt-n2 mb-n1"><%=pac.getProduct().getProductName() %></h6>
													<%
														if (pac.getProduct().getProductSoldout().equals("Y")) {
													%>
															<h4 class="card-text text-left mx-n3 mt-1 mb-n3 text-secondary">품절</h4>
													<%
														} else {
													%>
															<h4 class="card-text text-left mx-n3 mt-1 mb-n3"><%=pac.getProduct().getProductPrice() %>원</h4>
													<%
														}
													%>
												</div>
											</a>
										</div>
								<%
										i = i + 1;
									}
								%>
						</div>
						
						<!-- 페이지 네비게이션 부분 -->
						<div class="d-flex justify-content-center">
							<%
								String naviFirstLink = "";
								String naviPrevLink = "";
								String naviNextLink = "";
								String naviLastLink = "";
								if (searchCategoryId == -1 && searchProductName.equals("")) {
									naviFirstLink = THIS_PAGE;
									naviPrevLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviStartPage()-1);
									naviNextLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviEndPage()+1);
									naviLastLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviLastPage());
								} else if (searchCategoryId != -1 && searchProductName.equals("")) {
									naviFirstLink = THIS_PAGE+"?searchCategoryId="+searchCategoryId;
									naviPrevLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviStartPage()-1)+"&searchCategoryId="+searchCategoryId;
									naviNextLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviEndPage()+1)+"&searchCategoryId="+searchCategoryId;
									naviLastLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviLastPage())+"&searchCategoryId="+searchCategoryId;
								} else if (searchCategoryId == -1 && !searchProductName.equals("")) {
									naviFirstLink = THIS_PAGE+"?searchProductName="+searchProductName;
									naviPrevLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviStartPage()-1)+"&searchProductName="+searchProductName;
									naviNextLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviEndPage()+1)+"&searchProductName="+searchProductName;
									naviLastLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviLastPage())+"&searchProductName="+searchProductName;
								} else if (searchCategoryId != -1 && !searchProductName.equals("")) {
									naviFirstLink = THIS_PAGE+"?searchCategoryId="+searchCategoryId+"&searchProductName="+searchProductName;
									naviPrevLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviStartPage()-1)+"&searchCategoryId="+searchCategoryId+"&searchProductName="+searchProductName;
									naviNextLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviEndPage()+1)+"&searchCategoryId="+searchCategoryId+"&searchProductName="+searchProductName;
									naviLastLink = THIS_PAGE+"?currentPage="+(productListPage.getNaviLastPage())+"&searchCategoryId="+searchCategoryId+"&searchProductName="+searchProductName;
								}
							%>
							
							<%
								if (!productListPage.isFirstNaviPage()) {
							%>
									<h5 class="font-weight-bolder mx-2">
										<a class="text-reset text-decoration-none" href="<%=naviFirstLink%>">처음으로</a>
									</h5>
									<h5 class="font-weight-bolder mx-2">
										<a class="text-reset text-decoration-none" href="<%=naviPrevLink%>">이전</a>
									</h5>
							<%
								}
							%>
							
							<%
								for (int naviPage : productListPage.getNaviPageList()) {
									String naviPageClasses = "";
									if (naviPage != productListPage.getCurrentPage()) {
										naviPageClasses = "font-weight-normal mx-2";
									} else {
										naviPageClasses = "font-weight-bolder mx-2";
									}
									
									String naviPageLink = "";
									if (searchCategoryId == -1 && searchProductName.equals("")) {
										naviPageLink = THIS_PAGE+"?currentPage="+naviPage;
									} else if (searchCategoryId != -1 && searchProductName.equals("")) {
										naviPageLink = THIS_PAGE+"?currentPage="+naviPage+"&searchCategoryId="+searchCategoryId;
									} else if (searchCategoryId == -1 && !searchProductName.equals("")) {
										naviPageLink = THIS_PAGE+"?currentPage="+naviPage+"&searchProductName="+searchProductName;
									} else if (searchCategoryId != -1 && !searchProductName.equals("")) {
										naviPageLink = THIS_PAGE+"?currentPage="+naviPage+"&searchCategoryId="+searchCategoryId+"&searchProductName="+searchProductName;
									}
							%>
									<h5 class="<%=naviPageClasses%>">
										<a class="text-reset text-decoration-none" href="<%=naviPageLink%>"><%=naviPage %></a>
									</h5>
							<%
								}
							%>
							
							<%
								if (!productListPage.isLastNaviPage()) {
							%>
									<h5 class="font-weight-bolder mx-2">
										<a class="text-reset text-decoration-none" href="<%=naviNextLink%>">다음</a>
									</h5>
									<h5 class="font-weight-bolder mx-2">
										<a class="text-reset text-decoration-none" href="<%=naviLastLink%>">마지막으로</a>
									</h5>
							<%
								}
							%>
						</div>
					</div>
				</div>
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