package com.bbip.domain.rtmp.repository;

import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Component
@NoArgsConstructor
public class SessionRepository {

    private static SessionRepository sessionRepositoryRepo;

    // Session 데이터를 공통으로 사용하기 위해 싱글톤으로 구현
    public static SessionRepository getInstance(){
        if(sessionRepositoryRepo == null){
            synchronized (SessionRepository.class){
                sessionRepositoryRepo = new SessionRepository();
            }
        }
        return sessionRepositoryRepo;
    }

}
