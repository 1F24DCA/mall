package dao;

import java.sql.*;

import commons.*;
import vo.*;

public class MemberDao {
	public Member selectMemberOne(Member paramMember) throws Exception {
		Member returnMember = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT member_email, member_name, member_date FROM member WHERE member_email=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberEmail());
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			returnMember = new Member();
			returnMember.setMemberEmail(rs.getString("member_email"));
			returnMember.setMemberName(rs.getString("member_name"));
			returnMember.setMemberDate(rs.getString("member_date"));
		}
		
		conn.close();
		
		return returnMember;
	}
	
	public Member selectMemberEmailCheck(Member paramMember) throws Exception {
		Member returnMember = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT email FROM (SELECT member_email email FROM member UNION SELECT admin_email email FROM admin) temp_table WHERE email=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberEmail());
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			returnMember = new Member();
			returnMember.setMemberEmail(rs.getString("email"));
		}
		
		conn.close();
		
		return returnMember;
	}
	
	public Member selectMemberDeletedCheck(Member paramMember) throws Exception {
		Member returnMember = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT deleted_by FROM member WHERE member_email=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberEmail());
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			returnMember = new Member();
			returnMember.setDeletedBy(rs.getString("deleted_by"));
		}
		
		conn.close();
		
		return returnMember;
	}
	
	public Member login(Member paramMember) throws Exception {
		Member returnMember = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT member_email FROM member WHERE member_email=? AND member_pw=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberEmail());
		stmt.setString(2, paramMember.getMemberPw());
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			returnMember = new Member();
			returnMember.setMemberEmail(rs.getString("member_email"));
		}
		
		conn.close();
		
		return returnMember;
	}
	
	public void insertMember(Member paramMember) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "INSERT INTO member(member_email, member_pw, member_name, member_date) VALUES(?, ?, ?, NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberEmail());
		stmt.setString(2, paramMember.getMemberPw());
		stmt.setString(3, paramMember.getMemberName());
		System.out.println(stmt+"<-stmt");
		
		stmt.executeUpdate();
		
		conn.close();
	}

	public void updateMemberName(Member paramMember) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE member SET member_name=? WHERE member_email=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberName());
		stmt.setString(2, paramMember.getMemberEmail());
		System.out.println(stmt+"<-stmt");
		
		stmt.executeUpdate();
		
		conn.close();
	}

	public void updateMemberPw(Member paramMember) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE member SET member_pw=? WHERE member_email=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberPw());
		stmt.setString(2, paramMember.getMemberEmail());
		System.out.println(stmt+"<-stmt");
		
		stmt.executeUpdate();
		
		conn.close();
	}

	public void deleteMember(Member paramMember) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE member SET member_pw=?, deleted_by=? WHERE member_email=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "");
		stmt.setString(2, "탈퇴");
		stmt.setString(3, paramMember.getMemberEmail());
		System.out.println(stmt+"<-stmt");
		
		stmt.executeUpdate();
		
		conn.close();
	}
}
