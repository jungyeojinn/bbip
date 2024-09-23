package com.bbip.domain.rtmp.controller;

import com.bbip.domain.rtmp.service.RtmpService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

@Component
@Slf4j
@RequiredArgsConstructor
public class VideoStreamHandler extends TextWebSocketHandler implements DisposableBean {

    private Process ffmpegProcess;
    private BufferedOutputStream ffmpegInput;
    private final ExecutorService executorService = Executors.newVirtualThreadPerTaskExecutor();
    private Future<?> ffmpegProcessFuture;
    private final RtmpService rtmpService;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {

        log.info("Video stream connection established: {}", session.getId());

        // accessToken 추출하는 로직 필요
        String accessToken = session.getHandshakeHeaders().getFirst("Authorization");

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

        ffmpegProcess = processBuilder.start();
        ffmpegInput = new BufferedOutputStream(ffmpegProcess.getOutputStream());

        session.setBinaryMessageSizeLimit(100000); // 버퍼 크기 설정

        // 버추얼 쓰레드를 통해 비동기적으로 FFmpeg 프로세스 처리할 것
        ffmpegProcessFuture = executorService.submit(() -> {
            try {
                ffmpegInput.flush(); // 초기 플러시
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }

    @Override
    protected void handleBinaryMessage(WebSocketSession session, BinaryMessage message) {
        byte[] payload = message.getPayload().array();
        log.info("Received video stream message: {}", new String(payload));

        if (ffmpegInput != null) {
            // 버추얼 쓰레드를 통해 데이터를 FFmpeg에 비동기적으로 전달
            executorService.submit(() -> {
                try {
                    ffmpegInput.write(payload);
                    ffmpegInput.flush();
                } catch (IOException e) {
                    log.error("Error while writing video stream message", e);
                }
            });
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        log.info("Video stream connection closed");
        closeFfmpegResources();
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        log.error("Video stream transport error", exception);
        closeFfmpegResources();
    }

    @Override
    public void destroy() throws Exception {
        closeFfmpegResources();
        if (executorService != null) {
            executorService.shutdown(); // ExecutorService 종료
            log.info("Video stream executor service shutdown");
        }
    }

    private void closeFfmpegResources() throws IOException {
        if (ffmpegInput != null) {
            ffmpegInput.close();    // FFmpeg 입력 스트림을 닫음
        }
        if (ffmpegProcess != null) {
            ffmpegProcess.destroy();    // FFmpeg 프로세스를 종료
        }
        if (ffmpegProcessFuture != null) {
            ffmpegProcessFuture.cancel(true);   // FFmpeg 프로세스를 처리하는 쓰레드를 종료
        }
    }

}
