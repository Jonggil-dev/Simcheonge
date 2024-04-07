```
프로젝트에서 사용할 개발 도구, 환경 설정, Convention등의 방법과 지침을 정합니다.
1. 개발 환경(IDE)
- 통합개발환경, 버전 관리(Git)의 설정과 Convention 에 대해 적습니다.
2. 개발 언어 및 프레임워크
- 개발 언어와 버전을 명시하고 필요한 경우 언어 벌전 관리 도구 혹은 사용 라이브러리 관련
Dependency를 적습니다.
3. 데이터베이스
- 프로젝트에서 사용할 데이터 베이스의 종류와 버전, 포트번호, 접속방법, 설정을 적습니다.
4. 테스팅 도구
- 단위 테스트, 통합테스트, 기능 테스트 등의 테스트 도구와 프레임워크 혹은 사용여부?
5. 빌드 및 배포 두구
- 빌드 도구(ex: Maven,Gradle, WebPack,Vite 등등)을 명시하고 빌드 스크립트의 설정 방법을
적습니다. 
6. 개발 가이드 라인
- 코드 스타일 가이드: BackEnd , FrontEnd 각각 사용 언어나 환경에 맞게 code Convention을
정하거나 ESLint 혹은 IDE 설정을 동일하게 공유합니다.
```

# 1. 빌드

# 버전 정보

## [Server]

- EC2: Ubuntu 20.04.6 LTS
- Nginx: v1.18.0
- Docker: v25.0.4

## [Project]

### Back

- Spring: v3.2.3

- Gradle: v8.5

- JDK: 17

- build.gradle

  ```
  plugins {
  	id 'java'
  	id 'org.springframework.boot' version '3.2.3'
  	id 'io.spring.dependency-management' version '1.1.4'
  }
  
  group = 'com.e102'
  version = '0.0.1-SNAPSHOT'
  
  java {
  	sourceCompatibility = 17
  }
  
  repositories {
  	mavenCentral()
  }
  
  dependencies {
  	implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
  	implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
  	implementation 'org.springframework.boot:spring-boot-starter-validation'
  	implementation 'org.springframework.boot:spring-boot-starter-web'
  
  	compileOnly 'org.projectlombok:lombok'
  	runtimeOnly 'org.mariadb.jdbc:mariadb-java-client:3.3.0'
  	annotationProcessor 'org.projectlombok:lombok'
  	testImplementation 'org.springframework.boot:spring-boot-starter-test'
  
  	//swagger
  	implementation 'org.springdoc:springdoc-openapi-starter-webmvc-ui:2.0.2'
  
  	// redis
  	implementation 'org.springframework.boot:spring-boot-starter-data-redis'
  
  	// Spring Security
  	implementation 'org.springframework.boot:spring-boot-starter-security'
  
  	// jwt
  	implementation 'io.jsonwebtoken:jjwt-api:0.11.5'
  	runtimeOnly 'io.jsonwebtoken:jjwt-impl:0.11.5'
  	runtimeOnly 'io.jsonwebtoken:jjwt-jackson:0.11.5'
  	//QueryDSL 추가
  	implementation 'com.querydsl:querydsl-jpa:5.0.0:jakarta'
  	implementation 'com.querydsl:querydsl-core:5.0.0'
  	implementation 'com.querydsl:querydsl-sql:5.0.0'
  	annotationProcessor "com.querydsl:querydsl-apt:5.0.0:jakarta"
  	annotationProcessor "jakarta.annotation:jakarta.annotation-api"
  	annotationProcessor "jakarta.persistence:jakarta.persistence-api:3.1.0"
  
  	//오픈 api 응답 파싱
  	implementation 'jakarta.xml.bind:jakarta.xml.bind-api:3.0.1'
  	runtimeOnly 'org.glassfish.jaxb:jaxb-runtime:4.0.4'
  
  	//경제용어 zip, csv 데이터 파일 처리
  	implementation 'org.apache.commons:commons-compress:1.20'
  	implementation 'org.apache.commons:commons-csv:1.8'
  
  	//네이버 뉴스 크롤링
  	implementation 'org.jsoup:jsoup:1.13.1' //정적 크롤링
  //	implementation 'org.seleniumhq.selenium:selenium-java:3.141.59' //동적 크롤링
  
  	//jackson
  	implementation 'com.fasterxml.jackson.core:jackson-databind:2.16.1'
  	implementation 'com.fasterxml.jackson.core:jackson-core:2.16.1'
  	implementation 'com.fasterxml.jackson.core:jackson-annotations:2.16.1'
  
  }
  
  tasks.named('test') {
  	useJUnitPlatform()
  }
  
  // QueryDsl 빌드 옵션 (선택)
  def querydslDir = "$buildDir/generated/querydsl"
  
  sourceSets {
  	main.java.srcDirs += [ querydslDir ]
  }
  
  tasks.withType(JavaCompile) {
  	options.annotationProcessorGeneratedSourcesDirectory = file(querydslDir)
  }
  
  clean.doLast {
  	file(querydslDir).deleteDir()
  }
  ```

