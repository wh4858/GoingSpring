<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script type="text/javascript">

Kakao.init('7c7fc9be5a5c5e37975ce524e7a39cf2');
console.log(Kakao.isInitialized());

function loginWithKakao() {
  Kakao.Auth.login({
    success: function(authObj) {
      /* alert(JSON.stringify(authObj)) */ 
      
      Kakao.API.request({
       url: '/v2/user/me',
       success: function(res) {
         /* alert(JSON.stringify(res)) */
         const id = res.id
         const name = res.properties.nickname
         location.href='${pageContext.request.contextPath}/member/kakaoLogin?id='+id+'&name='+name
       },
       fail: function(error) {
         alert(
           'login success, but failed to request user information: ' +
             JSON.stringify(error)
         )
       },
     })
      
    },
    fail: function(err) {
      alert(JSON.stringify(err))
    },
  })
}
</script>

</head>
<body>

	<div class="login_form_width" style="padding-top:100px; margin-bottom: 100px">
		<div class="large_text active" style="text-align: center;">
			<img alt="logo" src="${pageContext.request.contextPath}/resources/image/colorlogo.png" style="width: 200px;"><br>
		</div>
		<!-- Nav tabs -->
		<ul class="nav nav-tabs nav-justified mt-3" role="tablist" style="width:312px; margin:0 auto;">
			<li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" style="color:black;" href="#member-login">고객 로그인</a></li>
			<li class="nav-item"><a class="nav-link" data-bs-toggle="tab" style="color:black;" href="#business-login">사업자 로그인</a></li>
		</ul>

		<!-- Tab panes -->
		<div class="tab-content">
			
			<!-- 고객 로그인 폼 -->
			<div id="member-login" class="container tab-pane active">
				<form action="${pageContext.request.contextPath}/member/loginPro" method="post">

					<input type="text" name="email" class="form-control form-control-lg mt-3" placeholder="이메일" autocomplete="username"> 
					<input type="password" name="password" class="form-control form-control-lg mt-1" placeholder="비밀번호" autocomplete="current-password"> 
					<input type="submit" class="default_btn rounded mt-3" value="로그인">
					
					<!-- 카카오톡 로그인 -->
					<a id="custom-login-btn" href="javascript:loginWithKakao()">
						<button type="button" class="default_btn rounded mt-1" style="background: rgb(252, 229, 30);">
							<span class="small_text"> <img alt="logo" src="<%=request.getContextPath()%>/resources/image/kakaotalk.png"> 카카오톡으로 로그인
							</span>
						</button>
					</a>

					<hr>

					<div class="row mt-3">
						<div class="col-sm-6" style="text-align: center;">
							<a class="small_text non_deco" href="${pageContext.request.contextPath}/member/passwordResetMember">비밀번호 재설정</a>
						</div>
						<div class="col-sm-6" style="text-align: center;">
							<a class="small_text non_deco" href="${pageContext.request.contextPath}/member/signupForm">회원가입</a>
						</div>
					</div>
				</form>
			</div>
			<!-- 고객 로그인 폼 end -->
			
			<!-- 사업자 로그인 폼 -->
			<div id="business-login" class="container tab-pane fade">
				<form action="${pageContext.request.contextPath}/member/buLoginPro" method="post">
					
					<input type="text" name="bu_email" class="form-control form-control-lg mt-3" placeholder="이메일" autocomplete="username"> 
					<input type="password" name="bu_password" class="form-control form-control-lg mt-1" placeholder="비밀번호" autocomplete="current-password"> 
					<input type="submit" class="default_btn rounded mt-3" value="사업자 로그인">
					
					<hr>

					<div class="row mt-3">
						<div class="col-sm-6" style="text-align: center;">
							<a class="small_text non_deco" href="${pageContext.request.contextPath}/member/passwordResetBusiness">비밀번호 재설정</a>
						</div>
						<div class="col-sm-6" style="text-align: center;">
							<a class="small_text non_deco" href="${pageContext.request.contextPath}/member/buSignupForm">사업자 회원가입</a>
						</div>
					</div>
				</form>
				<div style="margin : 100px 0 0 0;"></div>
			</div>
			<!-- 사업자 로그인 폼 end -->
		</div>
	</div>
	<div style="margin : 400px 0 0 0;"></div>
</body>
</html>