package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import vo.PostVO;

public class PostDAO {
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	public ArrayList<PostVO> getAddress(String search) throws SQLException {
		Context envContext = null;
		ArrayList<PostVO> list = new ArrayList<PostVO>();
		try {
			envContext = new InitialContext();
			Context initContext = (Context) envContext.lookup("java:/comp/env");
			DataSource ds = (DataSource) initContext.lookup("jdbc/gpsdb");
			Connection con = ds.getConnection();
			
			PreparedStatement pstmt = con.prepareStatement(
				"SELECT gpsdata.cname, date, gtime, address, name, phone FROM gpsdata left join user on gpsdata.cname = user.cname WHERE gpsdata.address LIKE '%"+search+"%'");
			rs = pstmt.executeQuery();

			while (rs.next()) {
				PostVO vo = new PostVO();
				vo.setCname(rs.getString("cname"));
				vo.setDate(rs.getString("date"));
				vo.setGtime(rs.getString("gtime"));
				vo.setAddress(rs.getString("address"));	
				vo.setName(rs.getString("name"));
				vo.setPhone(rs.getString("phone"));
				list.add(vo);
			}

			return list;

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return list;
	}
}