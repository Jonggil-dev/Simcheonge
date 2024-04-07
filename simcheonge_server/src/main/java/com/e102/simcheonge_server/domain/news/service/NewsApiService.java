//package com.e102.simcheonge_server.domain.news.service;
//
//import com.e102.simcheonge_server.domain.news.dto.NewsItem;
//import com.e102.simcheonge_server.domain.news.dto.NewsListResponse;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Service;
//import com.fasterxml.jackson.databind.DeserializationFeature;
//import java.io.*;
//import java.net.HttpURLConnection;
//import java.net.MalformedURLException;
//import java.net.URL;
//import java.net.URLEncoder;
//import java.nio.charset.StandardCharsets;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//import java.util.stream.Collectors;
//
//@Service
//public class NewsApiService {
//    @Value("${naver.api.url}")
//    private String clientId;
//    @Value("${naver.client.id}")
//    private String clientSecret;
//
//    @Value("${naver.client.secret}")
//    private String naverApiUrl;
//
//
//    public NewsListResponse getNewsList() {
//        List<String> queries = List.of("청년", "정책", "청년 정책");
//        List<NewsItem> allItems = new ArrayList<>();
//
//        for (String query : queries) {
//            NewsListResponse response = getNewsListForQuery(query);
//            allItems.addAll(response.getItems());
//        }
//
//        // 최신순으로 정렬
//        List<NewsItem> sortedItems = allItems.stream()
//                .sorted((item1, item2) -> item2.getPubDate().compareTo(item1.getPubDate()))
//                .collect(Collectors.toList());
//
//        // 새로운 NewsListResponse 객체를 생성하여 반환
//        NewsListResponse combinedResponse = new NewsListResponse();
//        combinedResponse.setItems(sortedItems);
//        return combinedResponse;
//    }
//
//    private NewsListResponse getNewsListForQuery(String query) {
//        int display = query.equals("청년") ? 10 : 5; // "청년" 검색어에 대해 10개, 그 외는 5개씩 결과 가져오기
//
//        try {
//            query = URLEncoder.encode(query, "UTF-8");
//        } catch (UnsupportedEncodingException e) {
//            throw new RuntimeException("검색어 인코딩 실패", e);
//        }
//
//        String apiURL = naverApiUrl + "?query=" + query + "&display=" + display;
//
//        Map<String, String> requestHeaders = new HashMap<>();
//        requestHeaders.put("X-Naver-Client-Id", clientId);
//        requestHeaders.put("X-Naver-Client-Secret", clientSecret);
//        String responseBody = get(apiURL, requestHeaders);
//
//        ObjectMapper objectMapper = new ObjectMapper();
//        // 알 수 없는 JSON 속성을 무시하도록 설정
//        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
//
//        NewsListResponse newsListResponse;
//        try {
//            newsListResponse = objectMapper.readValue(responseBody, NewsListResponse.class);
//        } catch (IOException e) {
//            throw new RuntimeException("뉴스 데이터 파싱 실패", e);
//        }
//
//        return newsListResponse;
//    }
//
//    private static String get(String apiUrl, Map<String, String> requestHeaders){
//        HttpURLConnection con = connect(apiUrl);
//        try {
//            con.setRequestMethod("GET");
//            for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
//                con.setRequestProperty(header.getKey(), header.getValue());
//            }
//
//            int responseCode = con.getResponseCode();
//            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
//                return readBody(con.getInputStream());
//            } else { // 오류 발생
//                return readBody(con.getInputStream());
//            }
//        } catch (IOException e) {
//            throw new RuntimeException("API 요청과 응답 실패", e);
//        } finally {
//            con.disconnect();
//        }
//    }
//
//    private static HttpURLConnection connect(String apiUrl){
//        try {
//            URL url = new URL(apiUrl);
//            return (HttpURLConnection)url.openConnection();
//        } catch (MalformedURLException e) {
//            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
//        } catch (IOException e) {
//            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
//        }
//    }
//
//
//    private static String readBody(InputStream body) {
//        // InputStreamReader 생성 시 인코딩을 UTF-8로 명시
//        InputStreamReader streamReader = new InputStreamReader(body, StandardCharsets.UTF_8);
//
//        try (BufferedReader lineReader = new BufferedReader(streamReader)) {
//            StringBuilder responseBody = new StringBuilder();
//
//            String line;
//            while ((line = lineReader.readLine()) != null) {
//                responseBody.append(line);
//            }
//
//            return responseBody.toString();
//        } catch (IOException e) {
//            throw new RuntimeException("API 응답을 읽는 데 실패했습니다.", e);
//        }
//    }
//}
//
