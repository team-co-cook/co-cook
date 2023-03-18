package com.cocook.exception;

import com.cocook.dto.ApiResponse;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.NoHandlerFoundException;

import javax.persistence.EntityNotFoundException;
import java.util.Set;


@RestControllerAdvice
public class CustomExceptionHandler {

    // 기본적인 예외 처리
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ApiResponse<?>> handleRuntimeException(RuntimeException e) {
        ApiResponse<?> apiResponse = new ApiResponse<Object>(e.getMessage(), 400, null);
        return new ResponseEntity<>(apiResponse, HttpStatus.BAD_REQUEST);
    }

    // @Valid에서 유효성 검사에 실패한 경우
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<?>> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        ApiResponse<?> apiResponse = new ApiResponse<Object>("유효성 검사에 실패하였습니다.", 400, null);
        return new ResponseEntity<>(apiResponse, HttpStatus.BAD_REQUEST);
    }

    // 쿼리 파라미터 잘못 넣은 경우
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ApiResponse<?>> handleMissingServletRequestParameterException(MissingServletRequestParameterException e) {
        ApiResponse<?> apiResponse = new ApiResponse<Object>("쿼리 파라미터를 정확히 입력해주세요.", 400, null);
        return new ResponseEntity<>(apiResponse, HttpStatus.BAD_REQUEST);
    }

    // 인증에 실패한 경우
    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiResponse<?>> handleAuthenticationException(AuthenticationException e) {
        ApiResponse<?> apiResponse = new ApiResponse<Object>(e.getMessage(), 401, null);
        return new ResponseEntity<>(apiResponse, HttpStatus.UNAUTHORIZED);
    }

    // 쿼리 날렸을 때 DB에서 찾지 못한 경우
    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ApiResponse<?>> handleEntityNotFoundException(EntityNotFoundException e) {
        ApiResponse<?> apiResponse = new ApiResponse<Object>(e.getMessage(), 404, null);
        return new ResponseEntity<>(apiResponse, HttpStatus.NOT_FOUND);
    }

    // 요청의 method가 잘못된 경우
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiResponse<?>> handleHttpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
        Set<HttpMethod> supportedMethods = e.getSupportedHttpMethods();
        ApiResponse<?> apiResponse = new ApiResponse<Object>("지원되지 않는 메소드입니다. 다음 메소드를 이용해주세요: " + supportedMethods, 405, null);
        return new ResponseEntity<>(apiResponse, HttpStatus.METHOD_NOT_ALLOWED);
    }

    // 생성 또는 수정 시, DB에 중복되는 값이 있는 경우
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<?>> handleDataIntegrityViolationException(DataIntegrityViolationException e) {
        ApiResponse<?> apiResponse = new ApiResponse<Object>(e.getMessage(), 409, null);
        return new ResponseEntity<>(apiResponse, HttpStatus.CONFLICT);
    }
}


//    @ExceptionHandler(EmptyResultDataAccessException.class)
//    public ResponseEntity<ApiResponse<?>> handleEmptyResultDataAccessException(EmptyResultDataAccessException e) {
//        ApiResponse<?> apiResponse = new ApiResponse<Object>(e.getMessage(), 404, null);
//        return new ResponseEntity<>(apiResponse, HttpStatus.NOT_FOUND);
//    }