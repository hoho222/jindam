package doto.common.util;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;

@Component("pagingUtils")
public class PagingUtils {
	
	public static Map<String,Object> calPagination(String seq, int totalCnt, int limit) throws Exception {
		
		//결과를 담을 맵 생성
		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		int startPage = 0;
		 
		int endPage = 0;
		int page = 0;
		try{
			// 시작페이지 설정 1~5 페이지 일경우 1​​
			startPage =(Integer.parseInt(seq) - 1) / 5 * 5 + 1;
			//ex) 현재 6페이지 일경우 (6-1) /5 * 5 +1 = 1 -> 6 페이지 부터 시작​​
 
			endPage = startPage + 5 - 1;                             
 
			if(seq != null && seq != ""){
				if(!seq.equals("1")){
					// 첫페이지가 아닐경우 그 페이지에 맞는 목록 뽑아옴​
					int temp = (Integer.parseInt(seq)-1)*limit;    
					page= temp;
				
				}else if(seq.equals("1")){
					// 페이지 번호가 1이면 처음부터 limit개​
					page = 0;         
				}
 
			}
		}catch(Exception e){
			// 이상한 페이지 번호 들어오면 예외처리 할 수 있도록 exception 이라는 값이 들은 result 리턴
			resultMap.put("result", "exception");
			return resultMap;     
		}
		
		//pageNum 변수는 전체 페이지의 수​
		int pageNum = (totalCnt)/limit+1; 
		// 게시물이 딱 limit개일 경우 다음페이지가 생기지 않게 -1 해줌​
 
		if(totalCnt%limit == 0){       
			pageNum--;
		}
 
 
		if(endPage > pageNum){
			// 예를 들어 마지막페이지가 12페이지인 경우 endPage가 limit페이지 까지 출력되기때문에 12페이지로 바꿔줌
			endPage = pageNum;  
 
		}
		
		//성공한 결과를 map에 담아 전송
		resultMap.put("result", "success");
		resultMap.put("page", page);
		resultMap.put("pageNum", pageNum);
		resultMap.put("startPage", startPage);
		resultMap.put("endPage", endPage);
		
		return resultMap;
	}
	
}
