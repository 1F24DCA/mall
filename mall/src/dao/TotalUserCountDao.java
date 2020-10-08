package dao;

import java.sql.*;

import commons.DBUtil;

public class TotalUserCountDao {
	public int selectUserCount() throws Exception {
		int returnUserCount = 0;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT user_count FROM total_user_count";
		PreparedStatement stmt = conn.prepareStatement(sql);
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			returnUserCount = rs.getInt("user_count");
		}
		
		return returnUserCount;
	}
	
	public void updateUserCountAddOne() throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE total_user_count SET user_count=user_count+1";
		PreparedStatement stmt = conn.prepareStatement(sql);
		System.out.println(stmt+"<-stmt");
		
		stmt.executeUpdate();
	}
}
