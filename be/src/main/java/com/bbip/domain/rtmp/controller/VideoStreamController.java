package com.bbip.domain.rtmp.controller;

import com.bbip.domain.rtmp.service.RtmpService;
import com.bbip.global.exception.FlushFailException;
import com.bbip.global.exception.TokenNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

@Controller
@Slf4j
@RequiredArgsConstructor
public class VideoStreamController {

    private Process ffmpegProcess;
    private BufferedOutputStream ffmpegInput;
    private final ExecutorService executorService = Executors.newVirtualThreadPerTaskExecutor();
    private Future<?> ffmpegProcessFuture;
    private final RtmpService rtmpService;

    @MessageMapping("/ws/rtmps")
    public void handleVideoStream(@Payload byte[] payload, @Header("Authorization") String accessToken) {
//        log.info("Received video stream message via STOMP");

        if (ffmpegInput == null || !ffmpegProcess.isAlive()) {
            // FFmpeg 프로세스 초기화
            initializeFfmpegProcess(accessToken);
        }

        // 비동기적으로 FFmpeg에 비디오 데이터 전송
        executorService.submit(() -> {
            try {
                ffmpegInput.write(payload);
                ffmpegInput.flush();
            } catch (IOException e) {
                throw new FlushFailException("비디오 스트림 메시지를 write중 오류 발생");
            }
        });
    }

    private void initializeFfmpegProcess(String accessToken) {
        log.info("Initializing FFmpeg process");

        String rtmpUrl = rtmpService.getRtmpUrls(accessToken);

        ProcessBuilder processBuilder = new ProcessBuilder(
                "ffmpeg",
                "-v", "error",
                "-f", "webm",  // 입력 포맷
                "-i", "pipe:0", // 표준 입력 사용
                "-c:v", "libx264", // 비디오 코덱
                "-preset", "ultrafast", // 인코딩 속도 증가
                "-b:v", "2M", // 비디오 비트레이트
                "-c:a", "aac", // 오디오 코덱
                "-b:a", "128k", // 오디오 비트레이트
                "-f", "tee",  // 동시 송출을 위해 tee 멀티플렉서 사용
                rtmpUrl  // 유튜브 RTMP 서버 URL 목록
        );

        try {
            ffmpegProcess = processBuilder.start();
            ffmpegInput = new BufferedOutputStream(ffmpegProcess.getOutputStream());
        } catch (IOException e) {
            log.error("FFmpeg 프로세스 시작 실패", e);
            throw new RuntimeException("FFmpeg 프로세스 시작 실패", e);
        }

        // 버추얼 쓰레드를 통해 FFmpeg 프로세스 비동기 처리
        ffmpegProcessFuture = executorService.submit(() -> {
            try {
                ffmpegInput.flush(); // 초기 플러시
            } catch (IOException e) {
                throw new FlushFailException("초기 flush 실패");
            }
        });
    }

    // 리소스 해제 메소드
    public void closeFfmpegResources() throws IOException {
        if (ffmpegInput != null) {
            ffmpegInput.close();
        }
        if (ffmpegProcess != null) {
            ffmpegProcess.destroy();
        }
        if (ffmpegProcessFuture != null) {
            ffmpegProcessFuture.cancel(true);
        }
    }
}
