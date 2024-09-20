package com.bbip.domain.oauth.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class mainController {

    @Operation(
            summary = "로그인 화면을 띄우기 위한 임시 api"
    )
    @GetMapping("/")
    public String home() {
        return "index";  // templates/index.html 파일을 반환0
    }

}
