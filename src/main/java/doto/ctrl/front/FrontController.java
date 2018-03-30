package doto.ctrl.front;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import doto.common.util.PagingUtils;
import doto.svc.front.FrontService;

@Controller
public class FrontController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="frontService")
	private FrontService frontService;
	
	/*
	 * 인덱스(홈) 화면
	 */
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(HttpSession session, ModelMap model) throws Exception {
		
		if(session.getAttribute("loginNo") != null && Integer.valueOf(session.getAttribute("loginNo").toString()) > 0){
			//현재 세션에 있는 유저No를 갖고오기 위한 변수
			int memberNo = Integer.valueOf(session.getAttribute("loginNo").toString());
			Map<String,Object> myMemberMap = frontService.selectMemberDetail(memberNo);
			
			if( myMemberMap.get("MATCH_MEMBERNO") != null && (Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()) > 0) ){
				Map<String,Object> matchMemberMap = frontService.selectMemberInfo(Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()));
				model.addAttribute("matchMemberMap", matchMemberMap);
				System.out.println("오늘 매칭상대 > "+matchMemberMap);
			}
			
			if( myMemberMap.get("OLDER_MATCH_MEMBERNO") != null && (Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0) ){
				Map<String,Object> myOlderMatchMemberMap = frontService.selectMemberInfo(Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
				model.addAttribute("myOlderMatchMemberMap", myOlderMatchMemberMap);
				System.out.println("어제 매칭상대 > "+myOlderMatchMemberMap);
			}
			
			if( myMemberMap.get("OLDEST_MATCH_MEMBERNO") != null && (Integer.valueOf(myMemberMap.get("OLDEST_MATCH_MEMBERNO").toString()) > 0) ){
				Map<String,Object> myOldestMatchMemberMap = frontService.selectMemberInfo(Integer.valueOf(myMemberMap.get("OLDEST_MATCH_MEMBERNO").toString()));
				model.addAttribute("myOldestMatchMemberMap", myOldestMatchMemberMap);
				System.out.println("그제 매칭상대 > "+myOldestMatchMemberMap);
			}
			
			if( myMemberMap.get("MATCH_SUCCESS_MEMBERNO") != null && (Integer.valueOf(myMemberMap.get("MATCH_SUCCESS_MEMBERNO").toString()) > 0) ){
				Map<String,Object> matchSuccessMemberMap = frontService.selectMemberInfo(Integer.valueOf(myMemberMap.get("MATCH_SUCCESS_MEMBERNO").toString()));
				model.addAttribute("matchSuccessMemberMap", matchSuccessMemberMap);
				System.out.println("성사된 소개팅 상대 > "+matchSuccessMemberMap);
			}
			
			model.addAttribute("myMemberMap", myMemberMap);
			System.out.println("내정보> "+myMemberMap);
		}
		
		return "front/index";

	}
	
	/*
	 * 모든 멤버들의 소개팅 상대를 매칭시켜줌
	 */
	@RequestMapping(value = "/matching", method = RequestMethod.GET)
	public String matchDatePeople(ModelMap model) throws Exception {
		
		String msg = "";
		
		boolean matchDatePeople = frontService.matchDatePeople();
		if(matchDatePeople){
			msg = "매칭 성공 하였습니다!";
		} else {
			msg = "매칭 실패 하였습니다ㅠㅠ";
		}
		
		model.addAttribute("msg", msg);
		return "front/matchingresult";
	}
	
	/*
	 * 회원인증 시도
	 */
	@RequestMapping(value = "/users/userauth/{memberNo}", method = RequestMethod.GET)
	public String userAuth(@PathVariable int memberNo, ModelMap model) throws Exception {
		
		Map<String, Object> memMap = frontService.selectMemberDetail(memberNo);
		String isAuth = memMap.get("ISAUTH").toString();
		
		if("T".equals(isAuth)){
			// 이미 해당 유저는 본인인증이 완료된 유저므로 index로 리다이렉트 시켜버림
			return "redirect:/index";
		} else {
			return "front/user/userauth";
		}
	}
	
	/*
	 * 회원인증 완료
	 */
	@RequestMapping(value="/users/userauth/{memberNo}", method = RequestMethod.POST)
	public void userAuth(@PathVariable int memberNo, @RequestParam Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		PrintWriter out = response.getWriter();
		String result = "";
		HttpSession session = request.getSession();
		
		try{
			Map<String, Object> dbMap = frontService.userAuthProcess(map);	//본인인증 정보부터 맵에 담음
			String authResult = dbMap.get("result").toString();
			
			if("success".equals(authResult)){
				dbMap.put("no", memberNo);
				dbMap.put("isAuth", "T");
				
				frontService.updateMember(dbMap);
				
				session.setAttribute("loginAuth", "T");
				result = "success";
			} else {
				result = "fail_dup";	// 해당 본인인증 정보가 이미 기존회원에 존재함
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result = "fail_error";		// 에러로 인한 본인인증 실패
		}
		
		//ajax 처리
		out.print(result); //이 값이 rData로 넘어감
		out.flush();
		out.close();
	}
	
	/*
	 * 회원인증
	 */
	@RequestMapping(value = "/users/usercallback", method = RequestMethod.POST)
	public String userCallback(@PathVariable int memberNo, ModelMap model) throws Exception {
		
		return "front/user/usercallback";

	}
	
	/*
	 * 메세지함 조회 (받은/보낸)
	 */
	@RequestMapping(value = "/messages/{memberNo}", method = RequestMethod.GET)
	public String selectMessage(@PathVariable int memberNo, ModelMap model) throws Exception {
		
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		//내가 받은 메세지함
		dbMap.clear();
		dbMap.put("recipientNo", memberNo);
		List<Map<String,Object>> receiptMsgList = frontService.selectMessageList(dbMap);
		
		//내가 보낸 메세지함
		dbMap.clear();
		dbMap.put("senderNo", memberNo);
		List<Map<String,Object>> sendMsgList = frontService.selectMessageList(dbMap);
		
		model.addAttribute("receiptMsgList", receiptMsgList);
		model.addAttribute("sendMsgList", sendMsgList);
		
		return "front/message/messages";
	}
	
	/*
	 * 공지사항 list(다 건) 조회
	 */
	@RequestMapping(value = "/notices", method = RequestMethod.GET)
	public String readNoticeList(@RequestParam Map<String,Object> map, ModelMap model) throws Exception {

		String seq = "1";
		if(map.containsKey("seq") && !"".equals(map.get("seq").toString())){
			seq = map.get("seq").toString();
		}
		
		Map<String, Object> dbMap = new HashMap<String, Object>();
		Map<String, Object> totalNoticeCntMap = frontService.selectNoticeCnt();
		Map<String,Object> pagingMap = PagingUtils.calPagination(seq, Integer.valueOf(totalNoticeCntMap.get("COUNT").toString()), 7);
		
        model.addAttribute("page",pagingMap.get("page"));
        model.addAttribute("totalCnt",totalNoticeCntMap.get("COUNT"));
        model.addAttribute("pageNum",pagingMap.get("pageNum"));
        model.addAttribute("start",pagingMap.get("startPage"));
        model.addAttribute("end",pagingMap.get("endPage"));
        model.addAttribute("seq",seq);
        
        dbMap.put("page", pagingMap.get("page"));
        dbMap.put("limit", 7);
        List<Map<String,Object>> noticeList = frontService.selectNoticeList(dbMap);
		model.addAttribute("list", noticeList);
		
		return "front/notice/notices";

	}
	
	/*
	 * 공지사항 상세(1 건) 조회
	 */
	@RequestMapping(value = "/notices/{idx}", method = RequestMethod.GET)
	public String readNotice(@PathVariable String idx, ModelMap model) throws Exception {
		
		//조회수 먼저 증가
		frontService.updateNoticeHitCnt(idx);
		
		//해당 글 내용 select
		Map<String,Object> noticeMap = frontService.selectNoticeDetail(idx);
		model.addAttribute("noticeMap", noticeMap);
		model.addAttribute("idx", idx);
		
		return "front/notice/notices_detail";

	}
	
	/*
	 * 광고 보상 비행기 +10 지급
	 */
	@RequestMapping(value = "/users/adreward", method = RequestMethod.POST)
	public void adReward(@RequestParam Map<String,Object> map, ModelMap model, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		PrintWriter out = response.getWriter();
		
		boolean isAdReward = frontService.isAdReward(map, response, request);
		
		//ajax 처리
		out.print(isAdReward); //이 값이 rData로 넘어감
		out.flush();
		out.close();
		
	}
	
	/*
	 * 로그인 Act
	 */
	@RequestMapping(value = "/users/login", method = RequestMethod.POST)
	public void loginAct(@RequestParam Map<String,Object> map, ModelMap model, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		PrintWriter out = response.getWriter();
		
		boolean loginOk = frontService.isLoginOk(map, response, request);
		
		//ajax 처리
		out.print(loginOk); //이 값이 rData로 넘어감
		out.flush();
		out.close();
		
	}
	
	
	/*
	 * 로그아웃
	 */
	@RequestMapping(value="/users/logout", method = RequestMethod.GET)
	public String logout(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		session.invalidate();
		
		return "redirect:/index";
	}
	
	/*
	 * 회원정보 조회
	 */
	@RequestMapping(value = "/users/userinfo/{no}", method = RequestMethod.GET)
	public String readUserInfo(@PathVariable int no, ModelMap model, HttpSession session) throws Exception {
		
		Map<String,Object> memberMap = frontService.selectMemberDetail(no);
		model.addAttribute("memberMap", memberMap);
		
		Map<String,Object> memberInfoMap = frontService.selectMemberInfo(no);
		if(memberInfoMap == null){
			
		} else {
			// 수정
			String mobile = memberInfoMap.get("MOBILE").toString();
			String mobile1 = "";
			String mobile2 = "";
			String mobile3 = "";
			
			if(!"".equals(mobile)){
				String[] mobileArr = mobile.split("-");
				mobile1 = mobileArr[0];
				mobile2 = mobileArr[1];
				mobile3 = mobileArr[2];
			}
			memberInfoMap.put("mobile1", mobile1);
			memberInfoMap.put("mobile2", mobile2);
			memberInfoMap.put("mobile3", mobile3);
			
			model.addAttribute("memberInfoMap", memberInfoMap);
		}
		
		return "front/user/userinfo";

	}
	
	/*
	 * 회원정보 입력 및 수정
	 */
	@RequestMapping(value = "/users/userinfo/{no}", method = RequestMethod.POST)
	public String writeUserInfo(@PathVariable int no, @RequestParam Map<String,Object> map, ModelMap model, HttpSession session) throws Exception {
		
		Map<String,Object> memberMap = frontService.selectMemberDetail(no);
		Map<String,Object> memberInfoMap = frontService.selectMemberInfo(no);
		
		if(memberInfoMap != null && "F".equals(memberMap.get("STATUS"))){
			//나의정보 입력한 내역이 있으며, STATUS(심사상태)가 F(심사완료)인 유저는 T_MEMBER_INFO 수정.
			//T_MEMBER의 STATUS:I(심사중) 으로 셋팅
			frontService.updateMemberInfo(map);
		} else if(memberInfoMap == null && ("B".equals(memberMap.get("STATUS")) || "F".equals(memberMap.get("STATUS"))) ) {
			//나의정보 입력한 내역도 없으며, STATUS(심사상태)가 B(심사전) 이거나 F(심사완료) 인 유저(처음등록하고 심사받았는데 반려될 수도 있으니까)는 등록.
			//T_MEMBER의 STATUS:I(심사중) 으로 셋팅
			frontService.insertMemberInfo(map);
		}
		
		return "redirect:/users/userinfopass";

	}
	
	/*
	 * 등록한 회원정보 심사 페이지 노출
	 */
	@RequestMapping(value = "/users/userinfopass", method = RequestMethod.GET)
	public String jubgeUserInfo(ModelMap model, HttpSession session) throws Exception {
		
		return "front/user/userinfopass";

	}
	
	
	/*
	 * 회원가입 폼
	 */
	@RequestMapping(value = "/users/joinform", method = RequestMethod.GET)
	public String createJoinForm(ModelMap model) throws Exception {
		
		return "front/user/joinform";

	}
	
	/*
	 * 회원 등록 act
	 */
	@RequestMapping(value = "/users/join", method = RequestMethod.POST)
	public String createMemberAct(@RequestParam Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		frontService.insertMember(map);
		return "redirect:/index";
		
	}
	
	/*
	 * 회원 가입시 이메일 중복확인
	 */
	@RequestMapping(value = "/users/joinoverlap", method = RequestMethod.POST)
	public void readEmailOverlap(@RequestParam Map<String,Object> map, HttpServletResponse response) throws Exception {
		
		PrintWriter out = response.getWriter();
		
		boolean isOverlap = frontService.memberOverlap(map);
		
		//ajax 처리
		out.print(isOverlap); //이 값이 rData로 넘어감
		out.flush();
		out.close();

	}
	
	/*
	 * 매칭 회원정보 조회
	 */
	@RequestMapping(value = "/users/matchuserinfo/{matchMemberNo}", method = RequestMethod.GET)
	public String readMatchUserInfo(@PathVariable int matchMemberNo, ModelMap model, HttpSession session) throws Exception {
		
		if(session.getAttribute("loginNo") != null){
			Map<String,Object> myMemberMap = frontService.selectMemberDetail(Integer.valueOf(session.getAttribute("loginNo").toString()));
			model.addAttribute("myMemberMap", myMemberMap);
		}
		
		//매칭 상대방의 T_MEMBER
		Map<String,Object> matchMemberMap = frontService.selectMemberDetail(matchMemberNo);
		model.addAttribute("matchMemberMap", matchMemberMap);
		
		//매칭 상대방의 T_MEMBER_INFO
		Map<String,Object> matchMemberInfoMap = frontService.selectMemberInfo(matchMemberNo);
		model.addAttribute("matchMemberInfoMap", matchMemberInfoMap);
		
		return "front/user/matchuserinfo";

	}
	
	/*
	 * 매칭 회원에게 더 알아보기 or 좋아요 or 저와 맞지 않아요 처리
	 */
	@RequestMapping(value = "/users/matchuserinfo/expressmind", method = RequestMethod.POST)
	public void expressMind(@RequestParam Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		PrintWriter out = response.getWriter();
		
		String expressMind = frontService.expressMind(map, response, request);
		
		//ajax 처리
		out.print(expressMind); //이 값이 rData로 넘어감
		out.flush();
		out.close();

	}
	
	/*
	 * 소개팅 성사되었던 회원과 인연 끊기 처리
	 */
	@RequestMapping(value = "/users/matchuserinfo/matchfail", method = RequestMethod.POST)
	public void matchfail(@RequestParam Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		PrintWriter out = response.getWriter();
		
		boolean matchFail = frontService.matchFail(map, response, request);
		
		//ajax 처리
		out.print(matchFail); //이 값이 rData로 넘어감
		out.flush();
		out.close();

	}
	
	/*
	 * 매칭 성공 처리
	 */
	@RequestMapping(value = "/messages/matchsuccess", method = RequestMethod.POST)
	public void matchSuccess(@RequestParam Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		PrintWriter out = response.getWriter();
		
		boolean expressMind = frontService.matchSuccess(map, response, request);
		
		//ajax 처리
		out.print(expressMind); //이 값이 rData로 넘어감
		out.flush();
		out.close();

	}
	
	/*
	 * 아이템몰 조회 (몰/보유내역)
	 */
	@RequestMapping(value = "/items", method = RequestMethod.GET)
	public String viewItemMall(@RequestParam Map<String,Object> map, ModelMap model, HttpSession session) throws Exception {
		
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		//아이템몰
		List<Map<String,Object>> itemList = frontService.selectItemList(dbMap);
		model.addAttribute("itemList", itemList);
		
		//보유한 아이템 내역
		if(session.getAttribute("loginNo") != null && Integer.valueOf(session.getAttribute("loginNo").toString()) > 0){
			dbMap.clear();
			dbMap.put("myMemberNo", Integer.valueOf(session.getAttribute("loginNo").toString()));
			
			//내 보유 비행기 수 갖고오기 위함
			Map<String,Object> myMemberMap = frontService.selectMemberDetail(Integer.valueOf(session.getAttribute("loginNo").toString()));
			model.addAttribute("myMemberMap", myMemberMap);
			
			List<Map<String,Object>> myItemList = frontService.selectMyItemList(dbMap);
			model.addAttribute("myItemList", myItemList);
		}
		
		return "front/item/items";
	}
	
	/*
	 * 아이템 구매 처리
	 */
	@RequestMapping(value = "/items/purchase", method = RequestMethod.POST)
	public void buyItem(@RequestParam Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		PrintWriter out = response.getWriter();
		
		boolean buyItem = frontService.buyItem(map, response, request);
		
		//ajax 처리
		out.print(buyItem); //이 값이 rData로 넘어감
		out.flush();
		out.close();

	}
	
	/*
	 * 마이페이지 (비번변경/소개중단 및 재개)
	 */
	@RequestMapping(value = "/users/mypage/{myMemberNo}", method = RequestMethod.GET)
	public String selectMypage(@PathVariable int myMemberNo, ModelMap model) throws Exception {
		
		Map<String, Object> myMemberMap = frontService.selectMemberDetail(myMemberNo);
		model.addAttribute("myMemberMap", myMemberMap);
		
		return "front/user/mypage";

	}
	
	/*
	 * 마이페이지 (비번변경/소개중단 및 재개) act
	 */
	@RequestMapping(value = "/users/mypage/{myMemberNo}", method = RequestMethod.POST)
	public void updateMypage(@RequestParam Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		PrintWriter out = response.getWriter();
		
		boolean expressMind = frontService.updateMypage(map, response, request);
		
		//ajax 처리
		out.print(expressMind); //이 값이 rData로 넘어감
		out.flush();
		out.close();

	}
	
	/*
	 * 회원 탈퇴 처리
	 */
	@RequestMapping(value = "/users/secession", method = RequestMethod.POST)
	public void secession(@RequestParam Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		PrintWriter out = response.getWriter();
		
		boolean matchFail = frontService.secession(map, response, request);
		
		//ajax 처리
		out.print(matchFail); //이 값이 rData로 넘어감
		out.flush();
		out.close();

	}
	
}
