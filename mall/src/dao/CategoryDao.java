package dao;

import java.util.ArrayList;
import java.sql.*;

import commons.DBUtil;
import commons.ListPage;
import vo.*;

public class CategoryDao {
	public ArrayList<Category> selectCategoryListWithPage(ListPage listPage) throws Exception {
		ArrayList<Category> returnList = new ArrayList<Category>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT category_id, category_name FROM category LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, listPage.getQueryIndex());
		stmt.setInt(2, listPage.getRowPerPage());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			Category category = new Category();
			category.setCategoryId(rs.getInt("category_id"));
			category.setCategoryName(rs.getString("category_name"));
			
			returnList.add(category);
		}
		
		conn.close();
		
		return returnList;
	}
	
	public ArrayList<Category> selectCategoryListRecommend() throws Exception {
		ArrayList<Category> returnList = new ArrayList<Category>();
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT category_id, category_name, category_pic FROM category WHERE category_ck='Y' LIMIT 10, 4";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			Category category = new Category();
			category.setCategoryId(rs.getInt("category_id"));
			category.setCategoryName(rs.getString("category_name"));
			category.setCategoryPic(rs.getString("category_pic"));
			
			returnList.add(category);
		}
		
		conn.close();
		
		return returnList;
	}
}
