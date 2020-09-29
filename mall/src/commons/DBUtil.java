package commons;

// JDBC 써서 쩌기 MariaDB랑 연결할거야!
// 근데 JDBC마다 사용법이 다르면 곤란하잖아? DB바꿀때마다 사용설명서를 딸딸딸 외워야하는 그런 웃긴 상황도 생길수있다구?
// Class.forName()만 써주면 JDBC 안가리고 자바에서 쓸 수 있게 범용적인 SQL 사용을 위한 클래스들이 있어!
// 그게 바로 java.sql 패키지의 클래스들이지! 이거 덕분에 DB바꿔도 자바에선 편하게 원래 쓰던대로 쓸수있지롱!
import java.sql.*;

/*
 * class DBUtil
 * 	DB 관련 중복되는 메서드가 DAO에 너무 많더라고! 그래서 코드 중복 없앨 겸..
 * 	DB 주소나 아이디 비번이 여기저기 뿌려져 있으면 나중에 고치기 힘드니까
 * 	유지보수 좀 편하게 해보려고 만든 클래스야
 */
public class DBUtil {
	
	/*
	 * Connection getConnection()
	 * 	DB 주소랑 DB 계정을 가지고 자바 코드로 DB를 쓸 수 있게 연결해주는 메서드야
	 * 
	 * 	원래는 DB 연결은 막 검은색 명령프롬프트창에서만 할 수 있었잖아?
	 * 
	 * 	하지만 java.sql.Connection같은 자바 sql 패키지랑
	 * 	MariaDB JDBC 라이브러리(jar파일 넣은거 있잖아!) 두개 갖고있으면
	 * 	명령프롬프트에서만 끄적거리던 쿼리실행을 자바 코드로 할수있게 해주는거지!
	 * 
	 * 	그런데 왜 이게 메서드로 빠졌냐고? 기존엔 막 코드마다 몇십번씩 적어댔잖아!
	 * 	그렇게 하면 나중에 DB 패스워드 바꿨을때 파일 싹다찾아서 바꿔야 하잖아... 불편하겠지?
	 * 	파일이 100개 넘어가면...어우...끔찍해라...
	 * 
	 * 	아무튼 그런 의미로 만든 메서드야! 잘 써주길 바라!
	 * 
	 * 매개변수 (0개): 
	 * 	매개변수 만들라면 뭐 연결할 주소나 아이디 비번등을 받을수 있긴한데, 그렇게 해서 얻을게 없잖아?
	 * 	그래서 안넣었어! 기왕 만든거 편하게 좀 써야지!
	 * 
	 * 리턴값 (Connection 타입):
	 * 	뭐 DB 프로그램이 갑자기 뻗어버린다던가 그런 이상한 일이 일어나지 않는 이상
	 * 	Connection 객체를 반환할거야! 이 객체에서 늘 써왔듯이
	 * 	conn.prepareStatement(쿼리문) 같은 메서드 써서 쿼리문을 작성할 수 있을거야!
	 */
	public Connection getConnection() throws Exception {
		// 연결할 DB의 주소와 계정 정보가 담겨있어! 나중에 DB를 다른걸로 이사한다면 바꿔주는 게 좋겠지?
		String driver = "org.mariadb.jdbc.Driver";
		String dbaddr = "jdbc:mariadb://localhost:3306/mall";
		String dbid = "root";
		String dbpw = "java1004";
		
		// 자바한테 나 driver 사용한다! 알려주는거야! DB쓰려면 무슨 DB쓰는지 알려줘야 할 정도로 컴퓨터가 멍청하단 뜻이지!
		Class.forName(driver);
		
		// dbaddr에 명시된 주소를 통해서 코드랑 DB랑 연결시킬거야! DB를 MS-SQL을 쓰던 MariaDB를 쓰던 Oracle을 쓰던 상관없이
		// 나는 java.sql.Connection 객체로 스무-쓰하게 쓸 수 있게 되는거지!
		Connection conn = DriverManager.getConnection(dbaddr, dbid, dbpw);
		
		return conn;
	}
}
