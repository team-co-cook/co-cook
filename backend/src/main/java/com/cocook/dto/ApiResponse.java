package com.cocook.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@Getter
@NoArgsConstructor
public class ApiResponse<T> {

    private String message;
    private Integer status;
    private T data;

    public ApiResponse(String message, Integer status, T data) {
        this.message = message;
        this.status = status;
        this.data = data;
    }

    /** 200 */
    public static <T> ResponseEntity<ApiResponse<T>> ok(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 200, data), HttpStatus.OK);
    }

    /** 201 */
    public static <T> ResponseEntity<ApiResponse<T>> created(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 201, data), HttpStatus.CREATED);
    }

    /** 202 */
    public static <T> ResponseEntity<ApiResponse<T>> accepted(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 202, data), HttpStatus.ACCEPTED);
    }

    /** 203 */
    public static <T> ResponseEntity<ApiResponse<T>> nonAuthoritativeInformation(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 203, data), HttpStatus.NON_AUTHORITATIVE_INFORMATION);
    }

    /** 204 */
    public static <T> ResponseEntity<ApiResponse<T>> noContent(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 204, data), HttpStatus.NO_CONTENT);
    }

    /** 205 */
    public static <T> ResponseEntity<ApiResponse<T>> resetContent(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 205, data), HttpStatus.RESET_CONTENT);
    }

    /** 206 */
    public static <T> ResponseEntity<ApiResponse<T>> partialContent(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 206, data), HttpStatus.PARTIAL_CONTENT);
    }

    /** 207 */
    public static <T> ResponseEntity<ApiResponse<T>> multiStatus(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 207, data), HttpStatus.MULTI_STATUS);
    }

    /** 208 */
    public static <T> ResponseEntity<ApiResponse<T>> alreadyReported(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 208, data), HttpStatus.ALREADY_REPORTED);
    }

    /** 209 */
    public static <T> ResponseEntity<ApiResponse<T>> iMUsed(T data) {
        return new ResponseEntity<>(new ApiResponse<>("OK", 209, data), HttpStatus.IM_USED);
    }


    /** 400 */
    public static <T> ResponseEntity<ApiResponse<T>> badRequest(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 400, data), HttpStatus.BAD_REQUEST);
    }

    /** 401 */
    public static <T> ResponseEntity<ApiResponse<T>> unauthorized(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 401, data), HttpStatus.UNAUTHORIZED);
    }

    /** 402 */
    public static <T> ResponseEntity<ApiResponse<T>> paymentRequired(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 402, data), HttpStatus.PAYMENT_REQUIRED);
    }

    /** 403 */
    public static <T> ResponseEntity<ApiResponse<T>> forbidden(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 403, data), HttpStatus.FORBIDDEN);
    }

    /** 404 */
    public static <T> ResponseEntity<ApiResponse<T>> notFound(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 402, data), HttpStatus.NOT_FOUND);
    }

    /** 405 */
    public static <T> ResponseEntity<ApiResponse<T>> methodNotAllowed(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 405, data), HttpStatus.METHOD_NOT_ALLOWED);
    }

    /** 406 */
    public static <T> ResponseEntity<ApiResponse<T>> notAcceptable(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 406, data), HttpStatus.NOT_ACCEPTABLE);
    }

    /** 407 */
    public static <T> ResponseEntity<ApiResponse<T>> proxyAuthenticationRequired(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 407, data), HttpStatus.PROXY_AUTHENTICATION_REQUIRED);
    }

    /** 408 */
    public static <T> ResponseEntity<ApiResponse<T>> requestTimeout(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 408, data), HttpStatus.REQUEST_TIMEOUT);
    }

    /** 409 */
    public static <T> ResponseEntity<ApiResponse<T>> conflict(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 409, data), HttpStatus.CONFLICT);
    }

    /** 410 */
    public static <T> ResponseEntity<ApiResponse<T>> gone(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 410, data), HttpStatus.GONE);
    }

    /** 415 */
    public static <T> ResponseEntity<ApiResponse<T>> unsupportedMediaType(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 415, data), HttpStatus.UNSUPPORTED_MEDIA_TYPE);
    }

    /** 500 */
    public static <T> ResponseEntity<ApiResponse<T>> internalServerError(String message, T data) {
        return new ResponseEntity<>(new ApiResponse<>(message, 500, data), HttpStatus.INTERNAL_SERVER_ERROR);
    }

}
