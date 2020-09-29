<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="dao.*" %>
<%@ page import="vo.*" %>

<%
	if (session.getAttribute("loginMemberEmail") == null) {
		response.sendRedirect(request.getContextPath()+"/member/login.jsp?loginRequired=true");
		return;
	}

	request.setCharacterEncoding("UTF-8");
	System.out.println(request.getParameter("productId")+"<-request.getParameter(\"productId\"))");
	System.out.println(request.getParameter("ordersAmount")+"<-request.getParameter(\"ordersAmount\"))");
	System.out.println(request.getParameter("productPrice")+"<-request.getParameter(\"productPrice\"))");
	System.out.println(session.getAttribute("loginMemberEmail")+"<-session.getAttribute(\"loginMemberEmail\")");
	System.out.println(request.getParameter("ordersAddr")+"<-request.getParameter(\"ordersAddr\"))");
	
	Orders orders = new Orders();
	orders.setProductId(Integer.parseInt(request.getParameter("productId")));
	orders.setOrdersAmount(Integer.parseInt(request.getParameter("ordersAmount")));
	orders.setOrdersPrice(Integer.parseInt(request.getParameter("productPrice")) * orders.getOrdersAmount());
	orders.setMemberEmail((String)(session.getAttribute("loginMemberEmail")));
	orders.setOrdersAddr(request.getParameter("ordersAddr"));
	
	Product paramProduct = new Product();
	paramProduct.setProductId(Integer.parseInt(request.getParameter("productId")));
	
	ProductDao productDao = new ProductDao();
	Product product = productDao.selectProductOne(paramProduct);
	if (product.getProductSoldout().equals("Y")) {
		response.sendRedirect(request.getContextPath()+"/product/productOne.jsp?productId="+product.getProductId());
		return;
	}
	
	OrdersDao ordersDao = new OrdersDao();
	ordersDao.insertOrders(orders);
	
	response.sendRedirect(request.getContextPath()+"/orders/myOrdersList.jsp");
%>