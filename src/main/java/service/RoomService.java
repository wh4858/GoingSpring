package service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import model.Booking;
import model.Business;
import model.Picture;
import model.Room;
import model.SearchDTO;
import repository.RoomDao;
import util.DateParse;

@Service
public class RoomService {
	private Map<Object, Object> serviceMap = new HashMap<Object, Object>();
	private Map<String, Object> map = new HashMap<String, Object>();
	private final RoomDao roomDao;
	
	@Autowired
	public RoomService(RoomDao roomDao) {
		this.roomDao = roomDao;
	}

	
	public List<Room> roomList(String bu_email) throws Exception{
		return roomDao.roomList(bu_email);
	}
	
	public int roomInsertPro(Room room, String bu_email) throws Exception {
		
		Picture p = new Picture();
		int picResult = 0;
		
		int roomNum = roomDao.nextRoNum();
		int picNum = roomDao.nextPicNum();
		
		room.setRo_num(roomNum);
		room.setBu_email(bu_email);
		room.setPic_num(picNum);
		
		System.out.println(room);
		
		String[] picList = room.getLocation().split("\\n");
		
		for (String pic : picList) {
//			사진 링크를 picture table에 저장
			p = new Picture(picNum, pic.trim());
			picResult = roomDao.insertPicture(p);
			if(picResult == 0)
				break;
		}
		
//		room객체에 저장된 값을 room table에 저장
		int roomResult = roomDao.insertRoom(room);
		
		if(picResult == 0 || roomResult == 0)
			return 0;
		
		return 1;
	}
	

	public Map<Object, Object> roominfo(Integer ro_num) throws Exception{

		List<String> p_list = new ArrayList<String>();
		
		Room room = roomDao.selectRoom(ro_num);
		List<Picture> picList = roomDao.selectPic(room.getPic_num());
		for(int i=0; i<picList.size();i++) {
			p_list.add(picList.get(i).getLocation());
		}
//		선택한 객실의 정보를 가져와서 저장
		String info = room.getRo_info().replace("\\n", "<br/>");
		serviceMap.clear();
		serviceMap.put("p_list", p_list);
		serviceMap.put("room", room);
		serviceMap.put("ro_num", ro_num);
		serviceMap.put("pic_num", room.getPic_num());
		serviceMap.put("info", info);
		
		return serviceMap;
	}
	
	public Map<Object, Object> roomUpdate(Integer ro_num, Integer pic_num) throws Exception {

		String pic = "";
		
		Room room = roomDao.selectRoom(ro_num);
		List<Picture> piclist = roomDao.selectPic(pic_num);
		
		for(Picture p : piclist) {
			pic += p.getLocation()+"\n";
		}
		serviceMap.clear();
		serviceMap.put("room", room);
		serviceMap.put("pic", pic);
		return serviceMap;
	}
	
	@Transactional()
	public int roomUpdatePro(Room room) throws Exception {
		Picture picture = null;
		int picResult = 0;
		int p = roomDao.deleteLocation(room.getPic_num());
		
		String[] picList = room.getLocation().split("\\n");
		
		for (String pic : picList) {
//			사진 링크를 picture table에 저장
			picture = new Picture(room.getPic_num(), pic.trim());
			picResult = roomDao.insertPicture(picture);
			if(picResult == 0)
				break;
		}
		
//		room객체에 저장된 값을 room table에 저장
		int roomResult = roomDao.updateRoom(room);
		
		if(picResult == 0 || roomResult == 0)
			return 0;
		
		return 1;
	}
	
	public int roomDeltePro(Room r, Business bu, String bu_email) throws Exception{
//		객실을 삭제하기 위해 사업자 비밀번호와 입력한 비밀번호 비교
		String pwd = bu.getBu_password();
		int ro_num = r.getRo_num();
		int room = 0;
		// 사업자 비밀번호 찾기
		Business business = roomDao.selectBu(bu_email);
		
		serviceMap.clear();
		if(pwd == null || "".equals(pwd) || !pwd.equals(business.getBu_password())) {
			serviceMap.put("msg", "비밀번호가 틀렸습니다.");
		}else {
			// 비밀번호가 일치하면 객실 삭제
			map.clear();
			map.put("bu_email", bu_email);
			map.put("ro_num", ro_num);
			room = roomDao.deleteRoom(map);
		}
		
		return room;
	}
	
