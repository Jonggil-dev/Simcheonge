# 🚀 심청이 프로젝트

### 1. 프로젝트 기간

- 2024.02.19(월) ~ 2024.04.05(금)

### 2. 팀원 소개

- 김지수 : 팀장, 프론트엔드, 디자인, 위젯 개발(유저 정보 관리, 커뮤니티 등)
- 서준하 : 프론트엔드, 디자인,  위젯 개발(챗봇, 정책, 뉴스 등)
- 김민진 : 백엔드, 커뮤니티 기능, 북마크 기능
- 박다민 : 백엔드, ERD 설계, 챗봇 개발(생성형 AI) 
- 정종길 : 백엔드, 인프라(CI/CD), Spring Security(+ JJWT), 뉴스 크롤링
- 주혜련 : 백엔드, ERD 설계, 정책 서비스(검색/필터 등), 관리자 페이지 구현



# 🔍 프로젝트 소개

### 1. 서비스 요약

- "심"플하게 "청"년들이 "이"득을 챙길 수 있도록, 정책과 금융 정보를 제공하는 모바일 어플리케이션 

### 2. 기획 의도

- 많은 청년들의 정책의 존재를 알지 못하거나, 본인이 대상이 되는지를 모르는 경우가 많음
- 스마트폰을 통해 청년 정책을 한 눈에 확인하기 쉽게 제공하여 어플리케이션 접근성을 향상

### 3. 기술스택 및 개발 환경

