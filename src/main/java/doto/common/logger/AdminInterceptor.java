package doto.common.logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AdminInterceptor extends HandlerInterceptorAdapter {
protected Log log = LogFactory.getLog(CommonInterceptor.class);
	
	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
        if (log.isDebugEnabled()) {
            log.debug("---------------------------------         ADMIN interceptor START        ---------------------------------");
            log.debug(" Admin) Request URI \t:  " + request.getRequestURI());
        }
        
        String requestUrl = request.getRequestURL().toString();
        HttpSession session = request.getSession();
        
        String sessionId = (String)session.getAttribute("adminLoginId");
        String sessionName = (String)session.getAttribute("adminLoginName");
       
        if(requestUrl.contains("/LOLweb/admin")){
	        if(sessionId == null && sessionName == null){
	        	//로그인 안된 상태이면 로그인 페이지로 이동
	        	if(requestUrl.contains("/LOLweb/admin/login")){
	        		return true;
	        	} else {
		        	response.sendRedirect("/LOLweb/admin/login"); 
					return false;
	        	}
	        }
        }
        
        return super.preHandle(request, response, handler);
    }
     
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        if (log.isDebugEnabled()) {
            log.debug("---------------------------------         ADMIN interceptor END        ---------------------------------\n");
        }
    }
}
