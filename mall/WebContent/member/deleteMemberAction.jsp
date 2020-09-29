<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	if (session.getAttribute("loginMemberEmail") == null) {
		response.sendRedirect(request.getContextPath()+"/member/login.jsp?loginRequired=true");
		return;
	}

	request.setCharacterEncoding("UTF-8");
	System.out.println(request.getParameter("memberPw")+"<-request.getParameter(\"memberPw\")");
	
	Member paramMember = new Member();
	paramMember.setMemberEmail((String)(session.getAttribute("loginMemberEmail")));
	paramMember.setMemberPw(request.getParameter("memberPw"));
	
	MemberDao memberDao = new MemberDao();
	if (memberDao.login(paramMember) == null) {
		response.sendRedirect(request.getContextPath()+"/member/deleteMember.jsp?validateFailed=true");
	} else {
		memberDao.deleteMember(paramMember);
		
		response.sendRedirect(request.getContextPath()+"/member/logoutAction.jsp");
	}
%>