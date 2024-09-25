package com.bbip.domain.rtmp.controller;

import com.bbip.domain.rtmp.service.RtmpService;
import com.bbip.global.exception.FlushFailException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.rsocket.annotation.ConnectMapping;
import org.springframework.stereotype.Controller;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

@Controller
@Slf4j
@RequiredArgsConstructor
public class VideoStreamController {

    private final Map<String, Process> ffmpegProcessMap = new ConcurrentHashMap<>();
    private final Map<String, BufferedOutputStream> ffmpegInputMap = new ConcurrentHashMap<>();
    private final Map<String, Future<?>> ffmpegProcessFutureMap = new ConcurrentHashMap<>();
    private final ExecutorService executorService = Executors.newVirtualThreadPerTaskExecutor();
    private final RtmpService rtmpService;

    private static final List<String> OUTPUT_FORM = List.of(
            "-c:v", "libx264", // 비디오 코덱
            "-preset", "ultrafast", // 인코딩 속도 증가
            "-b:v", "2M", // 비디오 비트레이트
            "-c:a", "aac", // 오디오 코덱
            "-b:a", "128k", // 오디오 비트레이트
            "-g", "120",  // GOP 크기 설정 (예: 4초에 해당)
            "-f", "flv"
    );

    @ConnectMapping("/ws/rtmps")
    public void handleConnect(@Header("simpSessionId") String sessionId, @Header("Authorization") String accessToken) {
        log.info("token at ConnectMapping: {}", accessToken);
        if (!ffmpegProcessMap.containsKey(sessionId)) {
            // FFmpeg 프로세스 초기화
            initializeFfmpegProcess(sessionId, accessToken);
        }
    }

    @MessageMapping("/ws/rtmps")
    public void handleVideoStream(@Payload byte[] payload, @Header("simpSessionId") String sessionId) {
        if (ffmpegProcessMap.containsKey(sessionId) && ffmpegProcessMap.get(sessionId).isAlive()) {
            // 비동기적으로 FFmpeg에 비디오 데이터 전송
            executorService.submit(() -> {
                BufferedOutputStream ffmpegInput = ffmpegInputMap.get(sessionId);
                try {
                    ffmpegInput.write(payload);
                    ffmpegInput.flush();
                } catch (IOException e) {
                    throw new FlushFailException("비디오 스트림 메시지를 write 중 오류 발생");
                }
            });
        } else {
            log.error("FFmpeg 프로세스가 존재하지 않거나 종료되었습니다. 세션 ID: {}", sessionId);
        }
    }

    public void initializeFfmpegProcess(String sessionId, String accessToken) {
        log.info("Initializing FFmpeg process for session: {}", sessionId);

        List<String> rtmpUrls = rtmpService.getRtmpUrls(accessToken);
        List<String> command = new ArrayList<>(List.of(
                "ffmpeg",
                "-v", "error",
                "-f", "webm",  // 입력 포맷
                "-i", "pipe:0" // 표준 입력 사용
        ));

        for (String rtmpUrl : rtmpUrls) {
            command.addAll(OUTPUT_FORM);
            command.add(rtmpUrl);
        }

        ProcessBuilder processBuilder = new ProcessBuilder(command);

        try {
            Process ffmpegProcess = processBuilder.start();
            BufferedOutputStream ffmpegInput = new BufferedOutputStream(ffmpegProcess.getOutputStream());

            // FFmpeg 프로세스 및 입력 스트림 저장
            ffmpegProcessMap.put(sessionId, ffmpegProcess);
            ffmpegInputMap.put(sessionId, ffmpegInput);

            // 비동기적으로 FFmpeg 프로세스를 실행
            Future<?> ffmpegProcessFuture = executorService.submit(() -> {
                try {
                    ffmpegProcess.waitFor(); // 프로세스가 종료될 때까지 대기
                } catch (InterruptedException e) {
                    log.error("FFmpeg 프로세스 대기 중 인터럽트 발생", e);
                }
            });
            ffmpegProcessFutureMap.put(sessionId, ffmpegProcessFuture);
        } catch (IOException e) {
            log.error("FFmpeg 프로세스 시작 실패", e);
            throw new RuntimeException("FFmpeg 프로세스 시작 실패", e);
        }
    }

    public void closeFfmpegResources(String sessionId) throws IOException {
        if (ffmpegInputMap.containsKey(sessionId)) {
            BufferedOutputStream ffmpegInput = ffmpegInputMap.get(sessionId);
            if (ffmpegInput != null) {
                ffmpegInput.close();
            }
        }
        if (ffmpegProcessMap.containsKey(sessionId)) {
            Process ffmpegProcess = ffmpegProcessMap.get(sessionId);
            if (ffmpegProcess != null) {
                ffmpegProcess.destroy();
            }
        }
        if (ffmpegProcessFutureMap.containsKey(sessionId)) {
            Future<?> ffmpegProcessFuture = ffmpegProcessFutureMap.get(sessionId);
            if (ffmpegProcessFuture != null) {
                ffmpegProcessFuture.cancel(true);
            }
        }

        // 맵에서 해당 세션의 자원 제거
        ffmpegProcessMap.remove(sessionId);
        ffmpegInputMap.remove(sessionId);
        ffmpegProcessFutureMap.remove(sessionId);
    }
}
