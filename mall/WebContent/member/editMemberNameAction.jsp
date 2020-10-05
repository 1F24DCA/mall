<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	if (session.getAttribute("loginMemberEmail") == null) {
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	request.setCharacterEncoding("UTF-8");
	System.out.println(request.getParameter("memberName")+"<-request.getParameter(\"memberName\")");
	
	Member paramMember = new Member();
	paramMember.setMemberEmail((String)(session.getAttribute("loginMemberEmail")));
	paramMember.setMemberName(request.getParameter("memberName"));
	
	MemberDao memberDao = new MemberDao();
	memberDao.updateMemberName(paramMember);
	
	response.sendRedirect(request.getContextPath()+"/member/memberOne.jsp");
%>