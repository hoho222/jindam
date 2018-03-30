package doto.svc.admin;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import doto.common.util.FileUtils;
import doto.dao.AdminDAO;

@Service("adminService")
public class AdminServiceImpl implements AdminService{
	
	@Resource(name="adminDAO")
	private AdminDAO adminDAO;
	
	@Resource(name="fileUtils")
    private FileUtils fileUtils;
	
	@Override
	public Map<String,Object> findStatus() throws Exception {
		
		HashMap<String,Object> params = new HashMap<String,Object>();
		
		Map<String,Object> statusResult = new HashMap<String,Object>();
		
		params.clear();
		String memCntTotal = adminDAO.selectMemberCnt(params);
		String goalCntTotal = adminDAO.selectGoalCnt(params);
		
		//오늘날짜 구하기
		SimpleDateFormat formatterS = new SimpleDateFormat ( "yyyy-MM-dd 00:00:00", Locale.KOREA );
		SimpleDateFormat formatterE = new SimpleDateFormat ( "yyyy-MM-dd 23:59:59", Locale.KOREA );
		Date currentTime = new Date ( );
		String TodayStart = formatterS.format ( currentTime );
		String TodayEnd = formatterE.format ( currentTime );
		
		params.put("isToday", "OK");
		params.put("TodayStart", TodayStart);
		params.put("TodayEnd", TodayEnd);
		String memCntToday = adminDAO.selectMemberCnt(params);
		String goalCntToday = adminDAO.selectGoalCnt(params);
		
		statusResult.put("MEM_CNT_TOTAL", memCntTotal);
		statusResult.put("GOAL_CNT_TOTAL",goalCntTotal);
		statusResult.put("MEM_CNT_TODAY", memCntToday);
		statusResult.put("GOAL_CNT_TODAY", goalCntToday);
		
		return statusResult;
	}
	
	@Override
	public boolean isAdminLoginOk(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		
		String memberCntStr = adminDAO.isAdminCnt(map);
		
		if(memberCntStr != null) {
			int memberCnt = Integer.parseInt(memberCntStr);
			if(memberCnt == 1) {
				Map<String, Object> selectAdminInfo = adminDAO.selectAdmin(map);
				
				//여기에 어드민 로그인ID, 로그인자 이름 따로 받아와서 세션에 넣어줌
				session.setAttribute("adminLoginNo", selectAdminInfo.get("NO"));
				session.setAttribute("adminLoginId", selectAdminInfo.get("ID"));
				session.setAttribute("adminLoginName", selectAdminInfo.get("NAME"));
				
				//어드민 LAST_ACCESS_DT 현재일자로 update
				//adminDAO.updateAdminLastAccess(selectAdminInfo.get("NO").toString());
				
				return true;
			} else {
			    return false;
			}
		} else {
		    return false;
		}
	}
	
	@Override
	public List<Map<String, Object>> selectMemberPassReadyList() throws Exception {
		return adminDAO.selectMemberPassReadyList();
	}
	
	@Override
	public boolean updateMemberInfoPass(Map<String, Object> map) throws Exception {
		
		String memberNo = String.valueOf(map.get("memberNo"));
		Map<String, Object> memberInfoPassMap = adminDAO.selectMemberInfoPass(map);
		Map<String, Object> memberInfoMap = adminDAO.selectMemberInfo(map);
		
		if("pass".equals(String.valueOf(map.get("result")))){
			//승인
			//T_MEMBER의 STATUS:F, ISPASS:T 로 설정
			map.put("status", "F");
			map.put("isPass", "T");
			
			adminDAO.updateMember(map);
			
			memberInfoMap.put("memberNo", memberNo);
			if(memberInfoPassMap != null){
				//if 해당 멤버no로 T_MEMBER_INFO_PASS의 값이 있다면, T_MEMBER_INFO_PASS에 T_MEMBER_INFO의 값으로 update
				adminDAO.updateMemberInfoPass(memberInfoMap);
			} else if(memberInfoPassMap == null){
				//else 해당 멤버no로 T_MEMBER_INFO_PASS의 값이 없는경우엔,  T_MEMBER_INFO_PASS에 T_MEMBER_INFO의 값으로 insert
				adminDAO.insertMemberInfoPass(memberInfoMap);
			}
			
		} else {
			//반려
			//T_MEMBER의 STATUS:F, ISPASS:F 로 설정
			map.put("status", "F");
			map.put("isPass", "F");
			map.put("failReason", String.valueOf(map.get("failReason")));
			adminDAO.updateMember(map);
			
			if(memberInfoPassMap != null){
				//if 해당 멤버no로 T_MEMBER_INFO_PASS의 값이 있다면, 해당 row를 다시 T_MEMBER_INFO의 값으로 update.
				memberInfoPassMap.put("memberNo", memberNo);
				adminDAO.updateMemberInfo(memberInfoPassMap);
			} else if(memberInfoPassMap == null){
				//else 해당 멤버no로 T_MEMBER_INFO_PASS의 값이 없는경우엔 T_MEMBER_INFO의 값 DELETE처리
				adminDAO.deleteMemberInfo(map);
			}
			
		}
		
		return true;
	}
	
	@Override
	public List<Map<String, Object>> selectNoticeList() throws Exception {
		return adminDAO.selectNoticeList();
	}
	
	@Override
	public void insertNotice(Map<String, Object> map) throws Exception {
		
		adminDAO.insertNotice(map);
	}
	
	@Override
	public List<Map<String, Object>> selectItemList() throws Exception {
		return adminDAO.selectItemList();
	}
	
	@Override
	public void insertItem(Map<String, Object> map, HttpServletRequest request) throws Exception {
		
		map.put("GB", "itemImg");
		
		List<Map<String, Object>> list = fileUtils.parseInsertFileInfo(map, request);
		
		for(int i=0; i<list.size(); i++){
			adminDAO.insertItem(map);
		}
		
	}

}
