package listener;

import java.util.Calendar;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import dao.TotalUserCountDao;

@WebListener
public class UserCountListener implements ServletContextListener, HttpSessionListener {
	// 유저 카운트 리스너 내부에서 사용할 application 객체
	// application 객체의 값은 톰캣이 켜져있는동안 유지됨
	ServletContext application;
	
	@Override
	public void contextInitialized(ServletContextEvent event) {
		System.out.println("mall 프로젝트 실행됨");
		
		// mall 프로젝트 등록 시 application을 가져와서 유저 카운트 리스너 전체에 쓸 수 있도록 등록
		application = event.getServletContext();
		
		// 유저 카운트 초기화
		application.setAttribute("currentUserCount", 0);
		application.setAttribute("todayUserCount", 0);
		
		// 마지막 액세스 날짜 초기화
		String currentDate= getCurrentDate();
		application.setAttribute("lastAccessDate", currentDate);
	}
	
	@Override
	public void sessionCreated(HttpSessionEvent event) {
		System.out.println("세션 생성됨");
		
		// 일단 지금 집계된 현재 유저 수랑 오늘 유저 수를 가져오고
		int currentUser = (Integer) application.getAttribute("currentUserCount");
		int todayUser = (Integer) application.getAttribute("todayUserCount");
		
		// 현재 날짜랑 마지막으로 액세스한 날짜를 비교해서...
		String currentDate = getCurrentDate();
		String lastAccessDate = (String) application.getAttribute("lastAccessDate");
		System.out.println(currentDate+"<-currentDate");
		System.out.println(lastAccessDate+"<-lastAccessDate");
		
		// 만약 날짜가 바뀌였다면(다음 날 자정이 지났다면) 오늘자 유저 수 집계를 초기화하고
		if (!currentDate.equals(lastAccessDate)) {
			application.setAttribute("todayUserCount", 0);
			
			// 마지막 접속 날짜를 갱신해 준 뒤
			application.setAttribute("lastAccessDate", currentDate);
		}
		
		// 집계된 수에 1을 더하고
		currentUser += 1;
		todayUser += 1;
		
		// 방문자 한명 추가되었으니 그 값을 application 객체에 반영함
		application.setAttribute("currentUserCount", currentUser);
		application.setAttribute("todayUserCount", todayUser);
		
		// 마지막으로 DB에 전체 방문자 수 집계를 올림
		try {
			TotalUserCountDao totalUserCountDao = new TotalUserCountDao();
			totalUserCountDao.updateUserCountAddOne();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("전체 방문자 수 집계에 무언가 문제가 발생했습니다. 상단 스택 트레이스를 확인해주세요!!");
		}
	}
	
	@Override
	public void sessionDestroyed(HttpSessionEvent event) {
		System.out.println("세션 소멸됨");
		
		// 일단 지금 집계된 현재 유저 수를 가져와서
		int currentUser = (Integer) application.getAttribute("currentUserCount");
		
		// 집계된 수에 1을 뺀 뒤
		currentUser -= 1;
		
		// 세션에 해당되는 유저가 웹 페이지에서 장시간 반응이 없었거나 나갔다는 걸 application 객체에 반영함
		application.setAttribute("currentUserCount", currentUser);
	}

	@Override
	public void contextDestroyed(ServletContextEvent event) {
		System.out.println("mall 프로젝트 실행 종료됨");
		
		// mall 프로젝트가 리로드되거나 종료될때 실행하는 부분
		// 사실 이 때 전체 방문자 수를 기록하고 싶었으나
		// 톰캣이 강제종료되면 얘도 소용없을거라 판단, 그런 무모한 도전은 하지 않음
	}
	
	// 현재 날짜를 문자열로 출력하는 메서드
	public String getCurrentDate() {
		Calendar calendar = Calendar.getInstance();
		
		// 2020-10-08같이 0000-00-00 템플릿의 String을 출력함
		return calendar.get(Calendar.YEAR) + "-"
				+ String.format("%02d", calendar.get(Calendar.MONTH)+1) + "-"
				+ String.format("%02d", calendar.get(Calendar.DAY_OF_MONTH));
	}
}
