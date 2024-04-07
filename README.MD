# 심청이 - 심플한 청년의 이익(Simple Cheongnyeon Economy)


### 프로젝트 진행 기간

2024.02.19(월)~2024.04.05(금)


## 개요

- 청년들을 위한 많은 정책과 혜택들이 있지만 그 정보를 몰라서 이용하지 못하는 청년들을 위해 제작
- 나눠져 있는 각 지원 정책과 청년에게 필요한 정보를 한 앱에서 최대한 '간편하게' 제공
- STT 기반의 챗봇기능을 메인으로 구현하여, 접근성을 향상
- 재테크를 준비함에 있어서 기본적인 경제 및 사회 관련 용어 / 개념을 제공


## **💡 주요 기능**

### 챗봇을 이용한 정책 검색

- 생성형 AI로 구현한 챗봇을 통해 쉽게 정책을 검색할 수 있게 지원
- STT지원으로 편리성 증대

### 검색 필터를 이용한 정책 검색

- 지역/학력/취업 상태/특화 분야/관심 분야/신청 기간 필터를 통해 원하는 정책을 검색할 수 있게 지원
- STT지원으로 편리성 증대

### 자동 정책 업데이트 및 관리 시스템

- Spring Scheduler로 새로운 정책 데이터를 DB에 자동 추가
- 관리자가 관리자 페이지를 통해 가공할 수 있는 시스템 구축

### 오늘의 뉴스 요약

- 오늘의 주요 뉴스를 ChatGPT로 요약하여 간단하게 소개

### 경제 용어 소개

- 기본적인 경제 관련 용어를 제공

## 📺실행화면

<table>
 <tr>
  <th colspan="2">챗봇으로 정책 검색하기</th>
 </tr>
 <tr>
  <td><img src="/uploads/136b52b099d69435b11128f902583fdb/KakaoTalk_20240403_141330828.jpg"></td>
  <td><img src="/uploads/136b52b099d69435b11128f902583fdb/KakaoTalk_20240403_141330828.jpg"></td>
 </tr>
</table>
<table>
 <tr>
  <th colspan="2">검색 필터로 정책 검색하기</th>
 </tr>
 <tr>
  <td><img src="/uploads/864bf65ca6a6664469ffdba6371bd4c6/KakaoTalk_20240403_141332545.jpg"></td>
  <td><img src="/uploads/f7d01a5c04ad58171b535122e3d65f73/KakaoTalk_20240403_141331916.jpg"></td>
 </tr>
 <tr align="center">
  <td>검색 화면</td>
  <td>필터 선택</td>
 </tr>
</table>

<table>
 <tr>
  <th colspan="2">경제 용어 소개</th>
 </tr>
 <tr>
  <td><img src="/uploads/2f01617643420861304fdd8164202d6b/KakaoTalk_20240403_141329742.jpg"></td>
  <td><img src="/uploads/a842628d2d621465de934f345b16ebb4/KakaoTalk_20240403_141328118.jpg"></td>
 </tr>
 <tr align="center">
  <td>랜덤 경제 용어</td>
  <td>용어 설명</td>
 </tr>
</table>

<table>
 <tr>
  <th colspan="2">오늘의 주요 뉴스</th>
 </tr>
 <tr>
  <td><img src="/uploads/ec2753996d9237ae9f7b6ce1b04f793c/KakaoTalk_20240403_151336619.jpg"></td>
  <td><img src="/uploads/0df0a96ef8c149b0db5379f2c447bcfb/KakaoTalk_20240403_151335802.jpg"></td>
 </tr>
 <tr align="center">
  <td>뉴스 요약</td>
  <td>뉴스 전문</td>
 </tr>
</table>

<table>
 <tr>
  <th>정책 관리 시스템</th>
 </tr>
 <tr>
  <td><img src="/uploads/b5802ee2c8b8ce86ae356c54cb972e61/화면_캡처_2024-04-03_150206.png"></td>
 <tr align="center">
  <td>정책 목록</td>
 </tr>
  <tr>
  <td><img src="/uploads/0169847f2f50b3b36e737425e24c085c/화면_캡처_2024-04-03_150249.png"></td>
 <tr align="center">
  <td>정책 관리</td>
 </tr>
</table>

## Usage


<aside>
💡 exec폴더의 포팅메뉴얼을 따라 진행

</aside>

### 개발환경

![화면_캡처_2024-04-03_153131](/uploads/559c486ade7fe5cf0c08de73ff7fb3c8/화면_캡처_2024-04-03_153131.png)


## Service Architecture
![9to6_architecture2](/uploads/638ae8cfe1124f9f2fe48e28d2c4732c/9to6_architecture2.png)


## **💬 ERD**


![E102__3_](/uploads/354c0931b95fe240ad31e96d082a4672/E102__3_.png)



## Team Members

<table>
<tr>
<th colspan="2">FrontEnd</th>
<th colspan="4">BackEnd</th>
<th colspan="2">Cooperation</th>
</tr>
<tr align = "center">
<td>
<a href=""/>김지수</a>
</td>
<td>
<a href=""/>서준하</a>
</td>
<td>
<a href=""/>김민진</a>
</td>
<td>
<a href=""/>박다민</a>
</td>
<td>
<a href=""/>정종길</a>
</td>
<td>
<a href="https://github.com/object1997428"/>주혜련</a>
</td>
<td><a href="https://lab.ssafy.com/s10-fintech-finance-sub2/S10P22E102"/>GitLab</a></td>
<td><a href="https://ssafy.atlassian.net/projects/S10P22E102"/>Jira</a></td>
