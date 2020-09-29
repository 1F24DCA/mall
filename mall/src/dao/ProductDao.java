package dao;

import java.sql.*;
import java.util.*;

import commons.*;
import vo.*;

public class ProductDao {
	public ArrayList<ProductAndCategory> selectProductListWithPage(ListPage listPage) throws Exception {
		ArrayList<ProductAndCategory> returnList = new ArrayList<ProductAndCategory>();
	
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT product.product_id, product.category_id, category.category_name, product.product_name, product.product_price, product.product_soldout, product.product_pic "
					+"FROM product INNER JOIN category ON product.category_id=category.category_id LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, listPage.getQueryIndex());
		stmt.setInt(2, listPage.getRowPerPage());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			ProductAndCategory productAndCategory = new ProductAndCategory();
			productAndCategory.setProduct(new Product());
			productAndCategory.setCategory(new Category());
			productAndCategory.getProduct().setProductId(rs.getInt("product.product_id"));
			productAndCategory.getProduct().setCategoryId(rs.getInt("product.category_id"));
			productAndCategory.getCategory().setCategoryName(rs.getString("category.category_name"));
			productAndCategory.getProduct().setProductName(rs.getString("product.product_name"));
			productAndCategory.getProduct().setProductPrice(rs.getInt("product.product_price"));
			productAndCategory.getProduct().setProductSoldout(rs.getString("product.product_soldout"));
			productAndCategory.getProduct().setProductPic(rs.getString("product.product_pic"));
			
			returnList.add(productAndCategory);
		}
		
		conn.close();
		
