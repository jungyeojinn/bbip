package com.bbip.global.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.BAD_REQUEST)
@Getter
public class TokenNotFoundException extends RuntimeException {

    private static final int code = HttpStatus.BAD_REQUEST.value();

    public TokenNotFoundException(String message) {
        super(message);
    }
}