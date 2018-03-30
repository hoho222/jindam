package doto.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

@Repository("frontDAO")
public class FrontDAO extends AbstractDAO{

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectNoticeList(Map<String, Object> map) {
		
		return (List<Map<String, Object>>)selectList("front.selectNoticeList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectNoticeCnt() {
		
		return (Map<String, Object>)selectOne("front.selectNoticeCnt");
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectNoticeDetail(String idx) {
		
		return (Map<String, Object>)selectOne("front.selectNoticeDetail", idx);
	}
	
	public void updateNoticeHitCnt(String idx) throws Exception{
		update("front.updateNoticeHitCnt", idx);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMemberDetail(int no) {
		
		return (Map<String, Object>)selectOne("front.selectMemberDetail", no);
	}
	
	//쨩
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMemberInfo(int no) {
		
		return (Map<String, Object>)selectOne("front.selectMemberInfo", no);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMemberInfoForMap(Map<String, Object> map) {
		
		return (Map<String, Object>)selectOne("front.selectMemberInfoForMap", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectGoalResult(String idx) {
		
		return (Map<String, Object>)selectOne("front.selectGoalResult", idx);
	}
	
	public void insertMemberInfo(Map<String, Object> map) throws Exception{
		insert("front.insertMemberInfo", map);
	}
	
	public void insertMemberInfoPass(Map<String, Object> map) throws Exception{
		insert("front.insertMemberInfoPass", map);
	}
	
	public void updateMemberInfo(Map<String, Object> map) throws Exception{
		update("front.updateMemberInfo", map);
	}
	
	public void updateMember(Map<String, Object> map) throws Exception{
		System.out.println("디비맵> "+map);
		update("front.updateMember", map);
	}
	
	
	public void insertMember(Map<String, Object> map) throws Exception{
		insert("front.insertMember", map);
	}
	
	public void insertMemberAccessLog(Map<String, Object> map) throws Exception{
		insert("front.insertMemberAccessLog", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMember(Map<String, Object> map) {
		
		return (Map<String, Object>)selectOne("front.selectMember", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMemberList(Map<String, Object> map) {
		
		return (List<Map<String, Object>>)selectList("front.selectMemberList", map);
	}
	
	public String isMemberCnt(Map<String, Object> map) {
		
		return (String)selectOne("front.isMemberCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMemberInfoList(@RequestParam Map<String,Object> map) {
		
		return (List<Map<String, Object>>)selectList("front.selectMemberInfoList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBlindDatePeople(Map<String, Object> map) {
		
		return (Map<String, Object>)selectOne("front.selectBlindDatePeople", map);
	}
	
	public void insertMessage(Map<String, Object> map) throws Exception{
		insert("front.insertMessage", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMessageList(Map<String,Object> map) {
		return (List<Map<String, Object>>)selectList("front.selectMessageList", map);
	}
	
	public void insertMatchSuccessHistory(Map<String, Object> map) throws Exception{
		insert("front.insertMatchSuccessHistory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMatchFailMemberList(Map<String, Object> map) {
		
		return (List<Map<String, Object>>)selectList("front.selectMatchFailMemberList", map);
	}
	
	public void updateMatchSuccessHistory(Map<String, Object> map) throws Exception{
		update("front.updateMatchSuccessHistory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectItemList(Map<String,Object> map) {
		return (List<Map<String, Object>>)selectList("front.selectItemList", map);
	}
	
	public void insertMemberItem(Map<String, Object> map) throws Exception{
		insert("front.insertMemberItem", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyItemList(Map<String,Object> map) {
		return (List<Map<String, Object>>)selectList("front.selectMyItemList", map);
	}
	
	public void updateMyItem(Map<String,Object> map) throws Exception{
		update("front.updateMyItem", map);
	}
	
	public void deleteMember(Map<String, Object> map) throws Exception{
		update("front.deleteMember", map);
	}
}
