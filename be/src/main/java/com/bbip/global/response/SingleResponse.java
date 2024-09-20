package com.bbip.global.response;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SingleResponse<T> extends CommonResponse {

    T data;

    @Builder
    public SingleResponse(String message, T data) {
        super(message);
        this.data = data;
    }
}
