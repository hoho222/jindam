package doto.common.logger;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import doto.common.logger.CommonInterceptor;
import doto.dao.FrontDAO;

public class CommonInterceptor extends HandlerInterceptorAdapter{
	protected Log log = LogFactory.getLog(CommonInterceptor.class);
	
	@Resource(name="frontDAO")
	private FrontDAO frontDAO;
	
	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		String requestUrl = request.getRequestURL().toString();
		
		
        if (log.isDebugEnabled()) {
            log.debug("======================================          FRONT interceptor START         ======================================");
            log.debug(" Request URI \t:  " + request.getRequestURI());
        }
        
        HttpSession session = request.getSession();
        String sessionEmail = (String)session.getAttribute("loginEmail");
        String sessionAdminId = (String)session.getAttribute("adminLoginId");
        String sessionAdminName = (String)session.getAttribute("adminLoginName");
        
        if(requestUrl.contains("/users") || requestUrl.contains("/messages") || requestUrl.contains("/items")){
        	if(!requestUrl.contains("/login") && !requestUrl.contains("/join") && !requestUrl.contains("/admin/items") && !requestUrl.contains("/adreward")){
	        	//회원 관련된 mapping일 때는 로그인 여부를 체크해야함.
		        if(sessionEmail == null){
		        	//로그인 안된 상태이면 로그인 페이지로 이동
		        	response.sendRedirect("/LOLweb/index"); 
					return false;
		        }
        	}
        }
        
        //어드민만 접근 가능한 url
        if(requestUrl.contains("/matching")){
        	//매칭알고리즘 mapping일 때는 어드민 로그인 여부를 체크해야함.
	        if(sessionAdminId == null || sessionAdminName == null){
	        	//로그인 안된 상태이면 로그인 페이지로 이동
	        	response.sendRedirect("/LOLweb/index"); 
				return false;
	        }
        }
        
        return super.preHandle(request, response, handler);
    }
     
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        if (log.isDebugEnabled()) {
            log.debug("======================================           FRONT interceptor END          ======================================\n");
        }
    }
}