### Front - React

- Node.js: v20.11.0

- NPM: v10.2.4

- React: v18.2.0

- package.json

  ```
  {
    "name": "simcheonge_admin",
    "version": "0.1.0",
    "private": true,
    "dependencies": {
      "@testing-library/jest-dom": "^5.17.0",
      "@testing-library/react": "^13.4.0",
      "@testing-library/user-event": "^13.5.0",
      "axios": "^1.6.8",
      "bootstrap": "^5.3.3",
      "http-proxy-middleware": "^2.0.6",
      "react": "^18.2.0",
      "react-bootstrap": "^2.10.2",
      "react-dom": "^18.2.0",
      "react-router-dom": "^6.22.3",
      "react-scripts": "5.0.1",
      "web-vitals": "^2.1.4"
    },
    "scripts": {
      "start": "react-scripts start",
      "build": "react-scripts build",
      "test": "react-scripts test",
      "eject": "react-scripts eject"
    },
    "eslintConfig": {
      "extends": [
        "react-app",
        "react-app/jest"
      ]
    },
    "browserslist": {
      "production": [
        ">0.2%",
        "not dead",
        "not op_mini all"
      ],
      "development": [
        "last 1 chrome version",
        "last 1 firefox version",
        "last 1 safari version"
      ]
    }
  }
  ```

### Front - Flutter

- Flutter: v3.19.3

- Dart: v3.3.1

- pubspec.yaml

  ```
  dependencies:
    flutter_native_splash: ^2.3.13
    flutter:
      sdk: flutter
  
    http: ^1.2.1
  
    # The following adds the Cupertino Icons font to your application.
    # Use with the CupertinoIcons class for iOS style icons.
    cupertino_icons: ^1.0.6
    url_launcher: ^6.2.5
    shared_preferences: ^2.2.2
    flutter_launcher_icons: ^0.13.1
    font_awesome_flutter: ^10.7.0
    line_icons: ^2.0.3
    carousel_slider: ^4.2.1
    smooth_page_indicator: ^1.1.0
    dropdown_button2: ^2.3.9
    intl: ^0.18.0
    syncfusion_flutter_datepicker: ^25.1.35
    f_datetimerangepicker: ^0.2.0
    flutter_localization: ^0.2.0
    pull_to_refresh: ^2.0.0
    provider: ^6.1.2
    speech_to_text: ^6.6.1
    google_fonts: ^6.2.1
    word_break_text: ^0.1.0
  ```

### AI

- python: 3.10.10

