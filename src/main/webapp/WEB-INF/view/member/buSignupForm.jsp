<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	let phoneAuth = true;
	let passCheck = true;
	let emailCheck = true;
	
	function auth() {
		const telNum = document.f.bu_tel.value;
		$.ajax({
			type:'POST',
			url:'${pageContext.request.contextPath}/member/buPhoneAuth',
			header:{"Content-Type":"application/json"},
			dateType:'json',
			data:{tel:telNum},
			success : function(result){
				if(result == true){
					alert('이미 가입된 전화번호 입니다.')
				} else {
					alert('인증 번호를 전송했습니다.')
					
					const code_btn = document.getElementById("code_btn")
					code_btn.disabled = false
				}
			}
		})
	}

	function authCheck(){
		const code = document.f.code.value;
		$.ajax({
			type:'POST',
			url:'${pageContext.request.contextPath}/member/phoneAuthOk',
			header:{"Content-Type":"application/json"},
			dateType:'json',
			data:{code:code},
			success : function(result){
				if(result == true){
					alert('인증 번호가 다릅니다.')
					phoneAuth=true
					inputCheck()
				} else {
					alert('인증되었습니다')
					const input_tel = document.getElementById("input_tel")
					input_tel.readOnly = true
					
					const input_code = document.getElementById("input_code")
					input_code.readOnly = true
					
					const tel_btn = document.getElementById("tel_btn")
					tel_btn.disabled = true
					
					const code_btn = document.getElementById("code_btn")
					code_btn.disabled = true
					
					phoneAuth=false
					inputCheck()
				}
			}
		})
	}

	function emailChk(){
		const email = document.f.bu_email.value
		let resultText = document.querySelector("#result")
		
		if(email.indexOf('@') != -1 && email.indexOf('.com') != -1){
			$.ajax({
				type:'POST',
				url:'${pageContext.request.contextPath}/member/readId',
				header:{"Content-Type":"application/json"},
				dateType:'json',
				data:{email:email},
				success : function(result){
					if(result == true){
						resultText.style.color = 'red'
						resultText.innerHTML = '중복되는 이메일'
						emailCheck = true
						inputCheck()
					} else {
						resultText.style.color = 'blue'
						resultText.innerHTML = '사용가능한 이메일'
						emailCheck = false
						inputCheck()
					}
				}
			})
		} else {
			result.style.color = 'red'
			result.innerHTML = '일치하지 않는 형식'
		} 
	}
	
	function change_bu_id(){
		const id = document.getElementById("select_bu_id");
		const value = id.options[id.selectedIndex].value;
		document.f.bu_id.value = value
	}
	
	function passChk() {
		const pass = document.f.bu_password.value
		const passChk = document.f.passC.value
		let result = document.querySelector("#passResult")
		
		if(pass == passChk){
			result.style.color = 'blue'
			result.innerHTML = '일치하는 비밀번호'
			
			passCheck = false
			inputCheck()
			
		} else {
			result.style.color = 'red'
			result.innerHTML = '일치하지 않는 비밀번호'
			
			passCheck = true
			inputCheck()
		}
	}
	
	function inputCheck() {
		if(phoneAuth == false && passCheck == false && emailCheck == false){
			const submit = document.getElementById("submit")
			submit.disabled = false
		} else {
			submit.disabled = true
		}
	}
</script>

</head>
<body>



<div class="signup_form_width">
		<div style="text-align : center;">
			<b class="large_text" style="color:#ffc107;">회원가입</b>
		</div>
	<form name="f" action="${pageContext.request.contextPath}/member/buSignupPro" method="post">
	
		<!-- <input type="text" name="rand" id="rand"> 핸드폰 인증번호 확인용 -->
		
		<div class="row mt-5">
			<div class="col-sm-8">
				<input type="tel" name="bu_tel" id="input_tel" class="form-control form-control-lg" 
					id="tel" placeholder="전화번호(- 빼고 작성해주세요)" pattern="[0-9]{11}" required>
			</div>
			<div class="col-sm-4">
				<button type="button" id="tel_btn" class="default_btn rounded" style="height: 48px;" onclick="auth()">인증코드 전송</button>
			</div>
		</div>
		<div class="row mt-3">
			<div class="col-sm-8">
				<input type="text" name="code" id="input_code" class="form-control form-control-lg" placeholder="전송받은 6자리 코드"  pattern="[0-9]{6}" required>
			</div>
			<div class="col-sm-4">
				<button type="button" id="code_btn" class="default_btn rounded" style="height: 48px;" onclick="authCheck()" disabled>코드 확인</button>
			</div>
		</div>
		
		<div class="form-floating mt-3">
		  <input type="email" name="bu_email" class="form-control" id="bu_email" onkeyup="emailChk()" required>
		  <label><span id="result">이메일</span></label>
		</div>
		
		<div class="form-floating mt-3">
		  <input type="password" name="bu_password" class="form-control form-control-lg mt-3" pattern="^(?=.*[a-zA-z])(?=.*[0-9]).{6,12}$" required>
		  <label><span>비밀번호 - 대문자 혹은 소문자와 숫자를 합해 6자리 이상 12자리 이하</span></label>
		</div>
		<div class="form-floating mt-3">
		  <input type="password" name="passC" class="form-control form-control-lg mt-3" onkeyup="passChk()" pattern="^(?=.*[a-zA-z])(?=.*[0-9]).{6,12}$" required>
		  <label><span id="passResult">비밀번호 확인</span></label>
		</div>
		
		
		
		
		<div class="mt-3">
			<input type="text" name="bu_name" class="form-control form-control-lg" placeholder="이름" required>
		</div>
		
		<div class="row mt-3">
			<div class="col-sm-4">
				<input type="hidden" name="bu_id" value="1"> <!-- select 저장용 -->
				<select id="select_bu_id" class="form-select form-select-lg" onchange="change_bu_id()">
				     <option value="1">호텔</option>
				     <option value="2">모텔</option>
				     <option value="3">펜션</option>
				     <option value="4">리조트</option>
			   	</select>
			</div>
			
			<div class="col-sm-8">
				<input type="text" name="bu_title" class="form-control form-control-lg" placeholder="업체 이름" required>
			</div>
		</div> 
		
		<input type="text" name="bu_address" class="form-control form-control-lg mt-3" placeholder="업체 주소"  required>
		
		<label style=" margin-bottom: 10px;">객실사진등록&nbsp;&nbsp;&nbsp;</label>
    	<textarea class="form-control form-control-lg" rows="10" cols="100" name="picLocation"></textarea>
		<input type="submit" id="submit" class="default_btn rounded mt-3" value="회원가입" disabled>
		  
	</form>
</div>

</body>
</html>