		return returnList;
	}
	
	public int selectProductCount() throws Exception {
		int returnCount = 0;

		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM product";
		PreparedStatement stmt = conn.prepareStatement(sql);
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			returnCount = rs.getInt("COUNT(*)");
		}
		
		conn.close();
		
		return returnCount;
	}
	
	public ArrayList<ProductAndCategory> selectProductListWithPageAndSearch(ListPage listPage, Product paramProduct) throws Exception {
		if (paramProduct.getCategoryId() == -1 && paramProduct.getProductName().equals("")) {
			return selectProductListWithPage(listPage);
		} else if (paramProduct.getCategoryId() != -1 && paramProduct.getProductName().equals("")) {
			return selectProductListWithPageSearchByCategoryId(listPage, paramProduct);
		} else if (paramProduct.getCategoryId() == -1 && !paramProduct.getProductName().equals("")) {
			return selectProductListWithPageSearchByProductName(listPage, paramProduct);
		} else if (paramProduct.getCategoryId() != -1 && !paramProduct.getProductName().equals("")) {
			return selectProductListWithPageSearchByCategoryIdAndProductName(listPage, paramProduct);
		} else {
			return null;
		}
	}

	public int selectProductCountWithSearch(Product paramProduct) throws Exception {
		if (paramProduct.getCategoryId() == -1 && paramProduct.getProductName().equals("")) {
			return selectProductCount();
		} else if (paramProduct.getCategoryId() != -1 && paramProduct.getProductName().equals("")) {
			return selectProductCountSearchByCategoryId(paramProduct);
		} else if (paramProduct.getCategoryId() == -1 && !paramProduct.getProductName().equals("")) {
			return selectProductCountSearchByProductName(paramProduct);
		} else if (paramProduct.getCategoryId() != -1 && !paramProduct.getProductName().equals("")) {
			return selectProductCountSearchByCategoryIdAndProductName(paramProduct);
		} else {
			return -1;
		}
	}
	
	public ArrayList<ProductAndCategory> selectProductListWithPageSearchByCategoryId(ListPage listPage, Product paramProduct) throws Exception {
		ArrayList<ProductAndCategory> returnList = new ArrayList<ProductAndCategory>();

		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT product.product_id, category.category_name, product.product_name, product.product_price, product.product_soldout, product.product_pic "
					+"FROM product INNER JOIN category ON product.category_id=category.category_id WHERE product.category_id=? LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramProduct.getCategoryId());
		stmt.setInt(2, listPage.getQueryIndex());
		stmt.setInt(3, listPage.getRowPerPage());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			ProductAndCategory productAndCategory = new ProductAndCategory();
			productAndCategory.setProduct(new Product());
			productAndCategory.setCategory(new Category());
			productAndCategory.getProduct().setProductId(rs.getInt("product.product_id"));
			productAndCategory.getProduct().setCategoryId(paramProduct.getCategoryId());
			productAndCategory.getCategory().setCategoryName(rs.getString("category.category_name"));
			productAndCategory.getProduct().setProductName(rs.getString("product.product_name"));
			productAndCategory.getProduct().setProductPrice(rs.getInt("product.product_price"));
			productAndCategory.getProduct().setProductSoldout(rs.getString("product.product_soldout"));
			productAndCategory.getProduct().setProductPic(rs.getString("product.product_pic"));
			
			returnList.add(productAndCategory);
		}
		
		conn.close();
		
		return returnList;
	}
	
	public int selectProductCountSearchByCategoryId(Product paramProduct) throws Exception {
		int returnCount = 0;

		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM product WHERE category_id=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramProduct.getCategoryId());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			returnCount = rs.getInt("COUNT(*)");
		}
		
		conn.close();
		
		return returnCount;
	}
	
	public ArrayList<ProductAndCategory> selectProductListWithPageSearchByProductName(ListPage listPage, Product paramProduct) throws Exception {
		ArrayList<ProductAndCategory> returnList = new ArrayList<ProductAndCategory>();

		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT product.product_id, product.category_id, category.category_name, product.product_name, product.product_price, product.product_soldout, product.product_pic "
					+"FROM product INNER JOIN category ON product.category_id=category.category_id WHERE product.product_name LIKE ? LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+paramProduct.getProductName()+"%");
		stmt.setInt(2, listPage.getQueryIndex());
		stmt.setInt(3, listPage.getRowPerPage());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			ProductAndCategory productAndCategory = new ProductAndCategory();
			productAndCategory.setProduct(new Product());
			productAndCategory.setCategory(new Category());
			productAndCategory.getProduct().setProductId(rs.getInt("product.product_id"));
			productAndCategory.getProduct().setCategoryId(rs.getInt("product.category_id"));
			productAndCategory.getCategory().setCategoryName(rs.getString("category.category_name"));
			productAndCategory.getProduct().setProductName(rs.getString("product.product_name"));
			productAndCategory.getProduct().setProductPrice(rs.getInt("product.product_price"));
			productAndCategory.getProduct().setProductSoldout(rs.getString("product.product_soldout"));
			productAndCategory.getProduct().setProductPic(rs.getString("product.product_pic"));
			
			returnList.add(productAndCategory);
		}
		
		conn.close();
		
		return returnList;
	}
	
	public int selectProductCountSearchByProductName(Product paramProduct) throws Exception {
		int returnCount = 0;

		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM product WHERE product_name LIKE ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+paramProduct.getProductName()+"%");
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			returnCount = rs.getInt("COUNT(*)");
		}
		
		conn.close();
		
		return returnCount;
	}
	
	public ArrayList<ProductAndCategory> selectProductListWithPageSearchByCategoryIdAndProductName(ListPage listPage, Product paramProduct) throws Exception {
		ArrayList<ProductAndCategory> returnList = new ArrayList<ProductAndCategory>();

		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT product.product_id, category.category_name, product.product_price, product.product_name, product.product_soldout, product.product_pic "
					+"FROM product INNER JOIN category ON product.category_id=category.category_id "
					+"WHERE product.category_id=? AND product.product_name LIKE ? LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramProduct.getCategoryId());
		stmt.setString(2, "%"+paramProduct.getProductName()+"%");
		stmt.setInt(3, listPage.getQueryIndex());
		stmt.setInt(4, listPage.getRowPerPage());
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			ProductAndCategory productAndCategory = new ProductAndCategory();
			productAndCategory.setProduct(new Product());
			productAndCategory.setCategory(new Category());
			productAndCategory.getProduct().setProductId(rs.getInt("product.product_id"));
			productAndCategory.getProduct().setCategoryId(paramProduct.getCategoryId());
			productAndCategory.getCategory().setCategoryName(rs.getString("category.category_name"));
			productAndCategory.getProduct().setProductName(rs.getString("product.product_name"));
			productAndCategory.getProduct().setProductPrice(rs.getInt("product.product_price"));
			productAndCategory.getProduct().setProductSoldout(rs.getString("product.product_soldout"));
			productAndCategory.getProduct().setProductPic(rs.getString("product.product_pic"));
			
			returnList.add(productAndCategory);
		}
		
		conn.close();
		
		return returnList;
	}
	
	public int selectProductCountSearchByCategoryIdAndProductName(Product paramProduct) throws Exception {
		int returnCount = 0;

		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT COUNT(*) FROM product WHERE category_id=? AND product_name LIKE ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramProduct.getCategoryId());
		stmt.setString(2, "%"+paramProduct.getProductName()+"%");
		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			returnCount = rs.getInt("COUNT(*)");
		}
		
		conn.close();
		
		return returnCount;
	}
	
	public Product selectProductOne(Product paramProduct) throws Exception {
		Product product = null;
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT product_id, product_pic, product_name, product_price, product_content, product_soldout, product_pic FROM product WHERE product_id=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramProduct.getProductId());
		
		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			product = new Product();
			product.setProductId(rs.getInt("product_id"));
			product.setProductPic(rs.getString("product_pic"));
			product.setProductName(rs.getString("product_name"));
			product.setProductPrice(rs.getInt("product_price"));
			product.setProductContent(rs.getString("product_content"));
			product.setProductSoldout(rs.getString("product_soldout"));
			product.setProductPic(rs.getString("product_pic"));
		}
		
		return product;
	}
	
	public ProductAndCategory selectProductAndCategoryOne(Product paramProduct) throws Exception {
		ProductAndCategory returnProductAndCategory = new ProductAndCategory();
		returnProductAndCategory.setProduct(new Product());
		returnProductAndCategory.setCategory(new Category());

		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT product.category_id, category.category_name, product.product_name, product.product_price, product.product_content, product.product_soldout, product.product_pic "
					+"FROM product INNER JOIN category ON product.category_id=category.category_id WHERE product_id=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramProduct.getProductId());

		System.out.println(stmt+"<-stmt");
		
		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			returnProductAndCategory.getProduct().setProductId(paramProduct.getProductId());
			returnProductAndCategory.getProduct().setCategoryId(rs.getInt("product.category_id"));
			returnProductAndCategory.getCategory().setCategoryName(rs.getString("category.category_name"));
			returnProductAndCategory.getProduct().setProductName(rs.getString("product.product_name"));
			returnProductAndCategory.getProduct().setProductPrice(rs.getInt("product.product_price"));
			returnProductAndCategory.getProduct().setProductContent(rs.getString("product.product_content"));
			returnProductAndCategory.getProduct().setProductSoldout(rs.getString("product.product_soldout"));
			returnProductAndCategory.getProduct().setProductPic(rs.getString("product.product_pic"));
		}
		
		conn.close();
		
		return returnProductAndCategory;
	}
}