	public Map<Object, Object> reservation(String search, String searchName, HttpServletRequest request, 
			String bu_email, int startPage, int endPage)throws Exception {
		
		serviceMap.clear();
		map.put("bu_email", bu_email);
		map.put("startPage", startPage);
		map.put("endPage", endPage);
		// =========== 현재 시간 ==============
		LocalDate now = LocalDate.now();
		// 포맷 정의
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		// 포맷 적용
		String nowDay = now.format(formatter);
		
//		예약 내역 찾기
		List<Booking> bk = new ArrayList<Booking>();
//		검색할 컬럼이름
		map.put("searchName", searchName);
//		검색할 컬럼 값
		map.put("search", search);
		int count = 0;
		
		if("".equals(searchName) || searchName == null || search == null || "".equals(search)) {
			bk = roomDao.selectBkList(map);
			count = roomDao.countBoard(map);
		}
		else if("status".equals(searchName)) {
			if("예약완료".equals(search)) {
				map.put("status", "1");
			}
			else if("결제취소".equals(search)) {
				map.put("status", "2");
			}
			else if("이용완료".equals(search)) {
				map.put("status", "3");
			}
			else if("입실완료".equals(search)) {
				map.put("status", "4");
			}
			else {
				String msg = "예약완료, 결제취소, 이용완료 , 입실완료중 하나를 입력하세요.";
				String url = request.getContextPath()+"/room/reservation";
				serviceMap.put("msg", msg);
				serviceMap.put("url", url);
				
				return serviceMap;
			}
			bk = roomDao.searchStatus(map);
			count = roomDao.countBoardStatus(map);
		}
		else {
			bk = roomDao.searchName(map);
			count = roomDao.countBoardSearchName(map);
		}
		serviceMap.put("bk", bk);
		serviceMap.put("count", count);
		
		return serviceMap;
	}
	
	@SuppressWarnings("unchecked")
	public Map<Object, Object> sales(String bu_email) throws Exception {
		
		String[] month = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"};
		map.clear();
		map.put("bu_email", bu_email);
		
		String result = "";
		for(String mon : month) {
			map.put("mon", mon);
			Booking bo = roomDao.selectSales(map);
			if(result!="") { 
				result += ","; 
			}

			if(bo == null) {
				result += "['"+mon+"월', "+"0"+"]";

			}
			else {
				result += "['"+mon+"월', "+bo.getPrice()+"]";
			}
		}
		serviceMap.clear();
		serviceMap.put("result", result);
		return serviceMap;
	}
	
	public Map<Object, Object> todayCheckin(String bu_email) throws Exception {
		
		String checkin = DateParse.getTodayPlus(0);
		
		map.clear();
		map.put("bu_email", bu_email);
		map.put("checkin", checkin);
//		아직 체크인 안한 객실내역
		List<Booking> notCheckin = roomDao.selectNotCheckin(map);
//		체크인 완료한 객실내역
		List<Booking> checkinOk = roomDao.selectcheckinOk(map);
		
		serviceMap.clear();
		serviceMap.put("notCheckin", notCheckin);
		serviceMap.put("checkinOk", checkinOk);
		return serviceMap;
	}
	
	
	public void updateTodayCheckin(String bo_num, String bu_email) throws Exception {
		String checkin = DateParse.getTodayPlus(0);
		
		map.clear();
		map.put("bu_email", bu_email);
		map.put("bo_num", bo_num);
		map.put("checkin", checkin);
		
		int rowCnt = roomDao.updateTodayCheckin(map);
	}
	
