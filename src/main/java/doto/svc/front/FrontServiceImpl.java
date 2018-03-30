package doto.svc.front;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import doto.common.logger.CommonInterceptor;
import doto.common.util.CommonUtils;
import doto.common.util.FileUtils;
import doto.common.util.PagingUtils;
import doto.dao.FrontDAO;
import doto.mail.Email;
import doto.mail.EmailSender;


@Service("frontService")
public class FrontServiceImpl  implements FrontService {
	
	protected Log log = LogFactory.getLog(CommonInterceptor.class);
	
	@Autowired
	private EmailSender emailSender;
	 
	@Autowired
	private Email email;

	@Resource(name="fileUtils")
    private FileUtils fileUtils;
	
	@Resource(name="commonUtils")
    private CommonUtils commonUtils;
	
	@Resource(name="pagingUtils")
    private PagingUtils pagingUtils;

	@Resource(name="frontDAO")
	private FrontDAO frontDAO;
	
	@Override
	public List<Map<String, Object>> selectNoticeList(Map<String, Object> map) throws Exception {
		
		List<Map<String, Object>> selectNoticeList = frontDAO.selectNoticeList(map);
		
		return selectNoticeList;
	}
	
	@Override
	public Map<String, Object> selectNoticeCnt() throws Exception {
		
		return frontDAO.selectNoticeCnt();
	}
	
	@Override
	public Map<String, Object> selectNoticeDetail(String idx) throws Exception {
		
		return frontDAO.selectNoticeDetail(idx);
	}
	
	@Override
	public void updateNoticeHitCnt(String idx) throws Exception {
		
		frontDAO.updateNoticeHitCnt(idx);
		
	}
	
	
	@Override
	public Map<String, Object> selectMemberDetail(int no) throws Exception {
		
		return frontDAO.selectMemberDetail(no);
	}
	
