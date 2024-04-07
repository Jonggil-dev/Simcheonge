package com.e102.simcheonge_server.domain.news.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
//import com.e102.simcheonge_server.domain.news.service.NewsApiService;

import com.e102.simcheonge_server.domain.news.service.NewsCrawlerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequiredArgsConstructor
@RequestMapping("/news")
public class NewsController {
//    private final NewsApiService newsApiService;
    private final NewsCrawlerService newsCrawlerService;

    // GET 방식의 어노테이션을 사용
//    @GetMapping("/api")
//    public ResponseEntity<?> apiNewsList(){
//        return ResponseUtil.buildBasicResponse(HttpStatus.OK, newsApiService.getNewsList());
//    }


    @GetMapping
    public ResponseEntity<?> crawlingNewsList(){
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, newsCrawlerService.getNewsList());
    }

    @GetMapping("/detail")
    public ResponseEntity<?> crawlingNewsDetail(@RequestParam("url") String newsUrl){
        // URL 처리 로직
        return ResponseUtil.buildBasicResponse(HttpStatus.OK, newsCrawlerService.getNewsDetail(newsUrl));
    }
}