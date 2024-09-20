package com.bbip.domain.oauth.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class mainController {

    @GetMapping("/")
    public String home() {
        return "index";  // templates/index.html 파일을 반환0
    }

}