	@Override
	public void updateMember(Map<String, Object> map) throws Exception {
		try{
			frontDAO.updateMember(map);
			System.out.println("여기타면 바뀜 > "+map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	@Override
	public Map<String, Object> userAuthProcess(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> dbMap = new HashMap<String, Object>();
		String result = "";
		
		String imp_uid = map.get("imp_uid").toString();
		JSONObject json = new JSONObject();
		JSONObject _json;
		JSONObject json2 = new JSONObject();
		JSONObject _json2;
		
		try{
			/* 엑세스 토큰 얻기 */
			URL url = new URL("https://api.iamport.kr/users/getToken");
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setDoOutput(true);

			// 헤더 셋팅
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			
			// 바디 셋팅
			String body = "imp_key=6475058438544679&imp_secret=7xtnTBPw0B358SxwI208IL2WT4KgKhzSP2fID5fEGjKObhlTkm2274Z18KiS2RKRU0Ax5PcL9XAkeVey";

			OutputStreamWriter sw = new OutputStreamWriter(con.getOutputStream());
			sw.write(body);
			sw.flush();
			
			// HttpURLConnection 의 url을 통해 헤더와 바디를 셋팅한 후, 거기서 원하는 값을 json을 이용해 뽑아옴
			// 원래 in의 값은 {"code":0,"message":null,"response":{"access_token":"c59c12c53a0500249723dc14e227b476d859636b","now":1522306650,"expired_at":1522308450}} 임
			BufferedReader in = new BufferedReader( new InputStreamReader(con.getInputStream()) );
			json = (JSONObject)JSONValue.parse(in);
            _json = (JSONObject)json.get("response");
            
            String access_token = _json.get("access_token").toString();

			in.close();
		    /* 엑세스 토큰 얻기 */

		    
		    /* 인증정보 갖고오기 */
			URL url2 = new URL("https://api.iamport.kr/certifications/"+imp_uid);
			HttpURLConnection con2 = (HttpURLConnection) url2.openConnection();

			// 헤더 셋팅(access_token)
			con2.setRequestProperty("Authorization", access_token);
			
			BufferedReader in2 = new BufferedReader( new InputStreamReader(con2.getInputStream()) );
			json2 = (JSONObject)JSONValue.parse(in2);
            _json2 = (JSONObject)json2.get("response");
           
            // timestamp 형태로 받은 생일에서 생년만 뽑아오기
            String  birthStr = _json2.get("birth").toString();
            Timestamp birthTime = new Timestamp(Long.parseLong(birthStr));
            Date date = new Date(birthTime.getTime() * 1000);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String birth = sdf.format(date);
            String[] birthArr = birth.split("-");
            // 현재는 유저의 생년만 필요해서 생년만 쪼개서 넣고있는데, 추후 생년월일이 필요하면 date 변수를 DATETIME컬럼 DB에 저장해주면됨
            
            // 인증된 유저 정보중 unique_key 값이 기존에 중복된 것이 있으면 실패
            dbMap.put("uniqueKey", _json2.get("unique_key").toString());
            Map<String, Object> authMemMap = frontDAO.selectMember(dbMap);
            if(authMemMap == null){
            	result = "success";
            	resultMap.put("name", _json2.get("name").toString());				// 유저명
                resultMap.put("gender", _json2.get("gender").toString());			// 유저성별
                resultMap.put("birthYear", birthArr[0]);							// 유저 생년
                resultMap.put("uniqueKey", _json2.get("unique_key").toString());	// 유저의 고유값(중복가입 금지를 위함)
            } else {
            	result = "fail";	//unique_key 값이 기존에 중복된 것이 있어서 실패함
            }
            resultMap.put("result", result);
            
		    in2.close();
		    /* 인증정보 갖고오기 */
		    
		    System.out.println("리저트맵 > "+resultMap);
		    
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return resultMap;
	}
	
	@Override
	public void insertMemberInfo(Map<String, Object> map) throws Exception {
		//유저정보 등록
		try{
			String mobile = map.get("mobile1").toString() + "-" + map.get("mobile2").toString() + "-" + map.get("mobile2").toString();
			map.put("mobile", mobile);
			
			//일단 T_MEMBER_INFO 에 해당정보 저장
			frontDAO.insertMemberInfo(map);
			
			//T_MEMBER에서 STATUS:I(심사중) 으로 변경
			map.put("status", "I");
			frontDAO.updateMember(map);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	@Override
	public void updateMemberInfo(Map<String, Object> map) throws Exception {
		
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		try{
			String mobile = map.get("mobile1").toString() + "-" + map.get("mobile2").toString() + "-" + map.get("mobile2").toString();
			map.put("mobile", mobile);
			System.out.println("업뎃 ");
			frontDAO.updateMemberInfo(map);
			
			//T_MEMBER의 STATUS:I(심사중) 으로 셋팅
			dbMap.clear();
			dbMap.put("no", map.get("no"));
			dbMap.put("status", "I");
			frontDAO.updateMember(dbMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	@Override
	public void insertMember(Map<String, Object> map) throws Exception {
		frontDAO.insertMember(map);
	}
	
	@Override
	public boolean memberOverlap(Map<String,Object> map) throws Exception{
		
		List<Map<String, Object>> selectMemberList = frontDAO.selectMemberList(map);
		
		if(selectMemberList.isEmpty()) {
			//중복된 이메일주소 없음 -> 가입가능
			return true;
		} else {
			//중복된 이메일주소 있음 -> 가입불가
			return false;
		}
		
	}

	
	@Override
	public boolean isLoginOk(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String memberCntStr = frontDAO.isMemberCnt(map);
		
		if(memberCntStr != null) {
			int memberCnt = Integer.parseInt(memberCntStr);
			if(memberCnt == 1) {
				try{
					Map<String, Object> selectMemberInfo = frontDAO.selectMember(map);
					
					//여기에 로그인자 정보 따로 받아와서 세션에 넣어줌
					session.setAttribute("loginNo", selectMemberInfo.get("NO"));
					session.setAttribute("loginEmail", selectMemberInfo.get("EMAIL"));
					session.setAttribute("loginAuth", selectMemberInfo.get("ISAUTH"));
					
					/*//ip 주소 정보 가져오기
					InetAddress local = InetAddress.getLocalHost();
					String ip = local.getHostAddress();
					
					//로그인접속 정보 T_ACCESS_LOG 에 저장
					Map<String, Object> logMap = new HashMap<String, Object>();
					logMap.put("memberIdx", selectMemberInfo.get("IDX"));
					logMap.put("memberIp", ip);
					logMap.put("memberAccessPath", "doitTogether");
					frontDAO.insertMemberAccessLog(logMap);*/
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				return true;
			} else {
			    return false;
			}
		} else {
		    return false;
		}
	}
	
	@Override
	public boolean isAdReward(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		Map<String, Object> myMemberMap = frontDAO.selectMember(map);
		
		String today = String.valueOf(myMemberMap.get("Today"));
		int myCash = Integer.valueOf((myMemberMap.get("CASH")).toString());
		String viewAdDay = "";
		today = today.substring(0, 10);
		
		if(myMemberMap.get("VIEWADDATE") != null && !"".equals(String.valueOf(myMemberMap.get("VIEWADDATE")))){
			System.out.println("광고 본 날이 있어요");
			viewAdDay = (String.valueOf(myMemberMap.get("VIEWADDATE")));
			viewAdDay = viewAdDay.substring(0, 10);
		}
		System.out.println("오늘 날짜 어케 나오나요 > "+today +" | 광고 시청일 > "+viewAdDay);
		
		if(today.equals(viewAdDay)){
			if (log.isDebugEnabled()) {
				log.debug("오늘은 이미 광고를 봐서 비행기를 지급받으셨네요");
			}
			return false;
		} else {
			System.out.println("오늘은 광고로 리워드 아직 안받아서 줍니당");
			//no는 이미 map에 들어있어서 별도로 안넣음.
			map.put("cash", myCash+10);
			map.put("viewAdToday", "ok");
			
			frontDAO.updateMember(map);
			
			return true;
		}
		
	}
	
	//쨩
	@Override
	public Map<String, Object> selectMemberInfo(int no) throws Exception {
		
		return frontDAO.selectMemberInfo(no);
	}
	
	@Override
	public boolean matchDatePeople() throws Exception {
		
		//디비 파라미터로 쓰일 값들을 넣을 맵
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		//최종 매칭된 유저1명의 No
		int bestMemberNo = 0;
		
		try{
			dbMap.clear();
			dbMap.put("random", "ok");
			dbMap.put("isMatchSuccess", "F");	//성사되지 않은 유저만 갖고옴
			dbMap.put("isPossibleMatch", "T");	//매칭가능한 상태의 유저만 갖고옴
			List<Map<String, Object>> memberList = frontDAO.selectMemberList(dbMap);
			
			if(memberList != null){
				//전체 유저를 랜덤하게 갖고와서 돌림
				for (Map<String, Object> memberMap : memberList) {
					
					int memberNo = Integer.valueOf(memberMap.get("NO").toString());
					
					dbMap.clear();
					dbMap.put("no", memberNo);
					Map<String, Object> myMemberMap = frontDAO.selectMember(dbMap);
					System.out.println("내 멤버맵 > "+myMemberMap);
					
					//내 상태가 매칭가능한 상태일때만 매칭
					if("T".equals(myMemberMap.get("ISPOSSIBLEMATCH").toString())){
						String today = String.valueOf(myMemberMap.get("Today"));
						String matchDay = "";
						today = today.substring(0, 10);
						System.out.println("삐삐 > "+matchDay);
						if(myMemberMap.get("MATCHDATE") != null && !"".equals(String.valueOf(myMemberMap.get("MATCHDATE")))){
							System.out.println("매칭일이 있어요");
							matchDay = (String.valueOf(myMemberMap.get("MATCHDATE")));
							matchDay = matchDay.substring(0, 10);
						}
						System.out.println("오늘 날짜 어케 나오나요 > "+today +" | 매칭일 > "+matchDay);
						//만약 오늘과 매칭일이 같을경우, 매칭 안시켜줌
						if(today.equals(matchDay)){
							if (log.isDebugEnabled()) {
								log.debug("오늘은 나의 매칭상대 필터링 끝났음");
							}
						} else{
							//현재 유저의 member_info를 가져옴 (단, 해당 유저가 STATUS == F && ISPASS == T 인 상태라면.)
							dbMap.clear();
							dbMap.put("no", memberNo);
							dbMap.put("status", "F");
							dbMap.put("isPass", "T");
							Map<String, Object> myMemberInfoMap = frontDAO.selectMemberInfoForMap(dbMap);
							
							//if 현재 유저 정보가 STATUS != F || ISPASS != T 인 경우는 break (심사를 받지 않았거나, 심사중이라고 alert찍어주고 index로 가기)
							if(myMemberInfoMap == null){
								//소개 실패1
								if (log.isDebugEnabled()) {
									log.debug("고객님의 개인정보가 심사를 받지 않았거나, 심사중인 상태입니다. 이 경우에는 소개팅 상대를 찾아드릴 수 없습니다. 개인정보 심사를 먼저 완료 및 승인받아주세요.");
								}
							} else {
								//소개팅 상대 매칭 알고리즘을 위한 나의 변수 4개 셋팅
								int myReligion = Integer.valueOf(myMemberInfoMap.get("RELIGION").toString());
								int myStance = Integer.valueOf(myMemberInfoMap.get("STANCE").toString());
								int myRegion = Integer.valueOf(myMemberInfoMap.get("REGION").toString());
								int myBirthYear = Integer.valueOf(myMemberInfoMap.get("BIRTHYEAR").toString());
								int myAgeGap = Integer.valueOf(myMemberInfoMap.get("AGE_GAP").toString());
								
								String myGender = String.valueOf(myMemberInfoMap.get("GENDER"));
								
								//최적의 소개팅 상대로 뽑힌 이들의 No를 배열로 담아서, 이 중에 random으로 1명 뽑음
								List<Integer> bestMemberNoArr = new ArrayList<Integer>();
								
								//else 전체 유저들의의 member_info_list를 가져옴 (단, STATUS == F && ISPASS == T 인 유저만)
								dbMap.clear();
								dbMap.put("myMemberNo", memberNo);
								dbMap.put("myGender", myGender);
								dbMap.put("status", "F");
								dbMap.put("isPass", "T");
								dbMap.put("isPossibleMatch", "T");	//매칭가능한 상태의 유저만 갖고옴
								List<Map<String, Object>> othersMemberInfoList = frontDAO.selectMemberInfoList(dbMap);
								
								//if 전체 유저들 모두가 STATUS != F || ISPASS != T 인 경우는 break (회원정보 심사를 받지 않았거나 심사중인 회원밖에 없다고 alert찍어주고 index로 가기)
								if(othersMemberInfoList.isEmpty()){
									//소개 실패2
									if (log.isDebugEnabled()) {
										log.debug("개인정보 심사가 완료된 다른 유저를 찾지 못했습니다.");
									}
								} else {
									System.out.println("소개팅 상대 정보들 > "+othersMemberInfoList);
									for (Map<String, Object> other : othersMemberInfoList) {
	
										boolean isMatchFail = false;
										dbMap.clear();
										dbMap.put("myMemberNo", memberNo);
										dbMap.put("isMatchSuccess", "F");	//인연 끊긴 유저는 안갖고오려고
										List<Map<String, Object>> matchFailMemberList = frontDAO.selectMatchFailMemberList(dbMap);	//나와 이전에 성사됐지만 인연이 끊긴 유저들은 갖고오지 않기위해 조회해봄
										
										if(!matchFailMemberList.isEmpty()){
											for (Map<String, Object> matchFailMember : matchFailMemberList) {
												if(Integer.valueOf(matchFailMember.get("MATCHSUCCESS_MEMBERNO").toString()) == Integer.valueOf(other.get("MEMBERNO").toString())){
													if (log.isDebugEnabled()) {
														log.debug("해당 유저는 이미 전에 인연끊긴 적이 있는 유저 입니다! 그래서 매칭대상에서 제외됩니다. 해당 멤버넘버 > "+Integer.valueOf(matchFailMember.get("MATCHSUCCESS_MEMBERNO").toString()));
													}
													isMatchFail = true;
												}
											}
										}
										
										if(isMatchFail){
											break;
										}
										
										//소개팅 상대 매칭 알고리즘을 위한 상대방의 변수 4개 셋팅
										int otherReligion = Integer.valueOf(other.get("RELIGION").toString());
										int otherStance = Integer.valueOf(other.get("STANCE").toString());
										int otherRegion = Integer.valueOf(other.get("REGION").toString());
										int otherBirthYear = Integer.valueOf(other.get("BIRTHYEAR").toString());
										
										
										//필터1) 종교
										if(myReligion == otherReligion){
											//if만약 내 종교 == 상대방 종교면 해당 멤버No 담음 (우선 순위를 높이기 위해 다섯번 담음 - 종교가 우선순위 젤 높음)
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											if (log.isDebugEnabled()) {
												log.debug("bestMemberReason : 종교가 같음 | bestMemberNoArr >> " +  bestMemberNoArr);
											}
										} else {
											//else (종교가 다를경우)
											if(myReligion == 1){
												//내가 무교인 경우, 타 종교를 가진 사람 매칭
												if(otherReligion > 1){
													bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
													if (log.isDebugEnabled()) {
														log.debug("bestMemberReason : 종교가 다르고, 나는 무교임 | bestMemberNoArr >> " +  bestMemberNoArr);
													}
												}
											} else {
												//내가 무교 아닐경우, 무교인 사람과 매칭
												if(otherReligion == 1){
													bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
													if (log.isDebugEnabled()) {
														log.debug("bestMemberReason : 종교가 다르고, 나는 무교가 아님 | bestMemberNoArr >> " +  bestMemberNoArr);
													}
												}
											}
										}
										
										//필터2) 정치성향
										if(myStance == otherStance){
											//if만약 내 정치성향 == 상대방 정치성향이면 해당 멤버No 담음 (우선 순위를 높이기 위해 네번 담음)
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											if (log.isDebugEnabled()) {
												log.debug("bestMemberReason : 정치성향이 같음 | bestMemberNoArr >> " +  bestMemberNoArr);
											}
										} else {
											//else (정치성향 다를경우)
											if(myStance > 1 && myStance < 5){
												if(myStance-1 == otherStance || myStance+1 == otherStance){
													bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
													if (log.isDebugEnabled()) {
														log.debug("bestMemberReason : 정치성향이 다르고, 나는 2(중도진보)~4(중도보수) 중 하나임 | bestMemberNoArr >> " +  bestMemberNoArr);
													}
													
												} else if(myStance-2 == otherStance || myStance+2 == otherStance){
													bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
													if (log.isDebugEnabled()) {
														log.debug("bestMemberReason : 정치성향이 다르고, 나는 2(중도진보)~4(중도보수) 중 하나임2 | bestMemberNoArr >> " +  bestMemberNoArr);
													}
													
												}
											} else {
												if(myStance == 1){
													if(myStance+1 == otherStance || myStance+2 == otherStance){
														bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
														if (log.isDebugEnabled()) {
															log.debug("bestMemberReason : 정치성향이 다르고, 나는 보수임 | bestMemberNoArr >> " +  bestMemberNoArr);
														}
														
													}
												} else if(myStance == 5){
													if(myStance-1 == otherStance || myStance-2 == otherStance){
														bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
														if (log.isDebugEnabled()) {
															log.debug("bestMemberReason : 정치성향이 다르고, 나는 진보임 | bestMemberNoArr >> " +  bestMemberNoArr);
														}
														
													}
												}
											}
										}
										
										//필터3) 지역
										if(myRegion == otherRegion){
											//if만약 내 지역 == 상대방 지역이면 해당 멤버No 담음 (우선 순위를 높이기 위해 세번 담음)
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
											if (log.isDebugEnabled()) {
												log.debug("bestMemberReason : 지역이 같음 | bestMemberNoArr >> " +  bestMemberNoArr);
											}
											
										} else {
											//else (지역 다를경우)
											if(myRegion > 1 && myRegion < 18){
												if(myRegion-1 == otherRegion || myRegion+1 == otherRegion){
													bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
													if (log.isDebugEnabled()) {
														log.debug("bestMemberReason : 지역이 다르고, 내 지역이 2(경기서남)~17(대구) 중 하나임 | bestMemberNoArr >> " +  bestMemberNoArr);
													}
													
												} else if(myRegion-2 == otherRegion || myRegion+2 == otherRegion){
													bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
													if (log.isDebugEnabled()) {
														log.debug("bestMemberReason : 지역이 다르고, 내 지역이 2(경기서남)~17(대구) 중 하나임2 | bestMemberNoArr >> " +  bestMemberNoArr);
													}
													
												}
											} else {
												if(myRegion == 1){
													if(myRegion+1 == otherRegion || myRegion+2 == otherRegion){
														bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
														if (log.isDebugEnabled()) {
															log.debug("bestMemberReason : 지역이 다르고, 내 지역이 1(서울)임 | bestMemberNoArr >> " +  bestMemberNoArr);
														}
														
													}
												} else if(myRegion == 18){
													if(myRegion-1 == otherRegion || myRegion-2 == otherRegion){
														bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
														if (log.isDebugEnabled()) {
															log.debug("bestMemberReason : 지역이 다르고, 내 지역이 18(경북)임 | bestMemberNoArr >> " +  bestMemberNoArr);
														}
														
													}
												}
											}
										}
										
										//필터4) 나이(생년)
										//나보다 최대 myAgeGap 동안 어린 사람 추출
										for(int i=myBirthYear+1; i<=myBirthYear+myAgeGap; i++){
											if(i == otherBirthYear){
												//내가 원하는 연하 나이차 범위에 있는 사람 담음 (우선순위를 높이기 위해 2번담음)
												bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
												bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
												if (log.isDebugEnabled()) {
													log.debug("bestMemberReason : "+ i +" 년생임 (난 "+myBirthYear+"년생, 연하 나이 차 :"+ myAgeGap +") | bestMemberNoArr >> " +  bestMemberNoArr);
												}
												
											}
										}
										
										//나랑 동갑이거나, 최대 myAgeGap 동안 나이든 사람 추출
										for(int i=myBirthYear-myAgeGap; i<=myBirthYear; i++){
											if(i == otherBirthYear){
												//내가 원하는 연상 나이차 범위에 있는 사람 담음 (우선순위를 높이기 위해 2번담음)
												bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
												bestMemberNoArr.add(Integer.valueOf(other.get("MEMBERNO").toString()));
												if (log.isDebugEnabled()) {
													log.debug("bestMemberReason : "+ i +" 년생임 (난 "+myBirthYear+"년생, 연상 나이 차 :"+ myAgeGap +") | bestMemberNoArr >> " +  bestMemberNoArr);
												}
												
											}
										}
										
										if(bestMemberNoArr.isEmpty() || bestMemberNoArr.size() == 0){
											//모든 필터를 다 거쳤음에도, bestMemberNoArr가 비어있다면 해당 유저는 오늘 매칭을 못 받음.
											//소개 실패3
											if (log.isDebugEnabled()) {
												log.debug("오늘은 해당 유저의 정보와 맞는 부분이 많은 유저가 없습니다.");
											}
											
										}
									}
									System.out.println("추천받은 유저넘버들 > "+bestMemberNoArr);
									
									if(!bestMemberNoArr.isEmpty() && bestMemberNoArr.size() != 0){
									//필터 4개중 하나라도 거쳐서 bestMemberNoArr가 쌓인경우
									//1. 현재 가장 많은 필터에 부합한 사람의 no가 arraylist에 저장되고 있음.
									//2. arraylist의 값을 하나씩 쪼개서, (키,값 : memberNo,해당no가 반복된cnt수)
									//3.해서 가장많이 나온 no를 매칭
									
									//각 매칭 유저No의 반복횟수를 셀 cnt
									//0이 아닌 1로 초깃값 셋팅한 이유는
									//1개만 들어있는 유저No도 그 자체로 1개로 카운팅 돼야하기 때문이다.
										int cnt = 1;
										
										//(key, value : 매칭유저No, 해당매칭유저No의 반복횟수)
										Map<Integer, Integer> bestMemberNoCntMap = new HashMap<Integer, Integer>();
										
										for(int i=0; i<bestMemberNoArr.size(); i++){
											if( i == (bestMemberNoArr.size()-1) ){
												break;
											}
											
											if(bestMemberNoArr.get(i) == bestMemberNoArr.get(i+1)){
												//선택된 매칭유저No의 카운트 증가
												cnt++;
												//bestMemberNoCntMap에 해당 매칭유저No와 cnt수 넣음
												bestMemberNoCntMap.put(bestMemberNoArr.get(i), cnt);
											} else {
												//같지 않으면 cnt값 1로 초기화
												cnt = 1;
											}
										}
										
										System.out.println("매칭유저No별로 카운트맵 > "+bestMemberNoCntMap);
										
										//bestMemberNoCntMap 에서 최대 카운트 수를 가진 유저No를 뽑기위한 변수
										Entry<Integer, Integer> maxEntry = null;
										List<Integer> maxCntNoArr = new ArrayList<Integer>();
			
									    for (Map.Entry<Integer, Integer> entry : bestMemberNoCntMap.entrySet()) {
			
									        if (maxEntry == null || entry.getValue().compareTo(maxEntry.getValue()) >= 0) {
									            maxEntry = entry;
									            maxCntNoArr.add(entry.getKey());
									        }
									    }
			
									    System.out.println("어케된거야!! > "+maxCntNoArr);
									    int bestMemberArrIndex = 0;
									    
									    //최대 cnt수가 같은 매칭유저No가 2개 이상인 경우에는 그 중에서 랜덤으로 뽑음.
									    if(maxCntNoArr.size() > 1){
									    	int random = CommonUtils.randomRange(0, maxCntNoArr.size()-1);
									    	bestMemberArrIndex = random;
									    }
									    
									    //cnt수가 제일 높은 매칭유저No가 선택됨
									    bestMemberNo = maxCntNoArr.get(bestMemberArrIndex);
									
										System.out.println("추천받은 유저넘버 랜덤 1개 > "+bestMemberNo);
										
										Map<String, Object> bestMemberMap = frontDAO.selectMemberDetail(bestMemberNo);
										String bestMemberMatchDay = "";
										if(bestMemberMap.get("MATCHDATE") != null && !"".equals(String.valueOf(bestMemberMap.get("MATCHDATE")))){
											bestMemberMatchDay = (String.valueOf(bestMemberMap.get("MATCHDATE")));
											bestMemberMatchDay = bestMemberMatchDay.substring(0, 10);
										}
										
										//최적의 상대인 상대 유저가 이미 오늘의 매칭유저를 갖고 있는지 확인하고,
										if(today.equals(bestMemberMatchDay)){
											if (log.isDebugEnabled()) {
												log.debug("오늘은 상대방의 매칭상대 필터링 끝났음");
											}
											
											//매칭할 상대방이 없는 유저는 
											// ORDER_MATCH_MEMBERNO이 있었으면, 그 값을 ORDEST_MATCH_MEMBERNO에 넣고
											// MATCH_MEMBERNO이 있었으면, 그 값을 ORDER_MATCH_MEMBERNO에 넣고, 
											// MATCH_MEMBERNO와 MATCHDATE를 null 처리함.
											dbMap.clear();
											dbMap.put("no", memberNo);
											dbMap.put("expressStatus", "B");
											dbMap.put("deleteMatchMember", "ok");
											if(myMemberMap.get("OLDER_MATCH_MEMBERNO") != null && Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0 ){
												dbMap.put("oldestMatchMemberNo", Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
											}
											if(myMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
												dbMap.put("olderMatchMemberNo", Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()));
											}
											frontDAO.updateMember(dbMap);
											
										}
										else{
											//상대방이 오늘 매칭된 다른 유저가 없을 때, 내 매칭상대로 update.
											
											//나의 T_MEMBER 의 매칭상대No 저장
											dbMap.clear();
											dbMap.put("no", memberNo);
											dbMap.put("matchMemberNo", bestMemberNo);
											dbMap.put("expressStatus", "B");	//관심표현상태는 새로운 상대가 올 때마다 B(아직 표현안함) 으로 초기화
											if(myMemberMap.get("OLDER_MATCH_MEMBERNO") != null && Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0 ){
												dbMap.put("oldestMatchMemberNo", Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
											}
											if(myMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
												dbMap.put("olderMatchMemberNo", Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()));
											}
											frontDAO.updateMember(dbMap);
											
											//상대방의 T_MEMBER 의 매칭상대No 에 나를 저장
											dbMap.clear();
											dbMap.put("no", bestMemberNo);
											dbMap.put("matchMemberNo", memberNo);
											dbMap.put("expressStatus", "B");	//관심표현상태는 새로운 상대가 올 때마다 B(아직 표현안함) 으로 초기화
											if(bestMemberMap.get("OLDER_MATCH_MEMBERNO") != null && Integer.valueOf(bestMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0 ){
												dbMap.put("oldestMatchMemberNo", Integer.valueOf(bestMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
											}
											if(bestMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(bestMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
												dbMap.put("olderMatchMemberNo", Integer.valueOf(bestMemberMap.get("MATCH_MEMBERNO").toString()));
											}
											frontDAO.updateMember(dbMap);
										}
									}
								}
							}
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	public String expressMind(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		//디비 파라미터들 넣을 Map
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		try{
			System.out.println("관심표현 > "+map);
			String mind = (map.get("mind")).toString();
			int senderNo = Integer.valueOf((map.get("myMemberNo")).toString());
			int recipientNo = Integer.valueOf((map.get("matchMemberNo")).toString());
			String method = map.get("payMethod").toString();
			
			Map<String, Object> senderMap = frontDAO.selectMemberDetail(senderNo);
			int senderCash = Integer.valueOf((senderMap.get("CASH")).toString());
			
			if( senderMap.get("MATCH_MEMBERNO") == null ){
				//이미 해당 유저가 님의 매칭상대가 아님
				return "fail1";
			}
			
			//'좋아요' 누른 경우
			if("like".equals(mind)){
				//먼저 해당 유저의 관심표현상태 좋아요로 셋팅
				dbMap.clear();
				dbMap.put("no", senderNo);
				dbMap.put("expressStatus", "L");	//관심표현상태(L:좋아요)로 셋팅
				dbMap.put("cash", senderCash+10);	//관심표현을 하면 10 비행기 줌.
				frontDAO.updateMember(dbMap);
				
				//좋아요 메세지 보내기
				dbMap.clear();
				dbMap.put("kind", "like");
				dbMap.put("senderNo", senderNo);
				dbMap.put("recipientNo", recipientNo);
				dbMap.put("contents", "like");
				frontDAO.insertMessage(dbMap);
				
			} 
			//'저와 맞지 않아요' 누른 경우
			else if("notlike".equals(mind)){
				//먼저 해당 유저의 관심표현상태 좋아요로 셋팅
				dbMap.clear();
				dbMap.put("no", senderNo);
				dbMap.put("expressStatus", "X");	//관심표현상태(X:관심없음)으로 셋팅
				dbMap.put("cash", senderCash+10);	//관심표현을 하면 10 비행기 줌.
				frontDAO.updateMember(dbMap);
			}
			//'더 알아보고 싶어요' 누른 경우
			else if("love".equals(mind)){
				//먼저 메세지를 보낼 상대의 상태가 소개 가능한 상태인지 확인
				Map<String, Object> recipientMap = frontDAO.selectMemberDetail(recipientNo);
				
				if(recipientMap.get("ISPOSSIBLEMATCH") != null && "F".equals(recipientMap.get("ISPOSSIBLEMATCH").toString())){
					if (log.isDebugEnabled()) {
						log.debug("메세지를 보내고자 하는 회원이 소개중단 상태라서 메세지 못 보냄");
					}
					//해당유저가 소개중단 상태
					return "fail2";
				}
				
				String msgContents = (map.get("contents")).toString();
				
				//방법이 비행기일 경우
				if("cash".equals(method)){
				//먼저 해당 유저의 비행기 수 확인하고 50보다 적으면 return false
					if(senderCash >= 50){
						dbMap.clear();
						dbMap.put("no", senderNo);
						dbMap.put("cash", senderCash-50);	//더 알아보고 싶어요 표현을 하면 50 비행기 뺌.
						frontDAO.updateMember(dbMap);
						
						//더 알아보고 싶어요에 대한 메세지 보내기
						dbMap.clear();
						dbMap.put("kind", "common");
						dbMap.put("senderNo", senderNo);
						dbMap.put("recipientNo", recipientNo);
						dbMap.put("contents", msgContents);
						frontDAO.insertMessage(dbMap);
						
						return "success";
					} else {
						//보유 비행기 부족
						return "fail3";
					}
				}//방법이 아이템일 경우
				else if("item".equals(method)){
					dbMap.clear();
					dbMap.put("myMemberNo", senderNo);
					dbMap.put("isPossibleUse", "T");	//현재 사용가능 상태인 아이템만 불러옴
					List<Map<String, Object>> myItemList = frontDAO.selectMyItemList(dbMap);
					
					if(!myItemList.isEmpty()){
						for (Map<String, Object> myItem : myItemList) {
							int myItemIdx = Integer.valueOf((myItem.get("ITEM_IDX")).toString());
							String myItemKind = myItem.get("KIND").toString();
							int myItemPossibleUseCnt = Integer.valueOf((myItem.get("POSSIBLE_USE_CNT")).toString());	//총 사용가능 횟수
							int myItemUseCnt = Integer.valueOf((myItem.get("USE_CNT")).toString());						//사용한 횟수
							
							if("matchSuccess".equals(myItemKind)){
								//해당 아이템이 메세지보내기 및 수락하기에 쓰이는 아이템인 경우, 
								//해당 아이템의 사용횟수 == 총 사용가능횟수면 사용불가.
								//해당 아이템의 사용횟수 < 총 사용가능횟수 인 경우에만 사용 가능 후 break
								if(myItemUseCnt < myItemPossibleUseCnt){
									//해당 아이템 사용가능
									dbMap.clear();
									dbMap.put("myMemberNo", senderNo);
									dbMap.put("itemIdx", myItemIdx);
									dbMap.put("itemUseCnt", myItemUseCnt+1);
									frontDAO.updateMyItem(dbMap);
									
									//더 알아보고 싶어요에 대한 메세지 보내기
									dbMap.clear();
									dbMap.put("kind", "common");
									dbMap.put("senderNo", senderNo);
									dbMap.put("recipientNo", recipientNo);
									dbMap.put("contents", msgContents);
									frontDAO.insertMessage(dbMap);
									
									return "success";
								} else {
									//해당 아이템 사용불가능
									dbMap.clear();
									dbMap.put("myMemberNo", senderNo);
									dbMap.put("itemIdx", myItemIdx);
									dbMap.put("isPossibleUse", "F");	//사용불가로 바꿔줌
									
									frontDAO.updateMyItem(dbMap);
									
								}
							} else{
								//사용가능한 아이템 없음
								return "fail4";
							}
						}
						//사용가능한 아이템 없음
						return "fail4";
					} else {
						//사용가능한 아이템 없음
						return "fail4";
					}
				}
				
			}
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
			
		return "success";
	}
	
	@Override
	public boolean matchFail(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		//디비 파라미터들 넣을 Map
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		try{
			System.out.println("인연끊기 > "+map);
			int myMemberNo = Integer.valueOf((map.get("myMemberNo")).toString());
			int matchSuccessMemberNo = Integer.valueOf((map.get("matchSuccessMemberNo")).toString());
			String matchFailReason = map.get("matchFailReason").toString();
			
			Map<String, Object> myMemberMap = frontDAO.selectMemberDetail(myMemberNo);
			
			if(myMemberMap.get("MATCH_SUCCESS_MEMBERNO") == null || myMemberMap.get("MATCHSUCCESSDATE") == null){
				return false;
			}
			
			//인연끊기
			dbMap.clear();
			dbMap.put("myMemberNo", myMemberNo);
			dbMap.put("matchSuccessMemberNo", matchSuccessMemberNo);
			dbMap.put("isMatchSuccess", "F");	//소개팅 성사 상태를 인연끊기로 셋팅
			dbMap.put("matchFailReason", matchFailReason);
			frontDAO.updateMatchSuccessHistory(dbMap);
			
			dbMap.clear();
			dbMap.put("no", myMemberNo);
			dbMap.put("deleteMatchSuccessMember", "ok");
			frontDAO.updateMember(dbMap);
			
			dbMap.clear();
			dbMap.put("myMemberNo", matchSuccessMemberNo);
			dbMap.put("matchSuccessMemberNo", myMemberNo);
			dbMap.put("isMatchSuccess", "F");	//소개팅 성사 상태를 인연끊기로 셋팅
			dbMap.put("matchFailReason", matchFailReason);
			frontDAO.updateMatchSuccessHistory(dbMap);
			
			dbMap.clear();
			dbMap.put("no", matchSuccessMemberNo);
			dbMap.put("deleteMatchSuccessMember", "ok");
			frontDAO.updateMember(dbMap);
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
			
		return true;
	}
	
	@Override
	public boolean matchSuccess(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		//디비 파라미터들 넣을 Map
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		try{
			System.out.println("수락하기 > "+map);
			
			int myMemberNo = Integer.valueOf((map.get("myMemberNo")).toString());
			int matchSuccessMemberNo = Integer.valueOf((map.get("matchSuccessMemberNo")).toString());
			String method = map.get("method").toString();
			Map<String, Object> myMemberMap = frontDAO.selectMemberDetail(myMemberNo);
			
			//방법이 비행기일 경우
			if("cash".equals(method)){
				int myCash = Integer.valueOf((myMemberMap.get("CASH")).toString());
				
				//먼저 해당 유저의 비행기 수 확인하고 50보다 적으면 return false
				if(myCash >= 50){
					//내 T_MEMBER 부터 update.
					dbMap.clear();
					dbMap.put("no", myMemberNo);
					dbMap.put("matchSuccessMemberNo", matchSuccessMemberNo);	//내 MATCH_SUCCESS_MEMBERNO를 해당 유저 NO로 셋팅
					dbMap.put("deleteMatchMember", "ok");	//내 현재 매칭상대 없앰. (성사 됐으므로)
					dbMap.put("expressStatus", "B");	//내 관심표현 상태도 B로 초기화
					dbMap.put("cash", myCash-50);	//수락하기 누르면 50 비행기 뺌.
					if(myMemberMap.get("OLDER_MATCH_MEMBERNO") != null && Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0 ){
						dbMap.put("oldestMatchMemberNo", Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
					}
					if(myMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
						dbMap.put("olderMatchMemberNo", Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()));
					}
					frontDAO.updateMember(dbMap);
					
					Map<String, Object> matchSuccessMemberMap = frontDAO.selectMemberDetail(matchSuccessMemberNo);
					
					//상대방의 매칭상대의 T_MEMBER도 update(해당 유저의 현재 매칭 상대를 없앰)
					if(matchSuccessMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
						Map<String, Object> matchSuccessMemberMatchMemberMap = frontDAO.selectMemberDetail(Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()));
						
						dbMap.clear();
						dbMap.put("no", Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()));
						dbMap.put("deleteMatchMember", "ok");
						if(matchSuccessMemberMatchMemberMap.get("OLDER_MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMatchMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0 ){
							dbMap.put("oldestMatchMemberNo", Integer.valueOf(matchSuccessMemberMatchMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
						}
						if(matchSuccessMemberMatchMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMatchMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
							dbMap.put("olderMatchMemberNo", Integer.valueOf(matchSuccessMemberMatchMemberMap.get("MATCH_MEMBERNO").toString()));
						}
						frontDAO.updateMember(dbMap);
					}
					
					//상대방의 T_MEMBER도 update.
					dbMap.clear();
					dbMap.put("no", matchSuccessMemberNo);
					dbMap.put("matchSuccessMemberNo", myMemberNo);	//상대방의 MATCH_SUCCESS_MEMBERNO를 나의 멤버 NO로 셋팅
					dbMap.put("deleteMatchMember", "ok");	//상대방의 현재 매칭상대 없앰. (성사 됐으므로)
					dbMap.put("expressStatus", "B");	//상대방의 관심표현 상태도 B로 초기화
					if(matchSuccessMemberMap.get("OLDER_MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0 ){
						dbMap.put("oldestMatchMemberNo", Integer.valueOf(matchSuccessMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
					}
					if(matchSuccessMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
						dbMap.put("olderMatchMemberNo", Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()));
					}
					frontDAO.updateMember(dbMap);
					
					//성사된 내용 T_MATCH_SUCCESS_HISTORY 에 기록 남기기.
					dbMap.clear();
					dbMap.put("myMemberNo", myMemberNo);
					dbMap.put("matchSuccessMemberNo", matchSuccessMemberNo);
					dbMap.put("isMatchSuccess", "T");
					frontDAO.insertMatchSuccessHistory(dbMap);
					
					dbMap.clear();
					dbMap.put("myMemberNo", matchSuccessMemberNo);
					dbMap.put("matchSuccessMemberNo", myMemberNo);
					dbMap.put("isMatchSuccess", "T");
					frontDAO.insertMatchSuccessHistory(dbMap);
					
					return true;
				} else {
					return false;
				}
			}
			//방법이 아이템일 경우
			else if("item".equals(method)){
				dbMap.clear();
				dbMap.put("myMemberNo", myMemberNo);
				dbMap.put("isPossibleUse", "T");	//현재 사용가능 상태인 아이템만 불러옴
				List<Map<String, Object>> myItemList = frontDAO.selectMyItemList(dbMap);
				
				if(!myItemList.isEmpty()){
					for (Map<String, Object> myItem : myItemList) {
						int myItemIdx = Integer.valueOf((myItem.get("ITEM_IDX")).toString());
						String myItemKind = myItem.get("KIND").toString();
						int myItemPossibleUseCnt = Integer.valueOf((myItem.get("POSSIBLE_USE_CNT")).toString());	//총 사용가능 횟수
						int myItemUseCnt = Integer.valueOf((myItem.get("USE_CNT")).toString());						//사용한 횟수
						
						if("matchSuccess".equals(myItemKind)){
							//해당 아이템이 메세지보내기 및 수락하기에 쓰이는 아이템인 경우, 
							//해당 아이템의 사용횟수 == 총 사용가능횟수면 사용불가.
							//해당 아이템의 사용횟수 < 총 사용가능횟수 인 경우에만 사용 가능 후 break
							if(myItemUseCnt < myItemPossibleUseCnt){
								//해당 아이템 사용가능
								dbMap.clear();
								dbMap.put("myMemberNo", myMemberNo);
								dbMap.put("itemIdx", myItemIdx);
								dbMap.put("itemUseCnt", myItemUseCnt+1);
								
								frontDAO.updateMyItem(dbMap);
								
								//내 T_MEMBER 부터 update.
								dbMap.clear();
								dbMap.put("no", myMemberNo);
								dbMap.put("matchSuccessMemberNo", matchSuccessMemberNo);	//내 MATCH_SUCCESS_MEMBERNO를 해당 유저 NO로 셋팅
								dbMap.put("deleteMatchMember", "ok");	//내 현재 매칭상대 없앰. (성사 됐으므로)
								dbMap.put("expressStatus", "B");	//내 관심표현 상태도 B로 초기화
								if(myMemberMap.get("OLDER_MATCH_MEMBERNO") != null && Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0 ){
									dbMap.put("oldestMatchMemberNo", Integer.valueOf(myMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
								}
								if(myMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
									dbMap.put("olderMatchMemberNo", Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()));
								}
								frontDAO.updateMember(dbMap);
								
								Map<String, Object> matchSuccessMemberMap = frontDAO.selectMemberDetail(matchSuccessMemberNo);
								
								//상대방의 매칭상대의 T_MEMBER도 update(해당 유저의 현재 매칭 상대를 없앰)
								if(matchSuccessMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
									Map<String, Object> matchSuccessMemberMatchMemberMap = frontDAO.selectMemberDetail(Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()));
									
									dbMap.clear();
									dbMap.put("no", Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()));
									dbMap.put("deleteMatchMember", "ok");
									if(matchSuccessMemberMatchMemberMap.get("OLDER_MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMatchMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0 ){
										dbMap.put("oldestMatchMemberNo", Integer.valueOf(matchSuccessMemberMatchMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
									}
									if(matchSuccessMemberMatchMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMatchMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
										dbMap.put("olderMatchMemberNo", Integer.valueOf(matchSuccessMemberMatchMemberMap.get("MATCH_MEMBERNO").toString()));
									}
									frontDAO.updateMember(dbMap);
								}
								
								//상대방의 T_MEMBER도 update.
								dbMap.clear();
								dbMap.put("no", matchSuccessMemberNo);
								dbMap.put("matchSuccessMemberNo", myMemberNo);	//상대방의 MATCH_SUCCESS_MEMBERNO를 나의 멤버 NO로 셋팅
								dbMap.put("deleteMatchMember", "ok");	//상대방의 현재 매칭상대 없앰. (성사 됐으므로)
								dbMap.put("expressStatus", "B");	//상대방의 관심표현 상태도 B로 초기화
								if(matchSuccessMemberMap.get("OLDER_MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMap.get("OLDER_MATCH_MEMBERNO").toString()) > 0 ){
									dbMap.put("oldestMatchMemberNo", Integer.valueOf(matchSuccessMemberMap.get("OLDER_MATCH_MEMBERNO").toString()));
								}
								if(matchSuccessMemberMap.get("MATCH_MEMBERNO") != null && Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()) > 0 ){
									dbMap.put("olderMatchMemberNo", Integer.valueOf(matchSuccessMemberMap.get("MATCH_MEMBERNO").toString()));
								}
								frontDAO.updateMember(dbMap);
								
								//성사된 내용 T_MATCH_SUCCESS_HISTORY 에 기록 남기기.
								dbMap.clear();
								dbMap.put("myMemberNo", myMemberNo);
								dbMap.put("matchSuccessMemberNo", matchSuccessMemberNo);
								dbMap.put("isMatchSuccess", "T");
								frontDAO.insertMatchSuccessHistory(dbMap);
								
								dbMap.clear();
								dbMap.put("myMemberNo", matchSuccessMemberNo);
								dbMap.put("matchSuccessMemberNo", myMemberNo);
								dbMap.put("isMatchSuccess", "T");
								frontDAO.insertMatchSuccessHistory(dbMap);
								
								return true;
							} else {
								//해당 아이템 사용불가능
								dbMap.clear();
								dbMap.put("myMemberNo", myMemberNo);
								dbMap.put("itemIdx", myItemIdx);
								dbMap.put("isPossibleUse", "F");	//사용불가로 바꿔줌
								
								frontDAO.updateMyItem(dbMap);
								
							}
						} else{
							return false;
						}
					}
					return false;
				} else {
					return false;
				}
			}
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	public List<Map<String, Object>> selectMessageList(Map<String,Object> map) throws Exception {
		return frontDAO.selectMessageList(map);
	}
	
	@Override
	public List<Map<String, Object>> selectItemList(Map<String,Object> map) throws Exception {
		return frontDAO.selectItemList(map);
	}
	
	@Override
	public boolean buyItem(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		//디비 파라미터들 넣을 Map
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		try{
			System.out.println("아템 구매 > "+map);
			
			int myMemberNo = Integer.valueOf((map.get("myMemberNo")).toString());
			int itemIdx = Integer.valueOf((map.get("itemIdx")).toString());
			String payMethod = map.get("payMethod").toString();
			int payPrice = Integer.valueOf((map.get("payPrice")).toString());
			
			Map<String, Object> myMemberMap = frontDAO.selectMemberDetail(myMemberNo);
			int myCash = Integer.valueOf((myMemberMap.get("CASH")).toString());
			
			//비행기로 아이템 구매
			if("cash".equals(payMethod)){
				if(payPrice > myCash){
					//결제해야 할 비행기 수가 내가 현재 갖고 있는 비행기 수보다 많으면 return false
					return false;
				} else {
					//먼저 내 비행기 수 payPrice만큼 차감함.
					dbMap.clear();
					dbMap.put("no", myMemberNo);
					dbMap.put("cash", myCash-payPrice);	
					frontDAO.updateMember(dbMap);
					
					//아이템 구매내역 저장
					dbMap.clear();
					dbMap.put("itemIdx", itemIdx);
					dbMap.put("myMemberNo", myMemberNo);
					dbMap.put("isPossibleUse", "T");
					dbMap.put("useCnt", 0);
					frontDAO.insertMemberItem(dbMap);
					
					return true;
				}
			}
			//현금으로 아이템 구매(이건 결제모듈 붙인 후에 작성)
			else if("realCash".equals(payMethod)){
				//아이템 구매내역 저장
				dbMap.clear();
				dbMap.put("itemIdx", itemIdx);
				dbMap.put("myMemberNo", myMemberNo);
				dbMap.put("isPossibleUse", "T");
				dbMap.put("useCnt", 0);
				frontDAO.insertMemberItem(dbMap);
				
				return true;
			} 
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	public List<Map<String, Object>> selectMyItemList(Map<String,Object> map) throws Exception {
		return frontDAO.selectMyItemList(map);
	}
	
	@Override
	public boolean updateMypage(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		//디비 파라미터들 넣을 Map
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		try{
			String mode = map.get("mode").toString();
			int myMemberNo = Integer.valueOf(map.get("no").toString());
			Map<String, Object> myMemberMap = frontDAO.selectMemberDetail(myMemberNo);
			
			//비번수정
			if("EDIT_PW".equals(mode)){
				String pw = map.get("pw").toString();
				String newPw = map.get("newPw").toString();
				String newPwRe = map.get("newPwRe").toString();
				
				if(myMemberMap != null){
					if(pw == myMemberMap.get("PW").toString()){
						//기존 비번이 맞을 때 비번 변경 들어감
						dbMap.clear();
						dbMap.put("no", myMemberNo);
						dbMap.put("pw", newPw);
						frontDAO.updateMember(dbMap);
						
						return true;
					} else {
						//기존 비번이 잘못됨
						return false;
					}
				}
				
			} 
			//소개 중단
			else if("STOP_MATCH".equals(mode)){
				if(myMemberMap.get("MATCH_MEMBERNO") != null){
					//나와 매칭되어 있는 상대방이 있는경우, 그 상대방의 매칭상대인 나도 지움
					dbMap.clear();
					dbMap.put("no", Integer.valueOf(myMemberMap.get("MATCH_MEMBERNO").toString()));
					dbMap.put("deleteMatchMember", "ok");
					
					frontDAO.updateMember(dbMap);
				}
				
				if(myMemberMap.get("MATCH_SUCCESS_MEMBERNO") != null){
					//나와 매칭성사되어 있는 상대방이 있는경우, 그 상대방의 매칭성사상대인 나도 지움
					dbMap.clear();
					dbMap.put("no", Integer.valueOf(myMemberMap.get("MATCH_SUCCESS_MEMBERNO").toString()));
					dbMap.put("deleteMatchSuccessMember", "ok");
					
					frontDAO.updateMember(dbMap);
				}
				
				dbMap.clear();
				dbMap.put("no", myMemberNo);
				dbMap.put("isPossibleMatch", "F");	//매칭가능 상태 F로 셋팅
				dbMap.put("deleteMatchMember", "ok");	//기존 매칭상대 지움
				dbMap.put("deleteMatchSuccessMember", "ok");	//기존 매칭성사상대 지움
				
				frontDAO.updateMember(dbMap);
				
				return true;
			} 
			//소재 재개
			else if("START_MATCH".equals(mode)){
				dbMap.clear();
				dbMap.put("no", myMemberNo);
				dbMap.put("isPossibleMatch", "T");	//매칭가능 상태 T로 셋팅

				frontDAO.updateMember(dbMap);
				
				return true;
			}
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return true;
	}
	
	@Override
	public boolean secession(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception {
		
		//디비 파라미터들 넣을 Map
		Map<String, Object> dbMap = new HashMap<String, Object>();
		
		try{
			System.out.println("회원탈퇴 > "+map);
			int myMemberNo = Integer.valueOf((map.get("no")).toString());
			dbMap.put("memNo", myMemberNo);
			
			frontDAO.deleteMember(dbMap);
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
			
		return true;
	}
	
	
}
