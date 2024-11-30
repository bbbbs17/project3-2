# Please - JSP 기반 브랜드 나의 옷장 관리 웹

이 프로젝트는 JSP를 이용해 사용자가 자신이 소유한 옷을 업로드하고 날짜별로 관리하는 웹입니다. MySQL을 데이터베이스로 사용하고, Apache Tomcat 서버에서 실행됩니다.

## 사용 기술
- **JSP** (JavaServer Pages)
- **Java** (Servlet, JDBC) - Java 21버전 이상을 사용합니다.
- **MySQL** (데이터베이스)
- **Apache Tomcat 10.1.28** (서버)
- **Maven** (프로젝트 빌드 도구)

## 설치 및 실행 방법

### 1. Apache Tomcat 설정
- Apache Tomcat 10.1.28을 설치합니다.
- `web.xml` 파일에서 서블릿 및 필터 설정을 확인하세요.
  - `FileUploadServlet`: 파일 업로드 처리를 위한 서블릿
  - `CharacterEncodingFilter`: UTF-8 인코딩을 위한 필터

### 2. MySQL 데이터베이스 설정
- **MySQL 서버**를 설치하고, 각자에 맞는 데이터베이스를 생성합니다.
- 데이터베이스 연결 정보를 각자 환경에 맞게 수정해야 합니다.
  - `DatabaseUtil.java` 파일에서 아래와 같은 설정을 변경합니다:
    - `JDBC_URL`: MySQL 데이터베이스의 URL (예: `jdbc:mysql://localhost:3306/bsTest`)
    - `USERNAME`: MySQL 접속 사용자명 (예: `root`)
    - `PASSWORD`: MySQL 접속 비밀번호 (예: `yourpassword`)
- 데이터베이스 연결에 필요한 **MySQL JDBC 드라이버**는 `pom.xml`에 이미 추가되어 있습니다.

### 3. Maven 빌드 및 배포
- `pom.xml` 파일을 통해 Maven을 사용하여 프로젝트를 빌드합니다.
  - `mvn clean install`: 프로젝트 빌드 및 WAR 파일 생성
- 빌드된 WAR 파일을 Tomcat 서버에 배포합니다.

### 4. 실행
- Tomcat 서버를 시작하고 웹 브라우저에서 `http://localhost:8080/please/`로 접속하여 웹 애플리케이션을 확인합니다.

## 주요 기능

### 1. 로그인
- 사용자는 `myOutfits.jsp`에서 달력을 통해 자신의 코디를 관리하고 볼 수 있습니다.

### 2. 브랜드 목록
- `createOutfit.jsp`에서는 기존의 옷을 조회하여 자신의 코디를 만들 수 있습니다.

### 3. 찜 목록
- `viewOutfits.jsp`에서는 저장한 코디를 관리하고, 빈 캔버스에 사진들을 드래그하여 배치하고 배치한 사진들을 저장할 수 있습니다.

## 라이센스
MIT 라이센스

## 설정 파일 설명

### 1. `DatabaseUtil.java`
- MySQL 데이터베이스에 연결하는 유틸리티 클래스입니다.
- `getConnection()` 메서드를 통해 데이터베이스 연결을 제공합니다.

### 2. `web.xml`
- `FileUploadServlet`과 `CharacterEncodingFilter` 설정을 포함하고 있습니다.
- `CharacterEncodingFilter`는 UTF-8 인코딩을 설정하여 다국어 지원을 합니다.

### 3. `pom.xml`
- MySQL JDBC 드라이버와 Jakarta Servlet API, JUnit 의존성을 포함하고 있습니다.
