package com.e102.simcheonge_server.common.exception;


import com.e102.simcheonge_server.common.response.ErrorResponse;
import com.e102.simcheonge_server.common.util.ResponseUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.nio.file.AccessDeniedException;


@Slf4j
@RestControllerAdvice
public class ApiExceptionController {

    // 잘못된 인수값 전달
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorResponse illegalExHandle(IllegalArgumentException e) {
        return constructErrorResponse(e,HttpStatus.BAD_REQUEST,"IllegalArgumentException");
    }

    // 부적절한 객체상태오류
    @ExceptionHandler(IllegalStateException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorResponse illegalExHandle(IllegalStateException e) {
        return constructErrorResponse(e,HttpStatus.BAD_REQUEST, "IllegalStateException");
    }

    // 잘못된 요청 데이터
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorResponse handleValidationExceptions(MethodArgumentNotValidException e) {
        return constructErrorResponse(e,HttpStatus.BAD_REQUEST, "handleValidationExceptions");
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(ResponseStatusException.class)
    public ErrorResponse responseStatusException(ResponseStatusException e) {
        return constructErrorResponse(e,HttpStatus.BAD_REQUEST, "ResponseStatusException");
    }

    // 리소스를 찾을 수 없음
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleNoHandlerFoundException(NoHandlerFoundException e) {
        return constructErrorResponse(e,HttpStatus.NOT_FOUND, "handleNoHandlerFoundException");
    }

    // 권한없음(접근거부)
    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public ErrorResponse handleAccessDeniedException(AccessDeniedException e) {
        return constructErrorResponse(e,HttpStatus.FORBIDDEN, "handleAccessDeniedException");
    }

    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ExceptionHandler(DataNotFoundException.class)
    public ResponseEntity<?> dataNotFoundException(DataNotFoundException e) {
        log.error("[exceptionHandle] ex={}", e.getMessage());
        return ResponseUtil.buildErrorResponse(HttpStatus.NOT_FOUND,"DataNotFoundException",e.getMessage());
    }

    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<?> AuthenticationException2(AuthenticationException e) {
        log.error("[exceptionHandle] ex={}", e.getMessage());
        return ResponseUtil.buildErrorResponse(HttpStatus.UNAUTHORIZED,"AuthenticationException",e.getMessage());
    }


    private ErrorResponse constructErrorResponse(Exception e, HttpStatus status, String errorType) {
        log.error("[exceptionHandle] ex={}", e.getMessage(), e);
        return new ErrorResponse(status.value(), errorType, e.getMessage());
    }
}