	public Map<Object, Object> todayCheckOut(String bu_email) throws Exception {
		
		String checkout = DateParse.getTodayPlus(0);
		
		map.clear();
		map.put("bu_email", bu_email);
		map.put("checkout", checkout);
//		아직 체크아웃 안한 객실 내역
		List<Booking> notCheckOut = roomDao.selectNotCheckOut(map);
//		체크아웃하고 나간 객실 내역
		List<Booking> checkOutOk = roomDao.selectcheckOutOk(map);
		System.out.println("checkOutOk = "+ checkOutOk);
		serviceMap.clear();
		serviceMap.put("notCheckOut", notCheckOut);
		serviceMap.put("checkOutOk", checkOutOk);
		return serviceMap;
	}
	
	public void updateTodayCheckOut(String bu_email, String bo_num) throws Exception {
		
		String checkout = DateParse.getTodayPlus(0);
		
		map.clear();
		map.put("bu_email", bu_email);
		map.put("bo_num", bo_num);
		map.put("checkout", checkout);
		
		int rowCnt = roomDao.countReserved(map);
		System.out.println("rowCnt = " + rowCnt);
		if(rowCnt > 0) {
			int delete = roomDao.deleteReserved(map);
		}
		
		roomDao.updateTodayCheckOut(map);
		
	}


	@SuppressWarnings("unchecked")
	public Map<Object, Object> addressList(SearchDTO searchDTO) throws Exception {
		
		String bu_id = searchDTO.getBu_id();
		String ro_count = searchDTO.getRo_count();
		String checkin = searchDTO.getCheckin();
		String checkout = searchDTO.getCheckout();
		String bu_address = searchDTO.getBu_address();
		
		if(bu_address == null  || bu_id == null || checkin == null ||  checkout == null) {
			bu_address = "서울";
			bu_id = "1";
			checkin = DateParse.strToDate(DateParse.getTodayPlus(0));
			checkout = DateParse.strToDate(DateParse.getTodayPlus(1));
		}
		
		map.put("bu_address", bu_address);
		map.put("bu_id", bu_id);
		
		List<Business> addressList = new ArrayList<Business>();
		addressList = roomDao.addressList(map);
		
		String resultAddress = "[";
		String roomTitle = "[";
		String roomPic = "[";
		String bu_email = "[";
		
			for(int i = 0 ; i < addressList.size(); i++) {
			if(i == addressList.size()-1) {
				resultAddress += "'"+addressList.get(i).getBu_address().trim()+"'";
				roomTitle += "'"+addressList.get(i).getBu_title().trim()+"'";
				roomPic += "'"+addressList.get(i).getLocation().trim()+"'";
				bu_email += "'"+addressList.get(i).getBu_email().trim()+"'";
			}
			else {
				resultAddress += "'"+addressList.get(i).getBu_address().trim()+"', ";
				roomTitle += "'"+addressList.get(i).getBu_title().trim()+"', ";
				roomPic += "'"+addressList.get(i).getLocation().trim()+"', ";
				bu_email += "'"+addressList.get(i).getBu_email().trim()+"', ";
			}
		}
		resultAddress += "]";
		roomTitle += "]";
		roomPic += "]";
		bu_email += "]";
		
		serviceMap.put("resultAddress", resultAddress);
		serviceMap.put("roomTitle", roomTitle);
		serviceMap.put("roomPic", roomPic);
		serviceMap.put("bu_email", bu_email);
		serviceMap.put("bu_id", bu_id);
		serviceMap.put("ro_count", ro_count);
		serviceMap.put("checkin", checkin);
		serviceMap.put("checkout", checkout);
		serviceMap.put("bu_address", bu_address);
		
		return serviceMap;
	}


	public Room getRo_name(String ro_name, String bu_email) throws Exception{
		map.clear();
		map.put("ro_name", ro_name);
		map.put("bu_email", bu_email);
		return roomDao.getRo_name(map);
	}


	public int updateReply(int rev_num, String content_reply) throws Exception{
		map.clear();
		map.put("rev_num", rev_num);
		map.put("content_reply", content_reply);
		return roomDao.updateReply(map);
	}


	public int deleteReply(Integer rev_num) throws Exception{
		return roomDao.deleteReply(rev_num);
	}


	public int reviewApproval(Integer rev_num) throws Exception{
		return roomDao.reviewApproval(rev_num);
	}


	public int reportCancle(Integer rev_num) throws Exception{
		return roomDao.reportCancle(rev_num);
	}

}
