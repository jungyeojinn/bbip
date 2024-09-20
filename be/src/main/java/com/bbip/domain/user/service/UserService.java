package com.bbip.domain.user.service;

import com.bbip.domain.user.entity.User;
import com.bbip.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    // 새로운 사용자 저장
    public User saveUser(User user) {
        return userRepository.save(user);
    }

    // 사용자가 이미 존재하는지 확인 후 저장
    public User saveOrUpdateOAuthUser(String email, String name, String provider) {
        Optional<User> existingUser = findByEmail(email);

        // 기존 사용자가 없으면 새로 저장
        if (existingUser.isEmpty()) {
            User newUser = new User();
            newUser.setEmail(email);  // AES 암호화 적용됨
            newUser.setName(name);
            newUser.setOauthProvider(provider);

            return saveUser(newUser);
        }

        return existingUser.get();  // 이미 등록된 사용자는 그대로 반환
    }
}