- requirements.txt

  ```
  accelerate==0.27.2
  aiohttp==3.9.3
  aiosignal==1.3.1
  altair==5.2.0
  annotated-types==0.6.0
  anyio==4.3.0
  asttokens==2.4.1
  attrs==23.2.0
  audioread==3.0.1
  beautifulsoup4==4.12.3
  bitsandbytes==0.43.0
  blinker==1.7.0
  cachetools==5.3.2
  certifi==2024.2.2
  cffi==1.16.0
  charset-normalizer==3.3.2
  click==8.1.7
  colorama==0.4.6
  comm==0.2.1
  contourpy==1.2.0
  cycler==0.12.1
  datasets==2.18.0
  debugpy==1.8.0
  decorator==5.1.1
  dill==0.3.8
  docstring_parser==0.16
  elementpath==4.3.0
  executing==2.0.1
  fastapi==0.110.0
  fastjsonschema==2.19.1
  filelock==3.13.1
  fonttools==4.47.2
  frozenlist==1.4.1
  fsspec==2024.2.0
  gitdb==4.0.11
  GitPython==3.1.42
  h11==0.14.0
  huggingface-hub==0.20.3
  idna==3.6
  importlib-metadata==7.0.1
  ipykernel==6.29.0
  ipython==8.21.0
  itsdangerous==2.1.2
  jedi==0.19.1
  Jinja2==3.1.3
  joblib==1.3.2
  jsonschema==4.21.1
  jsonschema-specifications==2023.12.1
  kiwisolver==1.4.5
  lazy_loader==0.3
  librosa==0.10.1
  llvmlite==0.42.0
  lxml==5.1.0
  markdown-it-py==3.0.0
  matplotlib==3.8.2
  matplotlib-inline==0.1.6
  mdurl==0.1.2
  mpmath==1.3.0
  msgpack==1.0.7
  multidict==6.0.5
  multiprocess==0.70.16
  nbformat==5.9.2
  nest-asyncio==1.6.0
  networkx==3.2.1
  numba==0.59.0
  numpy==1.26.3
  packaging==23.2
  pandas==2.2.0
  parso==0.8.3
  peft==0.10.0
  pillow==10.2.0
  platformdirs==4.2.0
  plotly==5.19.0
  pooch==1.8.0
  prompt-toolkit==3.0.43
  protobuf==4.25.3
  psutil==5.9.8
  pure-eval==0.2.2
  pyarrow==15.0.0
  pyarrow-hotfix==0.6
  pycparser==2.21
  pydantic==2.6.4
  pydantic_core==2.16.3
  pydeck==0.8.1b0
  Pygments==2.17.2
  pyparsing==3.1.1
  python-dateutil==2.8.2
  python-multipart==0.0.9
  pytz==2024.1
  PyYAML==6.0.1
  pyzmq==25.1.2
  referencing==0.33.0
  regex==2023.12.25
  requests==2.31.0
  requests-file==2.0.0
  rich==13.7.0
  rpds-py==0.18.0
  safetensors==0.4.2
  scikit-learn==1.4.0
  scipy==1.12.0
  sentencepiece==0.2.0
  setuptools==69.0.3
  shtab==1.7.1
  six==1.16.0
  smmap==5.0.1
  sniffio==1.3.1
  soundfile==0.12.1
  soupsieve==2.5
  soxr==0.3.7
  stack-data==0.6.3
  starlette==0.36.3
  streamlit==1.31.1
  sympy==1.12
  tenacity==8.2.3
  threadpoolctl==3.2.0
  tokenizers==0.15.2
  toml==0.10.2
  toolz==0.12.1
  torch==2.2.1
  tornado==6.4
  traitlets==5.14.1
  transformers==4.38.2
  trl==0.8.1
  typing_extensions==4.9.0
  tyro==0.7.3
  tzdata==2024.1
  tzlocal==5.2
  urllib3==2.2.0
  uvicorn==0.29.0
  validators==0.22.0
  wcwidth==0.2.13
  yarl==1.9.4
  zipp==3.17.0
  ```

## [DB]

- MariaDB: v11.3.2
- Redis: v7.2.4

## [IDE]

- IntelliJ: v2023.3.2
- Visual Studio Code: v1.85.1

## 1. 환경변수 형태

