package doto.svc.front;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

@Service("frontService")
public interface FrontService {
	
	/**
    * 공지사항 리스트 Read
    * @throws Exception the exception
    */
	List<Map<String, Object>> selectNoticeList(Map<String, Object> map) throws Exception;
	
	/**
    * 공지사항 리스트 Count Read
    * @throws Exception the exception
    */
	Map<String, Object> selectNoticeCnt() throws Exception;
	
	/**
    * 공지사항 상세(1건) Read
    * @throws Exception the exception
    */
	Map<String, Object> selectNoticeDetail(String idx) throws Exception;
	
	/**
    * 공지사항 상세Read 시, 해당 글 카운트 1up
    * @throws Exception the exception
    */
	void updateNoticeHitCnt(String idx) throws Exception;
	
	/**
    * 멤버 Update
    * @throws Exception the exception
    */
	void updateMember(Map<String, Object> map) throws Exception;
	
	/**
    * 본인인증 프로세스
    * @throws Exception the exception
    */
	Map<String, Object> userAuthProcess(Map<String, Object> map) throws Exception;
	
	/**
    * 개인정보 Create
    * @throws Exception the exception
    */
	void insertMemberInfo(Map<String, Object> map) throws Exception;
	
	/**
    * 개인정보 Update
    * @throws Exception the exception
    */
	void updateMemberInfo(Map<String, Object> map) throws Exception;
	
	/**
    * 회원 상세(1건) Read
    * @throws Exception the exception
    */
	Map<String, Object> selectMemberDetail(int no) throws Exception;
	
	/**
    * 회원 Create
    * @throws Exception the exception
    */
	void insertMember(Map<String, Object> map) throws Exception;
	
	
	/**
    * 회원 가입 시 이메일 주소 중복확인
    * @return true, 중복안됨 / false, 중복됨
    * @throws Exception the exception
    */
	boolean memberOverlap(Map<String,Object> map) throws Exception;
	
	/**
    * 광고 보상 지급 (비행기 +10) 
    * @return true, 광고 보상 지급 성공 / false, 광고 보상 지급 실패
    * @throws Exception the exception
    */
	boolean isAdReward(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception;
	
	/**
    * 로그인 성공여부 파악 
    * @return true, 로그인성공 / false, 로그인실패
    * @throws Exception the exception
    */
	boolean isLoginOk(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception;
	
	
	/**
    * 회원 정보 상세 Read
    * @throws Exception the exception
    */
	Map<String, Object> selectMemberInfo(int no) throws Exception;
	
	/**
    * 모든 유저들 소개팅 상대 매칭 알고리즘
    * @throws Exception the exception
    */
	boolean matchDatePeople() throws Exception;
	
	/**
    *  관심표현 
    * @return String
    * @throws Exception the exception
    */
	String expressMind(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception;
	
	/**
    *  소개팅 성사된 유저와 인연끊기 
    * @return true, 인연끊기 성공 / false, 인연끊기 실패
    * @throws Exception the exception
    */
	boolean matchFail(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception;
	
	/**
    * 내가 받은 메세지 리스트 Read
    * @throws Exception the exception
    */
	List<Map<String, Object>> selectMessageList(Map<String,Object> map) throws Exception;
	
	/**
    *  소개팅 성사 (수락하기 버튼 누름)
    * @return true, 수락 성공 / false, 수락 실패
    * @throws Exception the exception
    */
	boolean matchSuccess(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception;
	
	/**
    * 아이템 리스트 Read
    * @throws Exception the exception
    */
	List<Map<String, Object>> selectItemList(Map<String,Object> map) throws Exception;

	/**
    *  아이템 구매처리
    * @return true, 구매 성공 / false, 구매 실패
    * @throws Exception the exception
    */
	boolean buyItem(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception;
	
	/**
    * 내가 보유한 아이템 리스트 Read
    * @throws Exception the exception
    */
	List<Map<String, Object>> selectMyItemList(Map<String,Object> map) throws Exception;
	
	/**
    *  마이페이지 비번 변경 or 소개중단 및 재개
    * @throws Exception the exception
    */
	boolean updateMypage(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception;
	
	/**
    *  회원탈퇴 
    * @return true, 인연끊기 성공 / false, 인연끊기 실패
    * @throws Exception the exception
    */
	boolean secession(Map<String,Object> map, HttpServletResponse response, HttpServletRequest request) throws Exception;
}
