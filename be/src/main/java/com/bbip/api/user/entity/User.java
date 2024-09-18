package com.bbip.api.user.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "user")
@AllArgsConstructor
@NoArgsConstructor

public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 20)
    private String username;

    @Column(nullable = false, length = 50)
    private String password;

    @Column(nullable = false, length = 20)
    private String email;

    @Column(nullable = false, length = 20)
    private String nickname;

    @Column(nullable = false)
    private Boolean deleted;

}
