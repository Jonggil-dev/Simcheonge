package com.e102.simcheonge_server.domain.economic_word.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.economic_word.entity.EconomicWord;
import com.e102.simcheonge_server.domain.economic_word.service.EconomicWordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/economicword") // 클래스 레벨에서 경로 매핑
public class EconomicWordController {

    @Autowired
    private EconomicWordService economicWordService;

    @GetMapping
    public ResponseEntity<?> getRandomWord() {
        try {
            EconomicWord economicWord = economicWordService.getRandomEconomicWord();
            if (economicWord == null) {
                // 데이터가 없는 경우, Not Found 응답 반환
                return ResponseUtil.buildErrorResponse(HttpStatus.NOT_FOUND, "DataNotFoundError", "DB에 데이터가 없습니다.");
            }
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, economicWord);

        } catch (Exception e) {
            // 처리 중 예외 발생 시, 서버 에러 응답 반환
            return ResponseUtil.buildErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR, "ProcessError", "데이터 처리 중 에러가 발생했습니다.");
        }
    }
    @PostMapping
    public ResponseEntity<?> processData(@RequestBody Map<String, String> payload) {
        // 요청 본문에서 'url' 키를 통해 다운로드 URL을 받음
        String downloadUrl = payload.get("url");

        if (downloadUrl == null || downloadUrl.isEmpty()) {
            // 'url' 키가 없거나 URL이 비어 있는 경우, Bad Request 응답 반환
            return ResponseUtil.buildErrorResponse(HttpStatus.BAD_REQUEST,"UrlNullError", "요청에 URL 정보가 없습니다");
        }

        try {
            economicWordService.updateData(downloadUrl);
            return ResponseUtil.buildBasicResponse(HttpStatus.OK, "경제용어 DB를 업데이트 했습니다.");
        } catch (IOException e) {
            // 파일 다운로드 또는 처리 중에 IOException 발생 시, 서버 에러 응답 반환
            return ResponseUtil.buildErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR, "ProcessError", "데이터 처리 중 에러가 발생했습니다.");
        }
    }
}
