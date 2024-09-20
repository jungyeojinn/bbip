package com.bbip.domain.user.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "user")
@Getter
@Setter
@NoArgsConstructor  // 기본 생성자 자동 생성
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)  // 암호화된 이메일은 길이가 길어질 수 있으므로 길이 설정
    private String email;

    @Column(nullable = false, length = 20)
    private String name;

    @Column(length = 100)
    private String oauthProvider;

    @Column(nullable = false)
    private Boolean deleted = false;  // 소프트 삭제를 위한 필드

}