![기술스택 및 개발환경](https://github.com/Jonggil-dev/Simcheonge/assets/155353613/1e663e32-b794-4910-8b34-186ea922fd9d)



# **💡 주요 기능**

### 1. 챗봇을 이용한 정책 정보 검색

- 생성형 AI로 구현한 챗봇을 통해 쉽게 청년 정책 관련 질의응답 지원
- STT지원으로 편리성 증대

### 2. 검색 필터를 이용한 정책 검색

- 키워드 입력을 통한 정책 검색 가능
- 추가 지역/학력/취업 상태 등 필터를 통해 조건별 정책 검색 가능
- STT지원으로 편리성 증대

### 3. 정책 정보 관리 시스템 구축

- Spring Scheduler를 이용해 새로운 정책 데이터를 주기적으로 저장/제공
- 관리자 페이지를 통해 정책을 가공할 수 있는 시스템 구축

### 4. 오늘의 뉴스 요약

- 정치/경제/금융/IT 카테고리 네이버 헤드라인 뉴스를 ChatGPT로 요약하여 제공

### 5. 경제 용어 소개

- 새로고침 시 기본적인 경제 관련 용어와 설명을 랜덤으로 출력



# 📺 심청이 어플리케이션 화면

### 1. 메인 화면
![Readme 메인화면](https://github.com/Jonggil-dev/Simcheonge/assets/155353613/6cae248e-0a8b-42bd-81b6-b28a60ddb098)

### 2. 챗봇

![Readme챗봇](https://github.com/Jonggil-dev/Simcheonge/assets/155353613/dbd7357e-cd5d-4665-9de7-08991c1e8b7a)

### 3. 정책 검색/조회

![Readme정책검색](https://github.com/Jonggil-dev/Simcheonge/assets/155353613/58306a00-07f3-4a86-a46b-64524156b671)

### 4. 커뮤니티

![Readme커뮤니티](https://github.com/Jonggil-dev/Simcheonge/assets/155353613/e1b1ddf9-ac1b-4ed5-b657-8e24afe6af85)

### 5. 경제 용어

![Readme경제용어](https://github.com/Jonggil-dev/Simcheonge/assets/155353613/21ca7fd0-ec04-4d5a-9cfd-f815d64da3cd)

### 6. 뉴스

![Readme뉴스](https://github.com/Jonggil-dev/Simcheonge/assets/155353613/8e509beb-2ee0-44cb-a3d6-3ce2f19763b0)

# 🔧 설계

### 1. 아키텍처 설계

![9to6_architecture2](https://github.com/Jonggil-dev/Simcheonge/assets/155353613/f0939a60-2dd3-4a74-a55e-ba00dd236529)

### 2. DB 설계(ERD)

![ERD](https://github.com/Jonggil-dev/Simcheonge/assets/155353613/aceaa4fe-0cce-456e-951f-8ae1e9a8d667)



# 📃 명세서

### 1. 기능 명세서
- [바로가기](https://funky-fennel-a33.notion.site/64ecb04a25b8457b813714e9d175e8ed?v=4a1ab317009f40b792bee294961dbfb4&pvs=4)
### 2. API 명세서
- [바로가기](https://funky-fennel-a33.notion.site/API-6fd3f726edd648a8a34c07e0493ca3cb?pvs=4)

# 👨‍👩‍👧 Convention

### 1. Git Commit Convention

| 커밋 유형        | 의미                                                         |      |
| ---------------- | ------------------------------------------------------------ | ---- |
| Feat             | 기능 개발                                                    |      |
| Fix              | 버그 수정                                                    |      |
| Docs             | 문서 수정                                                    |      |
| Style            | 코드 formatting, 세미콜론 누락, 코드 자체의 변경이 없는 경우 |      |
| Refactor         | 코드 리팩토링                                                |      |
| Test             | 테스트 코드, 리팩토링 테스트 코드 추가                       |      |
| Chore            | 패키지 매니저 수정, 그 외 기타 수정 ex) .gitignore           |      |
| Design           | CSS 등 사용자 UI 디자인 변경                                 |      |
| Comment          | 필요한 주석 추가 및 변경                                     |      |
| Rename           | 파일 또는 폴더 명을 수정하거나 옮기는 작업만인 경우          |      |
| Remove           | 파일을 삭제하는 작업만 수행한 경우                           |      |
| !BREAKING CHANGE | 커다란 API 변경의 경우                                       |      |
| !HOTFIX          | 급하게 치명적인 버그를 고쳐야 하는 경우                      |      |

### 2. Git Branch Convention

- master

  : 실제 배포할 product의 브랜치

  - develop 브랜치로부터 Merge Request(MR)을 통해 소스코드 수정

- develop

  : 개발 중 개발된 기능이 모두 merge되는 브랜치

  - 직접 push 금지
  - feature 브랜치로부터 Merge Request(MR) 작성자 이외 1명 이상 코드 리뷰 후 merge 수행

- hotfix

  : 배포된 product에서 급한 버그 수정이 필요할 때 사용하는 일회성 브랜치

  - master에서 hotfix/…로 checkout
  - 버그 수정 후 master와 develop에 각각 merge 한 후 삭제

- feature

  : 기능 개발 단위로 사용하는 일회성 브랜치

  - develop에서 새로 checkout하여 feature브랜치 생성

  - develop으로 MR 요청 승인 후 삭제

  - feature 브랜치 네이밍은 기능과 연결된 Jira 이슈번호를 포함

    ```
    BE-Feat/S10P22E102-{이슈넘버}
    FE-Fix/S10P22E102-{이슈넘버}
    
    예시)
    FE-Feat/S10P22E102-100
    ```

### 3. Jira Convention

- 협업 및 일정, 업무 관리를 위해 Jira를 이용 

- 매주 월요일 오전 주 단위 계획을 짜고 스프린트를 일주일 단위로 진행.

- 이슈 유형 규칙

  - Epic : 큰 단위의 업무 덩어리, 문장 맨 앞 대괄호로 담당 영역 표기 (ex) [BE] ERD 설계

  - Story : 에픽 하위작업으로 수행해야 하는 개발 외 작업, 문장 맨 앞 대괄호로 이름 표기 (ex) [정종길] 팀 회의
  - Task : 에픽 하위작업으로 수행해야 하는 개발 작업, 문장 맨 앞 대괄호로 이름 표기  (ex) [정종길] Jenkins Pipeline 구축



### 