- env

  - back

    /src/resources/application-prod.properties

    ```
    # Spring Server-Port
    server.port=
    
    # SQL 스키마 초기화 방식 설정
    spring.sql.init.mode=
    
    # MariaDB Connect
    SPRING_DATASOURCE_URL=
    SPRING_DATASOURCE_USERNAME=
    SPRING_DATASOURCE_PASSWORD=
    
    # Redis Connect
    SPRING_REDIS_URL=
    SPRING_REDIS_PASSWORD=
    
    # 온통 청년 API Key
    OPENAPIVLAK=
    
    # 경제용어 다운로드 파일 임시 저장경로(디렉토리 경로)
    file.download.outputPath=
    
    # Jwt Token Secret-Key
    com.e102.simcheonge-server.secret-key=
    
    # 네이버 뉴스 API URL, 크롤링 URL
    naver.api.url=
    naver.crawler.url=
    
    # Chatgpt API key
    openai.secret-key=
    
    # GPU Server Connect
    CHATBOT_SERVER_URI=
    ```

    /src/resources/application.properties

    ```
    # JPA 설정
    spring.jpa.database=mysql
    spring.jpa.hibernate.ddl-auto=none
    spring.jpa.show-sql=true
    spring.jpa.defer-datasource-initialization=true
    spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
    
    # MariaDB Connect
    spring.datasource.url=${SPRING_DATASOURCE_URL}
    spring.datasource.driver-class-name=org.mariadb.jdbc.Driver
    spring.datasource.username=${SPRING_DATASOURCE_USERNAME}
    spring.datasource.password=${SPRING_DATASOURCE_PASSWORD}
    
    # sql 파일 설정
    spring.sql.init.schema-locations=classpath:schema.sql
    logging.level.org.hibernate.transaction=DEBUG
    
    #  Jackson 직렬화 설정
    spring.jackson.serialization.fail-on-empty-beans=false
    
    # Profile.Properties 설정
    # prod, local properties은 -Dspring.profiles.active 옵션으로 관리
    spring.profiles.include =
    
    # Redis Connect
    spring.data.redis.host=${SPRING_REDIS_URL}
    spring.data.redis.port=
    spring.data.redis.password=${SPRING_REDIS_PASSWORD}
    
    # Spring console log colors
    spring.output.ansi.enabled=always
    
    # API 요청시 접두사 반영 
    server.servlet.context-path=/api
    
    # GPU Server Connect
    chatbot.server.uri=${CHATBOT_SERVER_URI}
    ```

  - front

    리액트 /.env

    ```
    REACT_APP_API_URL={{요청 서버 도메인}}
    ```

## 2. 빌드 및 배포(Jenkins pipeline)

### 1) Front - React

### Env 파일 준비

```groovy
 stage('React Env Prepare') {
        when {
            expression { env.BUILD_ADMIN == "true" }
        }
        steps {

            withCredentials([
                file(credentialsId: 'React_Env', variable: 'ENV_CONFIG')
                ]) {

            script{
                // Jenkins가 EC2 내에서 특정 디렉토리를 수정할 수 있도록 권한 변경
                sh 'chmod -R 755 simcheonge_admin/'

                // Secret File Credential을 사용하여 설정 파일을 React 프로젝트의 simcheonge_admin 디렉토리로 복사
                sh 'cp "${ENV_CONFIG}" simcheonge_admin/.env'
            }
        }   
    }
}
```

### 소스 코드 빌드

```groovy
stage('Build React for Admin ') {
		    when {
		        expression { env.BUILD_ADMIN == "true" }
		    }
		    steps {
		        script {
		            dir('simcheonge_admin') {
		                // EC2에 node.js가 설치되어 있지 않아 npm을 사용할 수 없음
		                // 그래서 node 이미지를 기반으로 한 임시 컨테이너에서 npm build 작업을 수행함
		                // stage가 끝나면 컨테이너는 자동으로 삭제됨 (stage가 끝나도 이미지는 로컬(여기서는 EC2)에 남아있음)
		                // 로컬(EC2)에 이미지가 없으면 자동으로 docker hub에서 다운받아서 작업을 수행함
		                docker.image('node:20.10.0').inside {
		                
		                // Node.js를 사용하여 React 프로젝트 빌드
		                sh "rm -rf node_modules package-lock.json"
		                sh "npm install"
		                sh "CI=false npm run build"
		            }
		          }
		        }
		    }
		}
```

### 빌드 파일 EC2 업로드

