<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	if (session.getAttribute("loginMemberEmail") == null) {
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	request.setCharacterEncoding("UTF-8");
	System.out.println(request.getParameter("currentMemberPw")+"<-request.getParameter(\"currentMemberPw\")");
	System.out.println(request.getParameter("newMemberPw")+"<-request.getParameter(\"newMemberPw\")");
	System.out.println(request.getParameter("newMemberPwConfirm")+"<-request.getParameter(\"newMemberPwConfirm\")");
	
	Member paramMember = new Member();
	paramMember.setMemberEmail((String)(session.getAttribute("loginMemberEmail")));
	paramMember.setMemberPw(request.getParameter("currentMemberPw"));
	
	String newMemberPw = "";
	if (request.getParameter("newMemberPw") != null) {
		newMemberPw = request.getParameter("newMemberPw");
	}
	
	String newMemberPwConfirm = "";
	if (request.getParameter("newMemberPwConfirm") != null) {
		newMemberPwConfirm = request.getParameter("newMemberPwConfirm");
	}
	
	MemberDao memberDao = new MemberDao();
	
	if (memberDao.login(paramMember) == null) {
		response.sendRedirect(request.getContextPath()+"/member/editMemberPw.jsp?validateFailed=true");
		return;
	}
	
	paramMember.setMemberPw(request.getParameter("newMemberPw"));
	if (!newMemberPwConfirm.equals(paramMember.getMemberPw())) {
		response.sendRedirect(request.getContextPath()+"/member/editMemberPw.jsp?pwConfirmFailed=true");
	} else {
		memberDao.updateMemberPw(paramMember);
		
		response.sendRedirect(request.getContextPath()+"/member/editMemberPw.jsp?pwChangeSuccess=true");
	}
%>