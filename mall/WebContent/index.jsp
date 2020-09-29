<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%@ page import="commons.*" %>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<!-- 
	index.jsp
	모든 디자인 관련 처리는 부트스트랩으로 처리했습니다
	
	시작하기에 앞서, HTML 태그를 보다 보면 class 속성에 
	"pb-4", "my-3", "mb-2", "mt-1" 등 영어 두개와 숫자 하나를
	매우 흔하게 볼 수 있습니다
	
	이는, "패딩"과 "마진"으로, 요소와 요소 사이의 거리(간격)을 두는 데 사용됩니다
	"패딩"은 요소의 안쪽에 여백을 넣으며 (예를 들어, 버튼에 패딩을 넣으면 뚱뚱한 버튼이 됨)
	"마진"은 요소의 바깥쪽에 여백을 넣습니다 (예를 들어, 버튼에 마진을 넣으면 주변 버튼이랑 거리가 멀어짐)
	
	용어가 앞글자만 따서 적혀져 있어 어려울 수 있으니, 미리 설명드립니다
	
	pt: padding top / pb: padding bottom / pl: padding left / pr: padding right
	px: padding x (가로, 왼쪽+오른쪽 패딩) / py: padding y (세로, 위+아래 패딩)
	
	mt: margin top / mb: margin bottom / ml: margin left / mr: margin right
	mx: margin x (가로, 왼쪽+오른쪽 마진) / my: margin y (세로, 위+아래 마진)
	
	이외에도 p-1은 4방향 모두 패딩을 1레벨만큼, m-1은 4방향 모두 마진을 1레벨만큼 달라는 뜻입니다
	
	뒤에 숫자는 커질수록 마진 혹은 패딩의 크기가 커지며, 0부터 5까지 설정가능합니다
	1: 0.25rem / 2: 0.5rem / 3: 1rem / 4: 1.5rem / 5: 3rem
	rem은 cm, in, px, %같은 단위이며 폰트 크기에 따라 변하는 상대적인 값입니다

	더 자세한 정보는 https://www.w3schools.com/bootstrap4/bootstrap_utilities.asp 의 Spacing 부분을 참고해주세요!
	
	
	* 빈 공간 / 여백 처리는 부득이한 상황(뚱뚱한 요소가 필요한 경우)이 아닌 경우 전부 "마진"으로 처리했습니다!
 -->

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>index</title>
		
		<!-- 이 페이지는 부트스트랩 4를 사용합니다, 아주 많이요! -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		<!-- 이 페이지는 FontAwesome Icon을 사용합니다 (딱 두번밖에 안쓰지만요) -->
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
	</head>
	
	<%
		Member paramMember = new Member();
		paramMember.setMemberEmail((String)(session.getAttribute("loginMemberEmail")));
		
		MemberDao memberDao = new MemberDao();
		Member member = memberDao.selectMemberOne(paramMember);
		
		request.setCharacterEncoding("UTF-8");
		
		int searchCategoryId = -1;
		if (request.getParameter("searchCategoryId") != null) {
			searchCategoryId = Integer.parseInt(request.getParameter("searchCategoryId"));
		}
		
		ListPage categoryListPage = new ListPage();
		categoryListPage.setCurrentPage(1);
		categoryListPage.setRowPerPage(5);
		
		CategoryDao categoryDao = new CategoryDao();
		ArrayList<Category> categoryListSample = categoryDao.selectCategoryListWithPage(categoryListPage);
		ArrayList<Category> categoryListRecommend = categoryDao.selectCategoryListRecommend();
	%>
	
	<body>
		<!-- 
			네비게이션을 제외한 윗 부분과 아랫부분은 웹사이트 크기가 커져도 변화가 없어야 하기 때문에
			일정 크기이상 늘어나지 않는 container-lg 클래스로 감싸줬습니다
			container 클래스로 만들면 휴대폰에서 볼 때, 패딩이 들어가서 글자가 깨져 보이기에
			글자가 안깨질 정도의 폭은 필요하다고 판단되어 container-lg를 사용하였습니다
			
			네비게이션 부분은 웹 페이지 크기에 상관없이 꽉 차서 표시되어야 하기 때문에
			무조건 좌우로 꽉 채우는 container-fluid 클래스로 감싸줬습니다
		 -->
		
		<!-- 
			* 네비게이션 위 (제목/검색/유틸리티) 표시 부분
		 -->
		<div class="container-lg mt-5 mb-4">
			<!-- 추가적인 상단 여백을 간단히 주기 위해 br 태그를 사용했습니다 -->
			<br>
			
			<!-- 테이블 (div class="row"와 div class="col") 중간에 form 태그를 끼워넣으면 미관상 좋지 못하여 밖으로 빼서 선언합니다 -->
			<form method="post" action="<%=request.getContextPath()%>/product/productList.jsp">
				<!-- 
					상단 컨텐츠부를 3등분으로 쪼갭니다
					각 조각들은 정확히 33.3333...%의 자리를 차지하며, 3등분으로 쪼갠 조각들을...
						- 왼쪽 부분: 쇼핑몰 이름 표시
						- 가운데 부분: 검색 창(입력폼 한개)
						- 오른쪽 부분: 검색 버튼 + 유틸리티(마이페이지, 장바구니)
					(으)로 구성했습니다
					
					특이사항으로는, "container의 가장자리(끝자락) 부분"에 쇼핑몰 이름이랑 유틸리티를 붙였습니다
					container가 무한정 늘어나진 않지만, 허용하는 한도 내에선 가장자리에 붙어있을겁니다!
				 -->
				<div class="row">
					<!-- 왼쪽 부분: 쇼핑몰 이름 표시 -->
					<div class="col text-left align-middle">
						<!-- font-weight-bolder: 글자 두께를 조금 더 두껍게 만듭니다 -->
						<h1 class="font-weight-bolder">
							<!-- text-reset으로 링크의 색깔을 리셋시키고, text-decoration-none으로 링크에 마우스를 가져갔을때 밑줄을 없앱니다 -->
							<a class="text-reset text-decoration-none" href="<%=request.getContextPath()%>/index.jsp">Goodee Shop</a>
						</h1>
					</div>
					
					<!-- 가운데 부분: 검색 창(입력폼 한개) -->
					<!-- 
						텍스트는 text-center, align-middle등으로 정렬가능하지만
						인풋 폼 등은 텍스트 취급이 되지 않아, 다른 방법으로 중앙 정렬을 실시합니다
						
						Flex를 이용한 내부 아이템 정렬을 "d-flex align-items-center"로 할 수 있습니다
					 -->
					<div class="col d-flex align-items-center">
						<input class="form-control" type="text" name="searchProductName" placeholder="이름으로 상품 검색">
					</div>
					
					<!-- 오른쪽 부분: 검색 버튼 + 유틸리티(마이페이지, 장바구니) -->
					<!-- 
						검색 버튼과 유틸리티를 담기 위해, div로 만든 테이블 안에 또 테이블을 집어넣습니다 (이중 테이블)
						물론 검색 버튼이 25%의 크기, 유틸리티 버튼들이 75%의 크기를 가져갑니다
						
						이때, d-flex와 flex-fill을 사용하지 않으면
						내부 테이블의 높이가 요소들한테 딱 달라붙어서(패런트 크기랑 같지않아서)
						내부의 d-flex align-items-center가 먹히지 않습니다
						
						d-flex와 flex-fill 클래스가 패런트 열(오른쪽 부분:검색버튼+유틸리티를 담는 열)에 크기를 맞춰줌으로써
						수직 정렬을 원할히 도와줍니다
					 -->
					<div class="col d-flex">
						<!-- 이중 테이블의 시작 -->
						<div class="row flex-fill">
							<!-- 검색 버튼 표시 열 (이중테이블의 25%) -->
							<div class="col-4 d-flex align-items-center">
								<!-- btn-block은 패런트에 꽉 차게 버튼 크기를 늘리는 클래스입니다. 이로써 이중 테이블의 25% 전체를 버튼이 꽉 차지하게 됩니다 -->
								<button class="btn btn-dark btn-block" type="submit">검색</button>
							</div>
							
							<!-- 유틸리티 (마이페이지/장바구니) 버튼 표시 열 (이중테이블의 75%) -->
							<div class="col-8 text-right align-middle">
								<!-- FontAwesome Icon을 사용하여 마이페이지/장바구니 버튼을 구현했습니다 -->
								<a class="btn" href="<%=request.getContextPath()%>/member/memberOne.jsp"><i class='fas fa-user-alt' style='font-size:36px'></i></a>
								<a class="btn" href="<%=request.getContextPath()%>/notice/noticeList.jsp"><i class='fas fas fa-file-alt' style='font-size:36px'></i></a>
							</div>
						</div>
						<!-- 이중 테이블의 끝 -->
					</div>
				</div>
			</form>
		</div>
		
		<!-- 
			* 네비게이션 표시 부분
		 -->
		<!-- 네비게이션의 검은색 바가 뚱뚱해야하므로, 여기서는 부득이하게 마진 대신 패딩(py-2)를 쓸 수밖에 없었습니다 -->
		<div class="container-fluid bg-dark py-2">
			<!-- 
				네비게이션 자체는 container-fluid로 화면 크기에 상관없이 좌우로 꽉 차게 설정
				및 bg-dark를 이용해 꽉 찬 검은색을 구현했지만
				
				로그인과 회원가입 버튼은 container 안에 담음으로써, 상단 및 하단 컨텐츠들과 이질감이 없도록
				위치 조절을 했습니다
				
				물론 버튼은 텍스트 취급이 되므로, text-right로 오른쪽 정렬을 했습니다
			 -->
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
		
		<!-- 
			* 네비게이션 아래 (컨텐츠) 표시 부분
		 -->
		<div class="container-lg">
			<!-- 
				* 카테고리와 광고 표시 부분
				
				카테고리와 광고를 같은 줄에 표시하기 위해서는 2등분으로만 쪼개도 됩니다
				하지만, 너무 딱 붙여버리면 갑갑해보여서 중간 여백을 포함해서 3등분으로 쪼갰습니다
				
				각 조각들의 크기와 들어간 컨텐츠는...
					- 왼쪽(25%): 전체 카테고리 표시
					- 중간(8.3333...%): 카테고리와 광고 사이의 여백
					- 오른쪽(66.6666...%): 광고 표시
				(으)로 구성했습니다!
			 -->
			<div class="row mt-3 mb-5">
				<!-- 왼쪽 전체 카테고리 표시 부분 -->
				<div class="col-3">
					<div class="d-flex flex-column">
						<a class="btn btn-secondary btn-block m-2" href="<%=request.getContextPath()%>/product/productList.jsp">전체 카테고리</a>
						<%
							for (Category c : categoryListSample) {
						%>
								<!-- 
									my-2로 세로만 간격을 주면 되지만, 오른쪽 칸이 여백 칸이기도 하고
									화면 가장자리에서 떨어뜨리고 싶어서 4방향 모두 패딩을 주는 m-2를 사용했습니다
								 -->
								<a class="btn btn-secondary btn-block m-2" href="<%=request.getContextPath()%>/product/productList.jsp?searchCategoryId=<%=c.getCategoryId()%>"><%=c.getCategoryName() %></a>
						<%
							}
						%>
					</div>
				</div>
				
				<!-- 중간 여백부분 -->
				<div class="col-1"></div>
				
				<!-- 오른쪽 광고부분 -->
				<!-- 은은한 배경색이 돌도록 했습니다 -->
				<!-- 또한 카드 전체에 링크를 걸기 위해 div 태그 대신 a 태그를 사용합니다 -->
				<span class="col-8 d-flex align-items-center text-reset text-decoration-none" title="해당 광고 링크가 존재하지 않습니다">
					<!-- 광고 이미지는 테이블을 뚫고 나가지 않도록, img-fluid 클래스가 크기를 자동으로 리사이징해줍니다 -->
					<img class="img-fluid border" src="<%=request.getContextPath()%>/image/1.jpg">
				</span>
			</div>
			
			<!-- 
				* 추천 카테고리 표시 부분
			 -->
			<hr>
			
			<div class="mr-3 mt-4">
				<h4 class="font-weight-bolder mt-2">추천 카테고리</h4>
			</div>
			<div class="row mt-4 mb-5">
				<%
					for (Category c : categoryListRecommend) {
				%>
					<div class="col text-center align-middle">
						<a href="<%=request.getContextPath()%>/product/productList.jsp?searchCategoryId=<%=c.getCategoryId()%>" title="<%=c.getCategoryName()%>">
							<!-- img-fluid 속성으로 이미지 크기를 테이블에 맞게 재조정, border 속성으로 테두리를 주었습니다 -->
							<img class="img-fluid rounded-circle border" src="<%=request.getContextPath()%>/image/<%=c.getCategoryPic()%>">
						</a>
					</div>
				<%
					}
				%>
			</div>
			
			<!-- 
				* 오늘의 추천상품 표시 부분
			 -->
			<hr>
			
			<div class="mb-3">
				<!-- 
					d-inline-flex는 한 줄에 두개가 존재할수 없는 블럭 요소들
					예를들어 div, h2를 같은 줄에 못쓰는것처럼
					그런 블럭 요소들을 묶어서 한 줄에 span처럼 따닥따닥 붙여서 출력해줄 수 있게 하는
					기능을 가지고 있습니다
					
					이를 활용해서 h4와 span badge를 한 줄에 출력하게 만들었습니다
				 -->
				<div class="d-inline-flex align-items-center my-2">
					<div class="mr-3">
						<!-- 
							뱃지와 세로 간격을 맞추기 위해(h태그는 기본적으로 아랫쪽 등에 마진이 들어가있습니다)
							mt-2로 글자 위에 마진을 주어서, 글자가 상대적으로 중앙에 위치하도록 만들었습니다
						 -->
						<h4 class="font-weight-bolder">오늘의 추천상품</h4>
					</div>
					
					<!-- 뱃지는 현재 날짜를 출력해줍니다, 또한 badge-pill로 모서리를 매우 둥글게 만들었습니다 -->
					<div class="mr-3">
						<span class="badge badge-pill badge-primary">
							<%
								// 현재 날짜와 시간에 대한 상세 정보를 가져옵니다
								Calendar today = Calendar.getInstance();
								
								// 이후, 아래에서 년도/월/일 데이터만 가져와서 출력해줍니다
							%>
							<%=today.get(Calendar.YEAR) %>.<%=today.get(Calendar.MONTH)+1 %>.<%=today.get(Calendar.DAY_OF_MONTH) %>
						</span>
					</div>
				</div>
				
				<!-- 
					* 오늘의 추천상품을 찾기 위한 카테고리 표시 부분
				 -->
				<div class="row">
					<div class="col my-2">
						<%
							String categoryClasses = "";
							if (searchCategoryId == -1) {
								categoryClasses = "btn btn-primary btn-block";
							} else {
								categoryClasses = "btn btn-secondary btn-block";
							}
						%>
						<a class="<%=categoryClasses%>" href="<%=request.getContextPath()%>/index.jsp">전체</a>
					</div>
					<%
						for (Category c : categoryListSample) {
							categoryClasses = "";
							if (searchCategoryId == c.getCategoryId()) {
								categoryClasses = "btn btn-primary btn-block";
							} else {
								categoryClasses = "btn btn-secondary btn-block";
							}
					%>
							<!-- 혹여나 카테고리가 많아서 다음줄로 넘어간다 하더라도 세로 마진을 줌으로써 버튼이 따닥따닥 붙는 현상을 줄이려고 했습니다 -->
							<div class="col my-2">
								<a class="<%=categoryClasses%>" href="<%=request.getContextPath()%>/index.jsp?searchCategoryId=<%=c.getCategoryId()%>"><%=c.getCategoryName() %></a>
							</div>
					<%
						}
					%>
				</div>
				
				<!-- 
					* 오늘의 추천 상품 카드를 보여주는 부분
				 -->
				<%
					ListPage productListPage = new ListPage();
							productListPage.setCurrentPage(1);
							productListPage.setRowPerPage(6);
							
							Product paramProduct = new Product();
							paramProduct.setCategoryId(searchCategoryId);
							paramProduct.setProductName("");
							
							ProductDao productDao = new ProductDao();
							ArrayList<ProductAndCategory> productList = productDao.selectProductListWithPageAndSearch(productListPage, paramProduct);
				%>
				<div class="row my-2">
						<%
							int i = 0;
							for (ProductAndCategory pac : productList) {
								// 카드가 3개 표시될때마다 다음 줄에 카드를 표시하도록 해줍니다
								if (i%3 == 0) {
									// 행을 닫았다 염으로써 다음 줄에 카드가 표시되도록 유도합니다
						%>
									</div><div class="row">
						<%	
								}
						%>
								<div class="col-4">
									<!-- 
										card 클래스로 간단하게 그림이 그려진 카드를 출력할 수 있습니다!
										
										또한, card 클래스는 기본적으로 테두리를 포함하기에
										테두리를 없애기 위해 border-0을 사용했고,
										
										카드 내용물이 딱 붙어있으면 갑갑해 보이므로 패딩(p-3)을 줬습니다
									 -->
									<!-- 또한 카드 전체에 링크를 걸기 위해 div 태그 대신 a 태그를 사용합니다 -->
									<a class="card mb-4 p-3 bg-light border-0 text-reset text-decoration-none" href="<%=request.getContextPath()%>/product/productOne.jsp?productId=<%=pac.getProduct().getProductId()%>">
										<img class="card-img-top border" src="<%=request.getContextPath()%>/image/<%=pac.getProduct().getProductPic()%>" alt="<%=pac.getProduct().getProductName()%>">
										<div class="card-body">
											<!-- 
												mt나 mb, mx 등 마진 설정에 대해선 익숙하리라 봅니다
												하지만 여기 나온 n1, n3은 뭐냐고 물으실 수 있습니다
												
												n은 negative의 약자입니다, 마진을 마이너스값으로 준다는 의미이구요
												그러니까 여백을 없애겠다는 의미입니다
												
												기본적으로 h태그는 여백을 무진장 남기기 때문에
												이 쓸데없는 여백을 없애기 위해 mt-n2등을 사용했습니다
											 -->
											<h6 class="card-title text-right mx-n3 mt-n2 mb-n1"><%=pac.getProduct().getProductName() %></h6>
											<%
												if (pac.getProduct().getProductSoldout().equals("Y")) {
											%>
													<h4 class="card-text text-left mx-n3 mt-n1 mb-n3 text-secondary">품절</h4>
											<%
												} else {
											%>
													<h4 class="card-text text-left mx-n3 mt-n1 mb-n3"><%=pac.getProduct().getProductPrice() %>원</h4>
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
			</div>
			
			<!-- 
				* 공지사항 부분
			 -->
			<hr>
			
			<%
				NoticeDao noticeDao = new NoticeDao();
				ArrayList<Notice> noticeList = noticeDao.selectNoticeListLatest();
			%>
			<div class="container-lg">
				<div class="d-flex">
					<div class="mr-4">
						<h6 class="font-weight-bolder">공지사항</h6>
					</div>
					
					<div class="mr-4 small font-weight-lighter">
						<ul>
							<%
								for (Notice n : noticeList) {
							%>
									<li><a class="text-reset" href="<%=request.getContextPath()%>/notice/noticeOne.jsp?noticeId=<%=n.getNoticeId()%>"><%=n.getNoticeTitle() %></a></li>
							<%
								}
							%>
						</ul>
					</div>
				</div>
			</div>
		</div>
		 
		<!-- 가로선을 위해 hr태그를 넣었습니다 -->
		<hr>
		
		<!-- 
			* 하단 바 표시 부분
		 -->
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