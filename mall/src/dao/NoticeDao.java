package dao;

import java.util.*;
import java.sql.*;

import commons.*;
import vo.*;

public class NoticeDao {
	public ArrayList<Notice> selectNoticeListWithPageDesc(ListPage listPage) throws Exception {
		ArrayList<Notice> list = new ArrayList<Notice>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT notice_id, notice_date, notice_title FROM notice ORDER BY notice_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, listPage.getQueryIndex());
		stmt.setInt(2, listPage.getRowPerPage());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			Notice notice = new Notice();
			notice.setNoticeId(rs.getInt("notice_id"));
			notice.setNoticeDate(rs.getString("notice_date"));
			notice.setNoticeTitle(rs.getString("notice_title"));
			
			list.add(notice);
		}
		
		conn.close();
		
		return list;
	}
	
	public ArrayList<Notice> selectNoticeListLatest() throws Exception {
		ArrayList<Notice> list = new ArrayList<Notice>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT notice_id, notice_date, notice_title FROM notice ORDER BY notice_date DESC LIMIT 0,2";
		PreparedStatement stmt = conn.prepareStatement(sql);
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			Notice notice = new Notice();
			notice.setNoticeId(rs.getInt("notice_id"));
			notice.setNoticeDate(rs.getString("notice_date"));
			notice.setNoticeTitle(rs.getString("notice_title"));
			
			list.add(notice);
		}
		
		conn.close();
		
		return list;
	}
	
	public Notice selectNoticePrev(Notice paramNotice) throws Exception {
		Notice notice = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT notice_id, notice_date, notice_title FROM notice WHERE notice_id<? ORDER BY notice_id DESC LIMIT 0,1";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramNotice.getNoticeId());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			notice = new Notice();
			notice.setNoticeId(rs.getInt("notice_id"));
			notice.setNoticeDate(rs.getString("notice_date"));
			notice.setNoticeTitle(rs.getString("notice_title"));
		}
		
		conn.close();
		
		return notice;
	}

	public Notice selectNoticeNext(Notice paramNotice) throws Exception {
		Notice notice = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT notice_id, notice_date, notice_title FROM notice WHERE notice_id>? ORDER BY notice_id ASC LIMIT 0,1";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramNotice.getNoticeId());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			notice = new Notice();
			notice.setNoticeId(rs.getInt("notice_id"));
			notice.setNoticeDate(rs.getString("notice_date"));
			notice.setNoticeTitle(rs.getString("notice_title"));
		}
		
		conn.close();
		
		return notice;
	}
	
	public Notice selectNoticeOne(Notice paramNotice) throws Exception {
		Notice notice = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT notice_date, notice_title, notice_content FROM notice WHERE notice_id=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramNotice.getNoticeId());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			notice = new Notice();
			notice.setNoticeId(paramNotice.getNoticeId());
			notice.setNoticeDate(rs.getString("notice_date"));
			notice.setNoticeTitle(rs.getString("notice_title"));
			notice.setNoticeContent(rs.getString("notice_content"));
		}
		
		conn.close();
		
		return notice;
	}
}
