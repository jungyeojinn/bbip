import argparse
import asyncio
import json
import logging
import os
import subprocess
import uuid
from fastapi.responses import HTMLResponse
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from aiortc import MediaStreamTrack, RTCPeerConnection, RTCSessionDescription
from av import VideoFrame
from fastapi import APIRouter
from utils import face_blur_yolo as yolo
import collections
from ultralytics import YOLO


router = APIRouter()

# 기본 설정
ROOT = os.path.dirname(__file__)
logger = logging.getLogger("pc")
pcs = set()

# 전역 FFmpeg 프로세스
ffmpeg_process = None

# 버퍼 크기 설정
VIDEO_BUFFER_SIZE = 60  # 비디오 버퍼에 저장할 프레임 수
AUDIO_BUFFER_SIZE = 60  # 오디오 버퍼에 저장할 샘플 수

# 버퍼 초기화
video_buffer = collections.deque(maxlen=VIDEO_BUFFER_SIZE)
audio_buffer = collections.deque(maxlen=AUDIO_BUFFER_SIZE)

model = YOLO('../model/facedetection_yolo.pt')

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
        
        #print('FFmpeg 프로세스 시작')
        asyncio.create_task(log_ffmpeg_output(ffmpeg_process))

async def log_ffmpeg_output(process):
    while True:
        output = await process.stderr.read(100)
        if not output:
            break
       # print(output.decode())

async def send_to_ffmpeg():
    global ffmpeg_process
    while ffmpeg_process:
        await asyncio.sleep(0.1)  # 0.1초 간격으로 확인
        #print(f"Video buffer size: {len(video_buffer)}")  # 버퍼사이즈 확인
        #print(f"Audio buffer size: {len(audio_buffer)}") 
        # 비디오 데이터 전송
        while video_buffer:
            frame = video_buffer.popleft()
            ffmpeg_process.stdin.write(frame.tobytes())
            await ffmpeg_process.stdin.drain()

        # 오디오 데이터 전송
        while audio_buffer:
            frame = audio_buffer.popleft()
            ffmpeg_process.stdin.write(frame.tobytes())
            await ffmpeg_process.stdin.drain()

        #print("FFmpeg에 데이터 전송 중...")
        
        if ffmpeg_process.returncode is not None:
            #print('FFmpeg 프로세스가 종료되었습니다.')
            break

class MediaTransformTrack(MediaStreamTrack):
    global model

    def __init__(self, track, kind):
        super().__init__()
        self.track = track
        self.kind = kind

        # FFmpeg 프로세스 시작
        asyncio.create_task(start_ffmpeg_process())

    async def recv(self):
        frame = await self.track.recv()
        
        if self.kind == "video":
            img = frame.to_ndarray(format="bgr24")
            img = yolo.process_frame(img, model)

            # 버퍼에 비디오 프레임 추가
            video_buffer.append(img)

            new_frame = VideoFrame.from_ndarray(img, format="bgr24")
            new_frame.pts = frame.pts
            new_frame.time_base = frame.time_base
            return new_frame

        elif self.kind == "audio":
            audio_data = frame.to_ndarray()
            audio_buffer.append(audio_data)

            return frame

    def __del__(self):
        # FFmpeg 프로세스 종료
        global ffmpeg_process
        
        if ffmpeg_process:
            ffmpeg_process.stdin.close()
            ffmpeg_process.wait()
            ffmpeg_process = None

@router.get("/", response_class=HTMLResponse)
async def index():
    with open(os.path.join(ROOT, "..\\static\\index.html"), encoding='utf-8') as f:
        return f.read()

@router.post("/offer")
async def offer(offer: RTCSessionDescription):
    logging.info("offer 요청 수신")
    pc = RTCPeerConnection()
    pcs.add(pc)

    await pc.setRemoteDescription(offer)
    answer = await pc.createAnswer()
    await pc.setLocalDescription(answer)

    # FFmpeg 전송 시작
    asyncio.create_task(send_to_ffmpeg())

    return {
        "sdp": pc.localDescription.sdp,
        "type": pc.localDescription.type
    }

@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    logging.info("ws 요청")
    await websocket.accept()
    client_id = str(uuid.uuid4())
    await websocket.send_text(json.dumps({"client_id": client_id}))

    pc = RTCPeerConnection()
    pcs.add(pc)

    @pc.on("icecandidate")
    async def on_icecandidate(event):
        logging.info("candidate")
        if event.candidate:
            await websocket.send_text(json.dumps({"candidate": event.candidate.to_json()}))

    @pc.on("track")
    def on_track(track):
        logging.info(f"트랙 수신: {track.kind}")
        if track.kind == "video":
            pc.addTrack(MediaTransformTrack(track, 'video'))
        elif track.kind == "audio":
            pc.addTrack(MediaTransformTrack(track, 'audio'))

    # FFmpeg 전송 시작
    asyncio.create_task(send_to_ffmpeg())

    while True:
        try:
            data = await websocket.receive_text()
            message = json.loads(data)

            if "sdp" in message:
                sdp = message["sdp"]
                if isinstance(sdp, str):
                    await pc.setRemoteDescription(RTCSessionDescription(sdp=sdp, type=message["type"]))
                    
                    answer = await pc.createAnswer()
                    await pc.setLocalDescription(answer)
                    
                    await websocket.send_text(json.dumps({"sdp": pc.localDescription.sdp, "type": pc.localDescription.type}))

        except WebSocketDisconnect:
            print(f"Client disconnected: {client_id}")
            pcs.remove(pc)
            break
        except Exception as e:
            logging.INFO(f"An error occurred: {e}")