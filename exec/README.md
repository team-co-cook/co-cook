# 포팅 메뉴얼

# 1. 개요

![ezgif.com-video-to-gif-3.gif](porting-Manual/ezgif.com-video-to-gif-3.gif)

### 1-1. 프로젝트 사용 도구

- 이슈 관리 : JIRA
- 형상 관리 : GitLab
- 커뮤니케이션 : Notion, Mattermost
- 디자인 : Figma
- CI/CD : Jenkins

### 1-2. 개발환경

- IntelliJ : 2021.2.4 IU-212.5712.43
- JDK : opneJDK 11
- Visual Studio Code : 1.75.0
- React.js : 18.2.0
- Node.js : 18.15.0
- Python : 3.8.10
- SERVER : AWS EC2 Ubuntu 20.04.5 LTS
- DB : MySQL (AWS RDS)
- Flutter 3.8.0-17.0.pre.27 

### 1-3. 깃랩 제외된 정보

## Spring Boot

### 키정보

- jwt.secret=[JWT 시크릿 키]
- jwt.validity.in.seconds=[JWT 유지 시간]
- spring.datasource.username=[데이터베이스 유저 아이디]
- spring.datasource.password=[데이터베이스 유저 비밀번호]
- cloud.aws.credentials.accessKey=[AWS S3 사용 키]
- cloud.aws.credentials.secretKey=[AWS S3 사용 키]
- cloud.aws.s3.bucket=[AWS S3 버킷명]
- cloud.aws.region.static=[AWS 지역]
- spring.redis.host=[도커 Redis 주소]
- spring.redis.password=[redis.config 설정 비밀번호]
- spring.redis.port=[redis.config 설정 포트]


## 검색엔진

