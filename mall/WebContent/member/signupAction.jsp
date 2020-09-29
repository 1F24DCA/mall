<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	if (session.getAttribute("loginMemberEmail") != null) {
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	request.setCharacterEncoding("UTF-8");
	System.out.println(request.getParameter("memberEmail")+"<-request.getParameter(\"memberEmail\")");
	System.out.println(request.getParameter("memberPw")+"<-request.getParameter(\"memberPw\")");
	System.out.println(request.getParameter("memberPwConfirm")+"<-request.getParameter(\"memberPwConfirm\")");
	System.out.println(request.getParameter("memberName")+"<-request.getParameter(\"memberName\")");
	
	Member paramMember = new Member();
	paramMember.setMemberEmail(request.getParameter("memberEmail"));
	paramMember.setMemberPw(request.getParameter("memberPw"));
	paramMember.setMemberName(request.getParameter("memberName"));
	
	String memberPwConfirm = "";
	if (request.getParameter("memberPwConfirm") != null) {
		memberPwConfirm = request.getParameter("memberPwConfirm");
	}
	
	MemberDao memberDao = new MemberDao();
	Member loginMember = memberDao.selectMemberEmailCheck(paramMember);
	Member deletedMember = memberDao.selectMemberDeletedCheck(paramMember);
	if (loginMember != null) {
		response.sendRedirect(request.getContextPath()+"/member/signup.jsp?emailUnusable=true");
		return;
	}
	
	if (!memberPwConfirm.equals(paramMember.getMemberPw())) {
		response.sendRedirect(request.getContextPath()+"/member/signup.jsp?pwConfirmFailed=true");
		return;
	}
	
	memberDao.insertMember(paramMember);
	
	response.sendRedirect(request.getContextPath()+"/member/login.jsp?signupSuccess=true");
%>