```groovy
stage('Upload React to EC2 ') {
		     when {
		        expression { env.BUILD_ADMIN == "true" }
		    }
		    
		    steps {
		        script {
		        dir('simcheonge_admin') {
		            // 클라이언트 다운로드 용 React build 파일 복사
		            sh "cp -rf build/ /var/www/react/"
		            }
		        }
		    }
		}
```

### 2) Front - Flutter

### 소스 코드 빌드

```groovy
stage('Build APK for Andrioid  ') {
        when {
            expression { env.BUILD_FE == "true" }
        }
        steps {

            script {
                dir('simcheonge_front') {

            
                /*
                jenkins 컨테이너 내부에서 flutter 명령어를 사용하지 못함.
                jenkins 컨테이너 실행할 때 flutter 관련 볼륨마운트 했던
                /var/flutter/bin/flutter 파일을 명시적으로 작성해서 flutter 명령어 사용 
                */
                
                // Flutter 종속성 가져오기
                sh '/var/flutter/bin/flutter pub get'
                // APK 빌드
                sh '/var/flutter/bin/flutter build apk'
            	}
            }
        }
   }
```

### 빌드 파일 EC2 업로드

```groovy
 stage('Upload APK to EC2 ') {
         when {
            expression { env.BUILD_FE == "true" }
        }
        
        steps {
            script {
            dir('simcheonge_front') {
                // 버전 정보 추출
                // pubspec.yaml 파일에 version 이라는 단어가 많아서 8번째에 해당하는게 버전이라 그 부분만 추출하는 코드
                def version = sh(script: "grep version pubspec.yaml | head -n 8 | tail -n 1 | awk '{print \\$2}'", returnStdout: true).trim()

                // 클라이언트 다운로드 용 APK 파일 복사
                sh "cp -f build/app/outputs/flutter-apk/app-release.apk /home/ubuntu/apk_files/deploy/simcheonge.apk"
                
                // 버전 관리 용 APK 파일 복사 (저장용)
                sh "cp build/app/outputs/flutter-apk/app-release.apk /home/ubuntu/apk_files/stores/simcheonge-${version}.apk"
                }
            }
        }
    }
```

### 3) Back-spring

### profile.properties 준비

```groovy
stage('Spring Env Prepare') {
        when {
            expression { env.BUILD_BE == "true" }
        }
        steps {

            withCredentials([
                file(credentialsId: 'Spring_Prod', variable: 'PROD_PROPERTIES'),
                file(credentialsId: 'Spring_Secret', variable: 'SECRET_PROPERTIES')
                ]) {

            script{
                // Jenkins가 EC2 내에서 특정 디렉토리를 수정할 수 있도록 권한 변경
                sh 'chmod -R 755 simcheonge_server/src/main/resources/'

                // Secret File Credential을 사용하여 설정 파일을 Spring 프로젝트의 resources 디렉토리로 복사
                sh 'cp "${PROD_PROPERTIES}" simcheonge_server/src/main/resources/application-prod.properties'
                sh 'cp "${SECRET_PROPERTIES}" simcheonge_server/src/main/resources/application-secret.properties'

            }
        }   
    }
}
```

### 소스 코드 빌드

```groovy
 stage('Build Spring Code') {
        when {
            expression { env.BUILD_BE == "true" }
        }
        steps {
            script {
                dir('simcheonge_server') {
                    // Gradle을 사용하여 Spring 애플리케이션 빌드
                    sh 'chmod +x ./gradlew' // 실행 권한 추가
                    sh './gradlew build'
                    echo "Spring Build finished"
                }
            }
        }
    }
```

### Spring Docker Image 빌드

```groovy
stage('Build Spring Image ') {
      when {
            expression { env.BUILD_BE == "true" }
        }
        steps {
            // Docker 이미지 빌드
            script {
                dir('simcheonge_server') { 
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }
    }
```

### Spring Docker Container 실행

```jsx
stage('Run Spring Container') {
        when {
            expression { env.BUILD_BE == "true" }
        }
        steps {
            // Docker 컨테이너 실행
            script {

                // 실행중인 spring 컨테이너가 있으면 종료하고 삭제
                sh 'docker stop spring || true'
                sh 'docker rm spring || true'
                sh "docker run -d -p 8090:8090 --name spring ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }
```

