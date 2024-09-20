package com.bbip.global.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Slf4j
public class CommonResponse {

    Integer statusCode;
    String message;

    public CommonResponse(String message) {
        this.statusCode = HttpStatus.OK.value();
        this.message = message;
    }

    /**
     * 상태 번호의 코드네임을 반환하는 함수
     * @return 상태 코드명
     */
    public HttpStatus getHttpStatus() {
        try {
            return HttpStatus.valueOf(statusCode);
        } catch (IllegalArgumentException e) {
            log.error("존재하지 않는 상태코드 반환 시도");
            return HttpStatus.INTERNAL_SERVER_ERROR;
        }
    }

}