- [다운로드](https://fasttext.cc/docs/en/pretrained-vectors.html)

![Untitled](porting-Manual/Untitled.png)

- 저장 위치
    - 스프링부트 폴더 내 /S08P22B302/backend/src/main/resources/wiki.ko.bin 으로 저장

# 2. 빌드

## NGINX 설정

1. nginx 설치
    
    ```java
    sudo apt-get install nginx
    ```
    
2. nginx 시작
    
    ```java
    sudo service nginx start
    ```
    
3. fastapi 설정 파일 생성
    
    ```java
    server{
           server_name http://j8b302.p.ssafy.io:3000;
           location / {
               include proxy_params;
               proxy_pass http://127.0.0.1:8000;
           }
    }
    ```
    
    - 명령어 : sudo vim /etc/nginx/sites-available/fastapi.conf
4. React 설정 파일 생성
    
    ```java
    server{
        listen 80;
        server_name j8b302.p.ssafy.io;
    
        location / {
            proxy_pass http://127.0.0.1:5000/;
        }
    }
    ```
    
    - 명령어 sudo vim /etc/nginx/sites-available/react.conf
5. 심볼릭 링크로 연결시키기
    
    ### Fastapi
    
    - sudo ln -s /etc/nginx/sites-available/fastapi.conf /etc/nginx/sites-enable/fastapi.conf
    
    ### React
    
    - sudo ln -s /etc/nginx/sites-available/react.conf /etc/nginx/sites-enable/react.conf
6. nginx 재시작
    - sudo systemctl restart nginx
7. 포트 번호
    
    ### Fastapi : 3000
    
    ### React : 80
    

---

## Redis 설정

1. Redis 설치 (도커 이미지)
    
    ```java
    docker pull redis
    ```
    
2. Redis 폴더 생성
    
    ```java
    mkdir redis
    ```
    
    - 도커 컨테이너 속 폴더와 연결될 폴더
3. Redis 설정 파일 생성
    
    ```java
    port [사용할 포트 번호]
    bind [연결 허용 할 IP 주소]
    requirepass [설정할 비밀번호]
    ```
    
    - 명령어 : vim /redis/redis.conf
4. Redis 시작
    
    ```java
    docker run -v /redis:/data --name redis -d -p 6379:6379 redis redis-server /data/redis.conf
    ```
    
    - redis 폴더와 data 폴더 연결, 6379 포트로 연결

---

## Mobile 빌드

1. Flutter 설치
    - 개발환경에 맞춰서 flutter 설치
    
    <aside>
    💡 Flutter 3.8.0-17.0.pre.27 • channel master • [https://github.com/flutter/flutter.git](https://github.com/flutter/flutter.git)
    Framework • revision 275ab9c69b (2 weeks ago) • 2023-02-27 15:46:53 -0800
    Engine • revision 8857c39c96
    Tools • Dart 3.0.0 (build 3.0.0-277.0.dev) • DevTools 2.22.1
    
    </aside>
    
2. Visual Studio 설치
3. Android Studio, Xcode 설치
    - Xcode version - 14.2 이하
    - iOS version - 12 이상
    - Android emulator - pixel 5 API 29
4. Android 설정
    - 구글 로그인 설정
        - SHA-1 확인
            
            ```bash
            # android 디렉토리로 이동 후  실행
            ./gradlew signingReport
            ```
            
        - 구글 로그인 API에 SHA-1 등록 후  google-services.json 파일 다운로드
        - google-services.json 파일을 android-app 폴더로 이동
    - 빌드 설정
        - android 디렉토리에 keystore 디렉토리 생성
        - key.jks 파일을 keystore 디렉토리에 생성
            - [key.jks 파일 생성](https://flutter-ko.dev/docs/deployment/android#keystore-%EB%A7%8C%EB%93%A4%EA%B8%B0)
        - 생성된 key.jks의 비밀번호만 적힌 keystore.password 파일을 keystore 디렉토리에  생성
5. iOS 설정
    - Runner.xcworkspace 실행하여 xcode 실행
    - Signing & Capabilities > Team 설정
    - Bundle Identifier 설정
6. 필요한 패키지 다운로드
    
    ```bash
    flutter pub get
    ```
    
7.  Virtual Device를 실행
    
    ```bash
    # 설치된 Android emulator 또는 iOS simulator 실행
    flutter emulators --launch [emulator name]
    ```
    
8. App을 실행
    
    ```bash
    # 실행된 Virtual Device에 App 설치
    flutter run
    ```
    

---

## React 배포

1. 이전 빌드로인한 기록 지우기
    
    ```java
    git checkout -- README.md ai backend frontend mobile
    ```
    
    - 빌드하면서 나온 파일로 인한 conflict 해결을 위해 이전으로 되돌린다.
2. React 빌드
    
    ```java
    npm install
    npm run build
    ```
    
    - 관련 파일 다운로드
    - 빌드
    - 폴더 위치 : /S08P22B302/frontend/co-cook

### Dockerizing

1. 도커 빌드
    
    ```bash
    docker build -t front-build .
    ```
    
    - react 도커 이미지 생성
2. 동작중인 도커 실행 중지
    
    ```bash
    docker ps -f name=front-prod -q | xargs --no-run-if-empty docker container stop
    docker container ls -a -fname=front-prod -q | xargs -r docker container rm
    ```
    
    - 해당 이름으로 동작 중인 도커 컨테이너 실행 중지
    - 컨테이너 삭제
3. 새로 빌드한 도커로 실행
    
    ```bash
    docker run -d --name front-prod -p 5000:80 front-build
    ```
    
    - 5000번 포트로 react 시작

---

## Spring Boot 배포

1. 환경 변수 설정 및 검색엔진 넣기
    - private.properties 파일 생성
        - 폴더 위치 : /S08P22B302/backend/src/main/resources/private.properties
            
            ```java
            jwt.secret=[JWT 시크릿 키]
            jwt.validity.in.seconds=[JWT 유지 시간]
            spring.datasource.username=[데이터베이스 유저 아이디]
            spring.datasource.password=[데이터베이스 유저 비밀번호]
            cloud.aws.credentials.accessKey=[AWS S3 사용 키]
            cloud.aws.credentials.secretKey=[AWS S3 사용 키]
            cloud.aws.s3.bucket=[AWS S3 버킷명]
            cloud.aws.region.static=[AWS 지역]
            spring.redis.host=[도커 Redis 주소]
            spring.redis.password=[redis.config 설정 비밀번호]
            spring.redis.port=[redis.config 설정 포트]
            ```
            
    - 검색 엔진 다운로드
        - 폴더 위치 : /S08P22B302/backend/src/main/resources/wiki.ko.bin
2. JAR 파일 빌드 
    
    ```java
    chmod +x gradlew
    ./gradlew clean build
    ```
    
    - gradlew 권한 변경
    - 이전 기록 지우고 빌드 시작
    - 명령어 위치 : /S08P22B302/backend/

### Dockerizing

1. 도커 빌드
    
    ```java
    docker build -t spring-build .
    ```
    
    - 스프링을 도커 이미지 생성
2. 동작중인 도커 실행 중지
    
    ```java
    docker ps -f name=spring-prod -q | xargs --no-run-if-empty docker container stop
    docker container ls -a -fname=spring-prod -q | xargs -r docker container rm
    ```
    
    - 해당 이름으로 동작 중인 도커 컨테이너 실행 중지
    - 컨테이너 삭제
3. 새로 빌드한 도커로 실행
    
    ```java
    docker run -d --name spring-prod -p 8080:8080 spring-build 
    ```
    
    - 8080 포트로 스프링 시작

---

## Fastapi 배포

### Dockerizing

1. 도커 빌드
    
    ```java
    docker build -t fastapi-build .
    ```
    
    - fastapi 도커 이미지 생성
2. 동작중인 도커 실행 중지
    
    ```java
    docker ps -f name=fastapi-prod -q | xargs --no-run-if-empty docker container stop
    docker container ls -a -fname=fastapi-prod -q | xargs -r docker container rm
    ```
    
    - 해당 이름으로 동작 중인 도커 컨테이너 실행 중지
    - 컨테이너 삭제
3. 새로 빌드한 도커로 실행
    
    ```java
    docker run -d --name fastapi-prod -p 8000:8000 fastapi-build
    ```
    
    - 8000번 포트로 fastapi 시작
    - nginx 설정으로 인해 실행 포트는 8000번 접속 포트는 3000번

---