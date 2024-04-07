package com.e102.simcheonge_server.domain.youthplcy.controller;

import com.e102.simcheonge_server.common.util.ResponseUtil;
import com.e102.simcheonge_server.domain.youthplcy.service.YouthPlcyService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@AllArgsConstructor
@RequestMapping("/openapi")
public class YouthPlcyController {
    private final YouthPlcyService youthPlcyService;

    @GetMapping
    public ResponseEntity<?> requestOpenApi(){
        log.info("requestOpenApi 요청 들어옴");
        youthPlcyService.insertUnprocessedPolicyData();
        return ResponseUtil.buildBasicResponse(HttpStatus.OK,"미가공 정책 데이터 추가");
    }
}
