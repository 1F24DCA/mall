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
		// Tomcat 실행 시 application을 가져와서 유저 카운트 리스너 전체에 쓸 수 있도록 등록
		application = event.getServletContext();
		
		// 유저 카운트 초기화
		application.setAttribute("currentUserCount", 0);
		application.setAttribute("todayUserCount", 0);
		
		// 마지막 액세스 시간 초기화
		int currentHour = getCurrentHour();
		application.setAttribute("lastAccessHour", currentHour);
	}
	
	@Override
	public void sessionCreated(HttpSessionEvent event) {
		// 일단 지금 집계된 현재 유저 수랑 오늘 유저 수를 가져와서
		int currentUser = (Integer) application.getAttribute("currentUserCount");
		int todayUser = (Integer) application.getAttribute("todayUserCount");
		
		// 현재 시간이랑 마지막으로 액세스한 시간을 비교해서...
		int currentHour = getCurrentHour();
		int lastAccessHour = (Integer) application.getAttribute("lastAccessHour");
		System.out.println(currentHour+"<-currentHour");
		System.out.println(lastAccessHour+"<-lastAccessHour");
		
		// 만약 다음 날 자정이 지났다면 오늘자 유저 수 집계를 초기화하고
		if (currentHour < lastAccessHour) {
			application.setAttribute("todayUserCount", 0);
		}
		
		// 마지막 접속 시간을 갱신해 준 뒤
		application.setAttribute("lastAccessHour", currentHour);
		
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
		// 일단 지금 집계된 현재 유저 수를 가져와서
		int currentUser = (Integer) application.getAttribute("currentUserCount");
		
		// 집계된 수에 1을 뺀 뒤
		currentUser -= 1;
		
		// 세션에 해당되는 유저가 웹 페이지에서 장시간 반응이 없었거나 나갔다는 걸 application 객체에 반영함
		application.setAttribute("currentUserCount", currentUser);
	}

	@Override
	public void contextDestroyed(ServletContextEvent event) {
		// 톰캣이 꺼졌을 때 해야할 일은 따로 없음
		// 사실 이 때 전체 방문자 수를 기록하고 싶었으나
		// 톰캣이 강제종료되면 얘도 소용없을거라 판단, 그런 무모한 도전은 하지 않음
	}
	
	// 현재 시간(0시~23시)를 출력하는 메서드
	public int getCurrentHour() {
		Calendar calendar = Calendar.getInstance();
		
		// Calendar.HOUR만 하면 12시간제로 등록되므로 00:00:00부터 23:59:59까지 적용시키는 HOUR_OF_DAY를 사용함
		return calendar.get(Calendar.HOUR_OF_DAY);
	}
}
