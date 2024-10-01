import json
import logging
from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from aiortc import RTCPeerConnection, MediaStreamTrack, RTCSessionDescription, RTCIceCandidate
import uvicorn
import cv2
from ultralytics import YOLO

# FastAPI 앱 생성
app = FastAPI()

print("실행 중")

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 정적 파일 제공
app.mount("/static", StaticFiles(directory="static"), name="static")

# YOLO 모델 로드 (얼굴 블러 처리용)
model = YOLO('../model/best.pt')

# 얼굴을 블러 처리하는 함수
def process_frame(frame):
    detection = model(frame)[0]
    CONFIDENCE_THRESHOLD = 0.6

    for data in detection.boxes.data.tolist():
        confidence = float(data[4])
        if confidence < CONFIDENCE_THRESHOLD:
            continue

        xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
        face_region = frame[ymin:ymax, xmin:xmax]
        blurred_face = cv2.GaussianBlur(face_region, (51, 51), 20)
        frame[ymin:ymax, xmin:xmax] = blurred_face

    return frame

# 서버에서 사용할 Dummy Video Track
class DummyVideoTrack(MediaStreamTrack):
    kind = "video"

    async def recv(self):
        await asyncio.sleep(1/30)  # 30fps 대기
        # 여기에 실제로 비디오 프레임 데이터를 넣어 전송
        return None  # 여기에 프레임 데이터를 넣습니다.

class DummyAudioTrack(MediaStreamTrack):
    kind = "audio"

    async def recv(self):
        await asyncio.sleep(1/30)  # 30fps 대기
        # 여기에 실제로 오디오 데이터를 넣어 전송
        return None  # 여기에 오디오 데이터를 넣습니다.


# 전역 RTCPeerConnection 객체 생성
pc = None

# WebSocket 핸들러
@app.websocket("/sub/cam/123")
async def websocket_endpoint(websocket: WebSocket):
    print("WebSocket 연결 중...")
    await websocket.accept()
    global pc

    try:
        while True:
            message = await websocket.receive_text()
            signal = json.loads(message)
            print(f"수신한 메시지: {signal}")

            # STOMP 구독이나 연결 같은 개념은 없으므로 바로 offer와 candidate를 처리
            if signal["type"] == "offer":
                print("Offer 수신:", signal["data"])
                offer = RTCSessionDescription(sdp=signal["data"]["sdp"], type=signal["data"]["type"])
                if pc is None:
                    pc = RTCPeerConnection()
                    audio_track = DummyAudioTrack()
                    video_track = DummyVideoTrack()
                    pc.addTrack(audio_track)
                    pc.addTrack(video_track)
                await pc.setRemoteDescription(offer)

                # Answer 생성 후 전송
                answer = await pc.createAnswer()
                await pc.setLocalDescription(answer)

                await websocket.send_text(json.dumps({
                    "type": "answer",
                    "data": {
                        "sdp": pc.localDescription.sdp,
                        "type": pc.localDescription.type
                    }
                }))

            # ICE 후보 처리
            elif signal["type"] == "candidate":
                print("ICE 후보 데이터: ", signal["data"])
                ice_candidate_data = signal["data"]
                candidate = RTCIceCandidate(
                    foundation=ice_candidate_data.get("foundation"),
                    component=ice_candidate_data.get("component"),
                    protocol=ice_candidate_data.get("protocol"),
                    priority=ice_candidate_data.get("priority"),
                    ip=ice_candidate_data.get("ip"),
                    port=ice_candidate_data.get("port"),
                    type=ice_candidate_data.get("type"),
                    sdpMid=ice_candidate_data.get("sdpMid"),
                    sdpMLineIndex=ice_candidate_data.get("sdpMLineIndex"),
                    tcpType=ice_candidate_data.get("tcpType")
                )
                await pc.addIceCandidate(candidate)
                await websocket.send_text("ICE 후보 추가 완료")

    except Exception as e:
        print(f"에러 발생: {e}")
    finally:
        print("WebSocket 연결 종료")
        await websocket.close()

# FastAPI 시작
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)  # FastAPI는 8000 포트에서 실행
