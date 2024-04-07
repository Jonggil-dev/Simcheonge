//package com.e102.simcheonge_server.domain.news.service;
//
//import org.openqa.selenium.By;
//import org.openqa.selenium.WebDriver;
//import org.openqa.selenium.WebElement;
//import org.openqa.selenium.chrome.ChromeDriver;
//import org.openqa.selenium.chrome.ChromeOptions;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Service;
//
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.List;
//
//@Service
//public class NewsCrawlerServiceDynamic {
//    @Value("${naver.crawler.url}")
//    private String baseUrl;
//
//    public List<String> getNewsList() {
//        List<String> newsLinks = new ArrayList<>();
//        List<Integer> sids = Arrays.asList(100); // 예제로 하나의 SID만 사용
//
//        // ChromeDriver 경로 설정
//        System.setProperty("webdriver.chrome.driver", "C:/Users/정종길/Downloads/chromedriver-win64/chromedriver.exe");
//
//
//
//        ChromeOptions options = new ChromeOptions();
//        options.addArguments("--headless"); // 브라우저 창이 실제로 열리지 않음
//        WebDriver driver = new ChromeDriver(options);
//
//        sids.forEach(sid -> {
//            String fullUrl = baseUrl + sid;
//            driver.get(fullUrl);
//
//            // 페이지 로드를 기다림 (필요에 따라 조정)
//            try {
//                Thread.sleep(5000); // 예시로 5초 대기
//            } catch (InterruptedException e) {
//                e.printStackTrace();
//            }
//
//            // 동적 콘텐츠가 포함된 페이지에서 요소 찾기
//            List<WebElement> items = driver.findElements(By.cssSelector("#_SECTION_HEADLINE_LIST_frwpj > li:nth-child(4) > div > div > div.sa_text > a"));
//            System.out.println("@@@"+ items);
//            for (WebElement item : items) {
//                if (newsLinks.size() >= 10) break;
//                newsLinks.add(item.getAttribute("href"));
//            }
//        });
//
//        driver.quit(); // WebDriver 종료
//        return newsLinks;
//    }
//}
