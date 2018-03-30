package doto.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("adminDAO")
public class AdminDAO extends AbstractDAO {
	
	@SuppressWarnings("unchecked")
	public String selectMemberCnt(Map<String, Object> map) {
		
		return (String)selectOne("admin.selectMemberCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public String selectGoalCnt(Map<String, Object> map) {
		
		return (String)selectOne("admin.selectGoalCnt", map);
	}
	
	public String isAdminCnt(Map<String, Object> map) {
		
		return (String)selectOne("admin.isAdminCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectAdmin(Map<String, Object> map) {
		
		return (Map<String, Object>)selectOne("admin.selectAdmin", map);
	}

	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMemberPassReadyList() {
		
		return (List<Map<String, Object>>)selectList("admin.selectMemberPassReadyList");
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMember(Map<String, Object> map) {
		
		return (Map<String, Object>)selectOne("admin.selectMember", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMemberInfo(Map<String, Object> map) {
		
		return (Map<String, Object>)selectOne("admin.selectMemberInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMemberInfoPass(Map<String, Object> map) {
		
		return (Map<String, Object>)selectOne("admin.selectMemberInfoPass", map);
	}
	
	public void updateMember(Map<String, Object> map) throws Exception{
		update("admin.updateMember", map);
	}
	
	public void updateMemberInfo(Map<String, Object> map) throws Exception{
		update("admin.updateMemberInfo", map);
	}
	
	public void updateMemberInfoPass(Map<String, Object> map) throws Exception{
		update("admin.updateMemberInfoPass", map);
	}
	
	public void insertMemberInfoPass(Map<String, Object> map) throws Exception{
		insert("admin.insertMemberInfoPass", map);
	}
	
	public void deleteMemberInfo(Map<String, Object> map) throws Exception{
		insert("admin.deleteMemberInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectNoticeList() {
		
		return (List<Map<String, Object>>)selectList("admin.selectNoticeList");
	}
	
	public void insertNotice(Map<String, Object> map) throws Exception{
		insert("admin.insertNotice", map);
	}
	
	public void updateAdminLastAccess(String idx) throws Exception{
		update("admin.updateAdminLastAccess", idx);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectItemList() {
		
		return (List<Map<String, Object>>)selectList("admin.selectItemList");
	}
	
	public void insertItem(Map<String, Object> map) throws Exception{
		insert("admin.insertItem", map);
	}
}
