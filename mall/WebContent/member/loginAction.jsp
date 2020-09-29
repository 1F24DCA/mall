<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*"%>
<%
	if (session.getAttribute("loginMemberEmail") != null) {
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}

	request.setCharacterEncoding("UTF-8");
	System.out.println(request.getParameter("memberEmail")+"<-request.getParameter(\"memberEmail\")");
	System.out.println(request.getParameter("memberPw")+"<-request.getParameter(\"memberPw\")");
	
	Member paramMember = new Member();
	paramMember.setMemberEmail(request.getParameter("memberEmail"));
	paramMember.setMemberPw(request.getParameter("memberPw"));
	
	MemberDao memberDao = new MemberDao();
	Member loginMember = memberDao.login(paramMember);
	Member deletedMember = memberDao.selectMemberDeletedCheck(paramMember);
	if (loginMember == null || (deletedMember != null && !deletedMember.getDeletedBy().equals("활동중"))) {
		response.sendRedirect(request.getContextPath()+"/member/login.jsp?loginFailed=true");
	} else {
		session.setAttribute("loginMemberEmail", loginMember.getMemberEmail());
		
		response.sendRedirect(request.getContextPath()+"/index.jsp");
	}
%>