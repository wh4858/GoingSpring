# 🎒숙박플랫폼 GOING

Java와 Spring MVC를 기반으로 제작한 프로젝트입니다.

기존 Model2로 만든 세미 프로젝트를 스프링 형태로 바꾼 뒤 개선작업과 추가 기능을 삽입했습니다.

고객과 사업자(숙소), 관리자 파트로 기능을 나누어 플랫폼 형태의 서비스를 구축했습니다.



프로젝트 제작 기간 : 2022.04.21 ~ 2022.05.13

[GoingSpring PDF파일](GOING%20-%20SPRING%2065d55764fa834e57b754e36919143cd1/GoingSpring.pdf)

# ⚡️ 프로젝트 구성 및 설계


### 📙  Site Map

![사이트맵 (2).png](GOING%20-%20SPRING%2065d55764fa834e57b754e36919143cd1/sitemap.png)

### 📙  Database ERD

![GOING (3).png](GOING%20-%20SPRING%2065d55764fa834e57b754e36919143cd1/GOING_(3).png)

사진을 저장하는 BUSINESS(사업자)와 ROOM(객실) 테이블은 동일하고 중복되지 않는 시퀀스(pic_num)를 공유해 사진의 위치를 저장하도록 했습니다.   

### 📙  사용 기술

**백앤드**

- Java 11
- Spring MVC
- Spring AOP
- Spring Security
- JUnit4
- MyBatis

**DB & WAS**

- Oracle
- Oracle Cloud
- Tomcat 9

**프론트**

- HTML/CSS
- JavaScript
- Bootstrap 5
- JQuery

**Environment & Tool**

- Mac, Windows 10
- Eclipse
- VSCode
- GitHub
- SQL Developer

# ⚡️ 프로젝트 키워드


### 📙  JUnit을 이용한 단위 테스트

### 📙  AOP를 이용한 Logging

### 📙  Interceptor를 이용한 고객, 사업자, 관리자 페이지분리

### 📙  리팩토링

### 📙  Spring Security를 이용한 비밀번호 암호화


# ⚡️ 프로젝트 주요 기능

### 📙  로그인 및 회원가입

### 📙  숙소 검색

### 📙  사업자 페이지

### 📙  숙소 찜하기

### 📙  결제 및 예약

### 📙  리뷰

### 📙  관리자 모드


