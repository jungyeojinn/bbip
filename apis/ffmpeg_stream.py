import cv2
import numpy as np
import subprocess
import time
import asyncio

# 전역 FFmpeg 프로세스
ffmpeg_process = None

# FFmpeg 명령어 설정
# FFmpeg 프로세스를 시작하는 함수
def start_ffmpeg_process():
    global ffmpeg_process
    if ffmpeg_process is None:
        ffmpeg_command = [
            'ffmpeg', '-re',
            '-loglevel', 'debug',
            '-f', 'rawvideo',
            '-pixel_format', 'bgr24',
            '-video_size', '480x640',  # 비디오 크기 설정
            '-r', '30',
            '-i', '-',  # stdin에서 비디오 입력
            '-f', 's16le',  # 오디오 입력 포맷을 설정
            '-ar', '44100',  # 샘플링 레이트
            '-ac', '2',      # 스테레오 채널
            # '-i', 'pipe:1',  # stdin에서 오디오 입력
            '-c:v', 'libx264',
            '-b:v', '1500k',  # 비디오 비트레이트
            '-c:a', 'aac',    # 오디오 코덱 설정
            '-b:a', '128k',   # 오디오 비트레이트
            # '-async', '1',
            '-vsync', '1',
            '-preset', 'fast',
            '-fflags', '+nobuffer',
            # '-maxrate', '2000k',
            '-bufsize', '2400k',
            '-pix_fmt', 'yuv420p',
            '-g', '60',
            '-f', 'flv',
            'rtmp://a.rtmp.youtube.com/live2/ujj9-6fa7-9xy9-04w7-09bs'
            # YouTube RTMP URL과 스트림 키 설정 (맨 뒤 슬래시 다음이 스트림 키)
        ]
        ffmpeg_process = subprocess.Popen(ffmpeg_command, stdin=subprocess.PIPE)
        print('FFmpeg 프로세스 시작')

# FFmpeg 프로세스 시작
ffmpeg_process = subprocess.Popen(
    start_ffmpeg_process(),
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE
)

# 비동기로 stderr 읽기
async def read_ffmpeg_logs(process):
    while True:
        output = await process.stderr.readline()
        if output == b'' and process.poll() is not None:
            break
        if output:
            print(output.decode().strip())

# 카메라 초기화
cap = cv2.VideoCapture(0)

# 오디오 입력을 위한 무음 생성 (1초 기준)
audio_sample_rate = 44100
audio_duration = 1
num_samples = audio_sample_rate * audio_duration
silence = np.zeros((num_samples, 2), dtype=np.int16)

async def main():
    # 로그 읽기 시작
    asyncio.create_task(read_ffmpeg_logs(ffmpeg_process))

    try:
        while True:
            ret, frame = cap.read()
            if not ret:
                print("비디오 프레임을 읽을 수 없습니다.")
                break

            ffmpeg_process.stdin.write(frame.tobytes())
            ffmpeg_process.stdin.write(silence.tobytes())

            time.sleep(1/30)

    except KeyboardInterrupt:
        print("스트리밍 중지")
    finally:
        cap.release()
        ffmpeg_process.stdin.close()
        ffmpeg_process.wait()

# 이벤트 루프 실행
if __name__ == "__main__":
    asyncio.run(main())
