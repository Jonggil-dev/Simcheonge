package com.e102.simcheonge_server.domain.news.service;

import com.e102.simcheonge_server.domain.news.dto.NewsDetailResponse;
import java.net.http.HttpRequest.BodyPublishers;
import com.e102.simcheonge_server.domain.news.dto.NewsItem;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.nodes.TextNode;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import java.net.http.HttpResponse.BodyHandlers;
import java.io.IOException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.*;


@Service
public class NewsCrawlerService {
    @Value("${naver.crawler.url}")
    private String baseUrl;
    @Value("${openai.secret-key}")
    private String apiKey;

    public List<NewsItem> getNewsList() {
        List<NewsItem> newsItems = new ArrayList<>();
        List<Integer> sids = Arrays.asList(100, 101, 102, 105);

        sids.forEach(sid -> {
            String fullUrl = baseUrl + sid;
            int count = 0;
            try {
                Document doc = Jsoup.connect(fullUrl).get();
//                PrintWriter out1 = new PrintWriter(new OutputStreamWriter(new FileOutputStream("result1.html"), "UTF-8"));
//                out1.println(doc.toString()); // doc의 HTML 내용을 파일에 쓴다.

                Elements headlineNews = doc.select(".sa_list .sa_item._SECTION_HEADLINE"); //headline에 있는 기사들 추출
//                PrintWriter out2 = new PrintWriter(new OutputStreamWriter(new FileOutputStream("result2.html"), "UTF-8"));
//                out2.println(headlineNews.toString()); // doc의 HTML 내용을 파일에 쓴다.

                for (Element item : headlineNews) {
                    if (count >= 5) break;
                    String title = item.select(".sa_text > a > strong").text();
                    String description = item.select(".sa_text_lede").text();
                    String publisher = item.select(".sa_text_press").text();
                    String headlinesLinks = item.select(".sa_text > a").attr("href");
                    NewsItem newsItem = new NewsItem(title, description, publisher, headlinesLinks);
                    count++;
                    newsItems.add(newsItem);

                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

        return newsItems;
    }


    public NewsDetailResponse getNewsDetail(String newsLink) {
            NewsDetailResponse newsDetailResponse = new NewsDetailResponse();

            try {
                Document newsDoc = Jsoup.connect(newsLink).get();

//                PrintWriter out3 = new PrintWriter(new OutputStreamWriter(new FileOutputStream("result.html"), "UTF-8"));
//                out3.println(newsDoc.toString()); // doc의 HTML 내용을 파일에 쓴다.

                String title = newsDoc.select("#title_area > span").text();

                Elements modifyTimeElements = newsDoc.select("span._ARTICLE_MODIFY_DATE_TIME");
                String time;

                if (!modifyTimeElements.isEmpty()) {
                    // 수정 시간이 있으면 이를 사용합니다.
                    time = modifyTimeElements.text();
                } else {
                    // 수정 시간이 없으면 작성 시간을 사용합니다.
                    time = newsDoc.select("span._ARTICLE_DATE_TIME").text();
                }

                String reporter = newsDoc.select("div.media_end_head_journalist > a > em").text();

                // #dic_area ID를 가진 Element를 선택
                Element originalContentNode = newsDoc.select("#dic_area").first();

                StringBuilder directText = new StringBuilder();
                //     Element의 직계 자식 노드를 순회 하여 직계 텍스트만 추출
                for (Node node : originalContentNode.childNodes()) {
                    if (node instanceof TextNode) {
                        TextNode textNode = (TextNode) node;
                        directText.append(textNode.text().trim()); // 직접 텍스트 추출 및 줄바꿈 추가
                    } else if (node.nodeName().equals("br")) {
                        directText.append("\n"); // <br> 태그를 만날 때마다 줄바꿈 추가
                    }
                }

                // StringBuilder 객체를 String으로 변환
                String originalContent = directText.toString().trim();


                newsDetailResponse.setTitle(title);
                newsDetailResponse.setOriginalContent(originalContent);
                newsDetailResponse.setTime(time);
                newsDetailResponse.setReporter(reporter);

                String summarizedContent = summarizeTextWithChatGPT(originalContent);
                newsDetailResponse.setSummarizedContent(summarizedContent);

            } catch (IOException e) {
                e.printStackTrace();
            }
        return newsDetailResponse;
    }


    public String summarizeTextWithChatGPT(String originalContent) throws JsonProcessingException {

        try {
        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put("model", "gpt-3.5-turbo");

        List<Map<String, String>> messages = new ArrayList<>();
        Map<String, String> systemMessage = new HashMap<>();
        systemMessage.put("role", "system");
        systemMessage.put("content", "You are a helpful assistant.");
        messages.add(systemMessage);

        Map<String, String> userMessage = new HashMap<>();
        userMessage.put("role", "user");
        userMessage.put("content", "답변은 한글로 해주고, 답변에는 요청한 내용에 대한 답변 말고는 아무것도 작성하지마. 그리고 뉴스 요약에는 원본 내용의 문맥상 중요한 내용이 다 담기게 해줘. 다음 텍스트에서 뉴스 기사의 핵심 내용을 요약해줘:\\n" + originalContent);
        messages.add(userMessage);

        jsonMap.put("messages", messages);

        // Jackson ObjectMapper 인스턴스 생성
        ObjectMapper mapper = new ObjectMapper();

        // 객체를 JSON 문자열로 변환
        String jsonBody = mapper.writeValueAsString(jsonMap);

        // HTTP 요청 생성 및 전송
        String apiURL = "https://api.openai.com/v1/chat/completions"; // API URL

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(apiURL))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + apiKey) // API 키
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println("@@@@@@@@@@@@@@@@@"+response);


        String responseBody = response.body();
        System.out.println("@@@@@@@@@@@@@@@@@"+response.body());

            // JSON 문자열 파싱
        ObjectMapper objectMapper = new ObjectMapper();

        JsonNode rootNode = objectMapper.readTree(responseBody);
        JsonNode choicesNode = rootNode.path("choices");

        if (choicesNode.isArray() && choicesNode.size() > 0) {
                JsonNode firstChoice = choicesNode.get(0);
                JsonNode messageNode = firstChoice.path("message");
                String content = messageNode.path("content").asText();

                return content; // 생성된 텍스트 응답 반환
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    return null;
    }
}