## 3. 배포하기

### NGINX 설정

```
                                                                                                                                                                                                                                                                                            # /etc/nginx/sites-available/default

server {
    if ($host = {도메인}) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

        listen 80 default_server;
        listen [::]:80 default_server;

        server_name {도메인};

        return 404; # managed by Certbot

}

server {

        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;

        server_name {도메인}; # managed by Certbot

        root /var/www/react/build; # react build file directory(simcheonge admin page)

        index index.html index.htm index.nginx-debian.html;

        ssl_certificate /etc/letsencrypt/live/{도메인}/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/{도메인}/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

        location / {

                try_files $uri $uri/ /index.html;

        }

        location /api {

                proxy_pass <http://localhost:8090>;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;

        }

        location /simcheonge {
                alias /home/ubuntu/apk_files/deploy/;
                try_files /simcheonge.apk =404;
                add_header Content-Disposition 'attachment; filename="simcheonge.apk"';
        }

}

server {

        listen 8070 ssl default_server;

        server_name {도메인};

        ssl_certificate /etc/letsencrypt/live/{도메인}/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/{도메인}/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

        location / {

            proxy_pass <http://localhost:8080>;
            proxy_set_header Host $host:$server_port;
            proxy_set_header X-Forwarded-Host $host:$server_port;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

        }

}
```

### MariaDB 배포

- **MariaDB의 경우 별도 커스텀 할 게 없으므로 공식 이미지 사용**

```bash
# EC2 인스턴스 ssh 연결
$ ssh -i pem.key 도메인

# Redis 컨테이너 실행
$ docker run -d --name mariadb \\
-v mariadb_volume:/var/lib/mysql \\
-e TZ=Asia/Seoul \\
-e MYSQL_ROOT_PASSWORD=my-secret-pw \\
-p 3306:3306 mariadb:latest
```

### Redis 배포

- **Redis 의 경우 별도 커스텀 할 게 없으므로 공식 이미지 사용**

```bash
# EC2 인스턴스 ssh 연결
$ ssh -i pem.key 도메인

# Redis 컨테이너 실행
$ docker run -d --name redis \\
-p 6379:6379 \\
-v redis-data:/data \\
redis:latest \\
redis-server --requirepass "yourpassword" --appendonly yes
```

## 4. 외부 서비스

