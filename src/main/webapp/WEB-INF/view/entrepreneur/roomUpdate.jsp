<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
</head>
<body>

<div class="container" style="width: 800px; margin-top: 100px;">
<h2 style="text-align: center;">객실정보수정</h2>
  <form action="${pageContext.request.contextPath}/room/roomUpdatePro" method="post" name="f">
    <div class="mb-3 mt-3">
      <label>객실이름 : </label>
      <span id="roomNameCheck"></span>
      <input type="text" class="form-control" id="subject" name="ro_name" value="${room.ro_name}" onkeyup="roomCheck()" required>
    </div>
    <div class="mb-3">
      <label>가격</label>
      <input type="text" class="form-control" id="cal" name="ro_price" value="${room.ro_price}" required>
    </div>
	    <div style="width: 200px; float: left;">
	    	<label>체크인 시간</label>
	    	<input type="time" class="form-control" id="checkIn" name="checkin" value="${room.checkin}" required>
	    </div>
	    <div style="width: 200px; float:left; margin-bottom: 20px; margin-left: 20px;">
	    	<label>체크아웃 시간</label>
	    	<input type="time" class="form-control" id="checkOut" name="checkout" value="${room.checkout}" required>
    	</div>
    <div style="clear:both;"></div>
    
    <div class="mb-3" style="margin-top: 20px;">
    <label>객실이용인원</label>
    <select id="people" name="ro_count">
    	<option ${room.ro_count == '1' ? 'selected' : '' }>1</option>
    	<option ${room.ro_count == '2' ? 'selected' : '' }>2</option>
    	<option ${room.ro_count == '3' ? 'selected' : '' }>3</option>
    	<option ${room.ro_count == '4' ? 'selected' : '' }>4</option>
    </select>
    </div>
    	<div class="mb-3" >
    	<label style=" margin-bottom: 10px;">객실기본정보&nbsp;&nbsp;&nbsp;</label><span id="byteInfo" style="display: inline;">0</span> /4000bytes
   		<textarea rows="10" cols="100" name="ro_info" onKeyUp="javascript:fnChkByte(this,'4000')" required>${room.ro_info}</textarea>
    </div>
    
    <label style=" margin-bottom: 10px;">객실사진등록&nbsp;&nbsp;&nbsp;</label>
    <textarea rows="10" cols="100" name="location" required>${pic}</textarea>
    
    <input type="hidden" name="pic_num" value="${room.pic_num}">
	<input type="hidden" name="ro_num" value="${room.ro_num}">
    <button type="submit" class="default_btn rounded mt-1" style="width:100px;margin:auto; display:block;">등록</button>
  </form>

</div>
<script type="text/javascript">

function roomCheck(){
	const ro_name = document.f.ro_name.value;
	const roomNameCheck = document.querySelector("#roomNameCheck")
	$.ajax({
		type:'POST',
		url:'${pageContext.request.contextPath}/room/roomCheck',
		header:{"Content-Type":"application/json"},
		dateType:'json',
		data:{ro_name:ro_name},
		success : function(result){
			if(result == true){
				roomNameCheck.innerHTML = '중복된 객실 이름이 존재합니다.';
				roomNameCheck.style.color = 'red';
			} else {
				roomNameCheck.innerHTML = '사용가능합니다';
				roomNameCheck.style.color = 'blue';
			}
		}
	})
}

//Byte 수 체크 제한
function fnChkByte(obj, maxByte)
{
    var str = obj.value;
    var str_len = str.length;


    var rbyte = 0;
    var rlen = 0;
    var one_char = "";
    var str2 = "";


    for(var i=0; i<str_len; i++)
    {
        one_char = str.charAt(i);
        if(escape(one_char).length > 4) {
            rbyte += 3;                                         //한글3Byte
        }else{
            rbyte++;                                            //영문 등 나머지 1Byte
        }
        if(rbyte <= maxByte){
            rlen = i+1;                                          //return할 문자열 갯수
        }
     }
     if(rbyte > maxByte)
     {
        // alert("한글 "+(maxByte/2)+"자 / 영문 "+maxByte+"자를 초과 입력할 수 없습니다.");
        alert("메세지는 최대 " + maxByte + "byte를 초과할 수 없습니다.")
        str2 = str.substr(0,rlen);                                  //문자열 자르기
        obj.value = str2;
        fnChkByte(obj, maxByte);
     }
     else
     {
        document.getElementById('byteInfo').innerText = rbyte;
     }
}
	
</script>
</body>
</html>