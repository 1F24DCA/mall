package dao;

import java.util.*;
import java.sql.*;

import commons.*;
import vo.*;

public class OrdersDao {
	public ArrayList<OrdersAndProduct> selectOrdersListWithPageDescSearchByMemberEmail(ListPage listPage, Orders paramOrders) throws Exception {
		ArrayList<OrdersAndProduct> returnList = new ArrayList<OrdersAndProduct>();

		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT orders.orders_id, orders.orders_date, orders.product_id, product.product_name, orders.orders_amount, orders.orders_price, orders.member_email, orders.orders_addr, orders.orders_state, product.product_pic "
					+"FROM orders INNER JOIN product ON orders.product_id=product.product_id WHERE orders.member_email=? ORDER BY orders.orders_id DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramOrders.getMemberEmail());
		stmt.setInt(2, listPage.getQueryIndex());
		stmt.setInt(3, listPage.getRowPerPage());
		System.out.println(stmt+"<-stmt");

		ResultSet rs = stmt.executeQuery();
		while (rs.next()) {
			OrdersAndProduct ordersAndProduct = new OrdersAndProduct();
			ordersAndProduct.setOrders(new Orders());
			ordersAndProduct.setProduct(new Product());
			
			ordersAndProduct.getOrders().setOrdersId(rs.getInt("orders.orders_id"));
			ordersAndProduct.getOrders().setOrdersDate(rs.getString("orders.orders_date"));
			ordersAndProduct.getOrders().setProductId(rs.getInt("orders.product_id"));
			ordersAndProduct.getProduct().setProductName(rs.getString("product.product_name"));
			ordersAndProduct.getOrders().setOrdersAmount(rs.getInt("orders.orders_amount"));
			ordersAndProduct.getOrders().setOrdersPrice(rs.getInt("orders.orders_price"));
			ordersAndProduct.getOrders().setMemberEmail(rs.getString("orders.member_email"));
			ordersAndProduct.getOrders().setOrdersAddr(rs.getString("orders.orders_addr"));
			ordersAndProduct.getOrders().setOrdersState(rs.getString("orders.orders_state"));
			ordersAndProduct.getProduct().setProductPic(rs.getString("product.product_pic"));
			
			returnList.add(ordersAndProduct);
		}
		
		conn.close();
		
		return returnList;
	}

	public OrdersAndProduct selectOrdersAndProductOne(Orders paramOrders) throws Exception {
		OrdersAndProduct returnOrdersAndProduct = new OrdersAndProduct();
		returnOrdersAndProduct.setOrders(new Orders());
		returnOrdersAndProduct.setProduct(new Product());
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT orders.orders_date, orders.product_id, product.product_name, orders.orders_amount, orders.orders_price, orders.member_email, orders.orders_addr, orders.orders_state "
					+"FROM orders INNER JOIN product ON orders.product_id=product.product_id WHERE orders_id=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, paramOrders.getOrdersId());
		System.out.println(stmt+"<-stmt");

		ResultSet rs = stmt.executeQuery();
		if (rs.next()) {
			returnOrdersAndProduct.getOrders().setOrdersId(paramOrders.getOrdersId());
			returnOrdersAndProduct.getOrders().setOrdersDate(rs.getString("orders.orders_date"));
			returnOrdersAndProduct.getOrders().setProductId(rs.getInt("orders.product_id"));
			returnOrdersAndProduct.getProduct().setProductName(rs.getString("product.product_name"));
			returnOrdersAndProduct.getOrders().setOrdersAmount(rs.getInt("orders.orders_amount"));
			returnOrdersAndProduct.getOrders().setOrdersPrice(rs.getInt("orders.orders_price"));
			returnOrdersAndProduct.getOrders().setMemberEmail(rs.getString("orders.member_email"));
			returnOrdersAndProduct.getOrders().setOrdersAddr(rs.getString("orders.orders_addr"));
			returnOrdersAndProduct.getOrders().setOrdersState(rs.getString("orders.orders_state"));
		}
		
		conn.close();
		
		return returnOrdersAndProduct;
	}
	
	public void insertOrders(Orders orders) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "INSERT INTO orders(product_id, orders_amount, orders_price, member_email, orders_addr, orders_state, orders_date) VALUES(?, ?, ?, ?, ?, '결제완료', NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orders.getProductId());
		stmt.setInt(2, orders.getOrdersAmount());
		stmt.setInt(3, orders.getOrdersPrice());
		stmt.setString(4, orders.getMemberEmail());
		stmt.setString(5, orders.getOrdersAddr());
		
		stmt.executeUpdate();
		
		conn.close();
	}
}