- ChatGPT API (gpt-3.5-turbo 사용)
- Naver News (https://news.naver.com/) 크롤링
- 온통 청년 API (https://jobyoung.work.go.kr/opi/openApiIntro.do)
- 기획재정부_시사경제용어 정보 (https://www.data.go.kr/data/15006052/fileData.do)
- GPU Server
  - 사용 GPU (NVIDIA L40S)
  - CUDA version 12.2

## 5. DB 덤프 파일

- 스키마 생성 및 카테고리 데이터 추가

```sql
DROP TABLE IF EXISTS `economic_word`;
DROP TABLE IF EXISTS `comment`;
DROP TABLE IF EXISTS `post_category`;
DROP TABLE IF EXISTS `bookmark`;
DROP TABLE IF EXISTS `post`;
DROP TABLE IF EXISTS `policy`;
DROP TABLE IF EXISTS `category`;
DROP TABLE IF EXISTS `category_detail`;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `policy_category_detail`;

CREATE TABLE `user`
(
    `user_id`       INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_login_id` VARCHAR(16) NOT NULL,
    `user_password` VARCHAR(255) NOT NULL COMMENT 'bcrypt',
    `user_nickname` VARCHAR(33) NOT NULL,
    `created_at`    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted`    BIT         NOT NULL DEFAULT FALSE,
    `deleted_at`    DATETIME NULL DEFAULT NULL
);

CREATE TABLE `economic_word`
(
    `economic_word_id`          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `economic_word`             VARCHAR(255) NOT NULL,
    `economic_word_description` TEXT         NOT NULL
);

CREATE TABLE `bookmark`
(
    `bookmark_id`   INT     NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id`       INT     NOT NULL DEFAULT 0,
    `referenced_id` INT     NOT NULL DEFAULT 0,
    `bookmark_type` CHAR(3) NOT NULL COMMENT 'POS: 게시글, POL: 정책'
);

CREATE TABLE `post`
(
    `post_id`      INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id`      INT           NOT NULL DEFAULT 0,
    `post_name`    VARCHAR(400)  NOT NULL,
    `post_content` VARCHAR(6000) NOT NULL,
    `created_at`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted`   BIT           NOT NULL DEFAULT FALSE,
    `deleted_at`   DATETIME NULL DEFAULT NULL
);

CREATE TABLE `policy`
(
    `policy_id`                             INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `policy_code`                           VARCHAR(16) NOT NULL COMMENT 'API의 정책 ID',
    `policy_area`                           VARCHAR(21) NOT NULL COMMENT '🔑 API의 정책일련번호',
    `policy_name`                           TEXT        NOT NULL COMMENT 'API의 정책명',
    `policy_intro`                          TEXT NULL DEFAULT NULL COMMENT 'API의 정책소개',
    `policy_support_content`                TEXT NULL DEFAULT NULL COMMENT 'API의 지원내용',
    `policy_support_scale`                  TEXT NULL DEFAULT NULL COMMENT 'API의 지원규모',
    `policy_etc`                            TEXT NULL DEFAULT NULL COMMENT 'API의 기타사항',
    `policy_field`                          VARCHAR(21) NOT NULL COMMENT '🔑 API의 정책분야코드(관심분야)',
    `policy_business_period`                TEXT NULL DEFAULT NULL COMMENT 'API의 사업운영기간내용',
    `policy_period_type_code`               VARCHAR(21) NOT NULL COMMENT '🔑 API의 산업신청기간반복구분코드',
    `policy_start_date`                     DATE NULL COMMENT 'policy_business_period 가공',
    `policy_end_date`                       DATE NULL COMMENT 'policy_business_period 가공',
    `policy_age_info`                       VARCHAR(40) NULL COMMENT '"만 OO세 ~ OO세" 로 통일',
    `policy_major_requirements`             TEXT NULL COMMENT 'API의 전공요건내용',
    `policy_employment_status`              VARCHAR(31) NOT NULL COMMENT '🔑 API의 취업상태내용',
    `policy_specialized_field`              VARCHAR(31) NOT NULL COMMENT '🔑 API의 특화분야내용',
    `policy_education_requirements`         VARCHAR(31) NOT NULL COMMENT '🔑 API의 학력요건내용',
    `policy_residence_income`               TEXT NULL DEFAULT NULL COMMENT 'API의 거주지및소득조건내용',
    `policy_additional_clues`               TEXT NULL DEFAULT NULL COMMENT 'API의 추가단서사항내용',
    `policy_entry_limit`                    TEXT NULL DEFAULT NULL COMMENT 'API의 참여제한대상내용',
    `policy_application_procedure`          TEXT NULL DEFAULT NULL COMMENT 'API의 신청절차내용',
    `policy_required_documents`             TEXT NULL DEFAULT NULL COMMENT 'API의 제출서류내용',
    `policy_evaluation_content`             TEXT NULL DEFAULT NULL COMMENT 'API의 심사발표내용',
    `policy_site_address`                   VARCHAR(1000) NULL DEFAULT NULL COMMENT 'API의 신청사이트주소',
    `policy_main_organization`              TEXT NULL DEFAULT NULL COMMENT 'API의 주관부처명',
    `policy_main_contact`                   TEXT NULL DEFAULT NULL COMMENT 'API의 주관부처담당자연락처',
    `policy_operation_organization`         TEXT NULL DEFAULT NULL COMMENT 'API의 운영기관명',
    `policy_operation_organization_contact` TEXT NULL DEFAULT NULL COMMENT 'API의 운영기관담당자연락처',
    `policy_application_period`             TEXT NULL DEFAULT NULL COMMENT 'API의 사업신청기간-관리자가 startDate, endDate로 분리',
    `policy_is_processed`                   BIT         NOT NULL COMMENT '원본 데이터 가공 여부',
    `policy_processed_at`                   DATETIME NULL COMMENT '원본 데이터 가공 일자',
    `policy_created_at`                     DATETIME    NOT NULL DEFAULT (CURRENT_DATE) COMMENT '원본 데이터 반입 일자'
);

CREATE INDEX idx_policy_code ON policy(policy_code);

CREATE TABLE `comment`
(
    `comment_id`      INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id`         INT           NOT NULL,
    `referenced_id`   INT           NOT NULL,
    `comment_type`    CHAR(3)       NOT NULL COMMENT 'POL: 정책, POS: 게시글',
    `comment_content` VARCHAR(1200) NOT NULL,
    `created_at`      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted`      BIT           NOT NULL DEFAULT FALSE,
    `deleted_at`      DATETIME NULL DEFAULT NULL
);

CREATE TABLE `category`
(
    `category_code` VARCHAR(21) NOT NULL PRIMARY KEY COMMENT '코드',
    `category_name` VARCHAR(21) NOT NULL COMMENT '분류명'
);

CREATE TABLE `category_detail`
(
    `category_code`   VARCHAR(21)  NOT NULL COMMENT '코드',
    `category_number` INT          NOT NULL COMMENT '번호',
    `category_name`   VARCHAR(100) NOT NULL COMMENT '카테고리명',
    PRIMARY KEY (`category_code`, `category_number`)
);

CREATE TABLE `post_category`
(
    `category_code`   VARCHAR(21) NOT NULL COMMENT '코드',
    `category_number` INT         NOT NULL COMMENT '번호',
    `post_id`         INT         NOT NULL DEFAULT 0,
    PRIMARY KEY (`post_id`, `category_number`, `category_code`)
);

CREATE TABLE `policy_category_detail`
(
    `category_code`   VARCHAR(21) NOT NULL COMMENT '코드',
    `category_number` INT     NOT NULL COMMENT '번호',
    `policy_id`       INT         NOT NULL,
    PRIMARY KEY (`category_code`, `category_number`, `policy_id`)
);

INSERT INTO category (category_code, category_name)
VALUES ('RGO', '지역');
INSERT INTO category (category_code, category_name)
VALUES ('ADM', '학력');
INSERT INTO category (category_code, category_name)
VALUES ('EPM', '취업 상태');
INSERT INTO category (category_code, category_name)
VALUES ('SPC', '특화 분야');
INSERT INTO category (category_code, category_name)
VALUES ('PFD', '관심 분야');
INSERT INTO category (category_code, category_name)
VALUES ('APC', '신청 기간');
INSERT INTO category (category_code, category_name)
VALUES ('POS', '게시판');

-- 취업 상태
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('EPM', 1, '제한 없음');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('EPM', 2, '재직자');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('EPM', 3, '개인 사업자');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('EPM', 4, '미취업자');

-- 학력
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 1, '제한 없음');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 2, '고졸 이하');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 3, '대학 재학');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 4, '대졸 예정');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 5, '대학 졸업');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('ADM', 6, '석/박사');

-- 특화 분야
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 1, '제한 없음');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 2, '여성');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 3, '장애인');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 4, '군인');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 5, '중소기업');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 6, '저소득층');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 7, '농업인');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 8, '지역인재');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('SPC', 9, '기타');

-- 관심 분야
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23010, '일자리');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23020, '주거');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23030, '교육');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23040, '복지,문화');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('PFD', 23050, '참여,권리');

-- 지역
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3001, '중앙부처');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002001, '서울');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002002, '부산');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002003, '대구');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002004, '인천');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002005, '광주');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002006, '대전');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002007, '울산');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002008, '경기');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002009, '강원');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002010, '충북');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002011, '충남');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002012, '전북');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002013, '전남');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002014, '경북');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002015, '경남');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002016, '제주');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('RGO', 3002017, '세종');

-- 신청 구분
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('APC', 1, '상시');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('APC', 2, '미정');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('APC', 3, '기간 선택');

-- 게시판
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 1, '전체');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 2, '정책 추천');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 3, '공모전');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 4, '생활 꿀팁');
INSERT INTO category_detail (category_code, category_number, category_name)
VALUES ('POS', 5, '기타');
```