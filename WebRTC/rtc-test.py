import json
import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from aiortc import RTCPeerConnection, MediaStreamTrack, RTCSessionDescription, RTCIceCandidate
from aiohttp import web
import sockjs
import stomper
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

# SockJS 핸들러 함수
async def sockjs_handler(msg, session):
    print("handler 실행")
    global pc
    if msg.tp == sockjs.MSG_OPEN:
        print("SockJS 연결 열림")
        pc = RTCPeerConnection()  # RTCPeerConnection 객체 생성
        # session.send("SockJS 연결 성공!")  # 연결 성공 메시지 전송

        # 오디오와 비디오 트랙을 추가
        audio_track = DummyAudioTrack()  # Dummy audio track
        video_track = DummyVideoTrack()  # Dummy video track
        
        pc.addTrack(audio_track)  # 오디오 트랙 추가
        pc.addTrack(video_track)  # 비디오 트랙 추가

    elif msg.tp == sockjs.MSG_MESSAGE:
        logging.info(f"수신한 메시지: {msg.data}")
        stomp_message = stomper.unpack_frame(msg.data)
        
        # STOMP CONNECT 처리
        if stomp_message['cmd'] == 'CONNECT':
            print("STOMP 연결 요청 수신, CONNECTED 프레임 전송")

            # STOMP CONNECTED 프레임을 수동으로 작성
            connected_message = "CONNECTED\nversion:1.2\nheart-beat:10000,10000\n\n\x00"

            # CONNECTED 메시지를 클라이언트로 전송 (null 문자로 프레임 종료)
            session.send(connected_message)

        
        # STOMP 핸들러에서 CONNECT 프레임 처리
        # if stomp_message['cmd'] == 'CONNECT':
        #     print("STOMP 연결 요청 수신, CONNECTED 프레임 전송")

        #     # CONNECTED 프레임을 수동으로 생성
        #     connected_message = stomper.Frame('CONNECTED')
        #     connected_message.body = ''
            
        #     # 헤더 추가
        #     connected_message.headers = {
        #         'version': '1.2',
        #         'heart-beat': '10000,10000'
        #     }
            
        #     # CONNECTED 메시지를 클라이언트로 전송
        #     await session.send(connected_message.pack())



        # STOMP SUBSCRIBE 처리
        elif stomp_message['cmd'] == 'SUBSCRIBE':
            print(f"STOMP 구독 요청 수신: {stomp_message}")
            # 여기서 구독을 처리한 후, 나중에 해당 목적지로 메시지를 보낼 수 있습니다.
            # 구독 성공 후, 클라이언트에게 확인 메시지를 보낼 수 있습니다.
            destination = stomp_message['headers'].get('destination')
            if destination == '/sub/client/123':
                print(f"{destination} 구독 성공")
                # session.send(f"SUBSCRIBE 성공: {destination}")
                
                # 구독 성공 메시지를 클라이언트로 전송
                subscribe_success_message = f"SUBSCRIBE\ndestination:{destination}\n\n{json.dumps({'type': 'subscribe', 'data': 'success'})}\x00"
                print(f"서버에서 전송한 STOMP 메시지: {subscribe_success_message}")
                try:
                    session.send(subscribe_success_message)
                    print("메시지가 정상적으로 전송되었습니다.")
                except Exception as e:
                    print(f"메시지 전송 중 오류 발생: {e}")

        elif stomp_message['cmd'] == 'SEND':
            # STOMP SEND 메시지 처리
            print(f"STOMP SEND 요청 수신: {stomp_message}")
            signal = json.loads(stomp_message['body'])

            # offer 신호 처리
            if signal["type"] == "offer":
                print("Offer 수신:", signal["data"])  # Offer 수신 로그 추가
                offer = RTCSessionDescription(sdp=signal["data"]["sdp"], type=signal["data"]["type"])
                await pc.setRemoteDescription(offer)
                # 수신한 offer 메시지 처리 후 답장
                # session.send(f"서버에서 받은 offer 처리 완료: {signal['data']}")

                # Answer 생성 및 전송
                print("Answer 전송")
                answer = await pc.createAnswer()
                await pc.setLocalDescription(answer)

                # stomp_answer = stomper.send(destination=f'/pub/cam/123', body=json.dumps({
                #     "type": "answer",
                #     "data": {
                #         "sdp": pc.localDescription.sdp,
                #         "type": pc.localDescription.type
                #     }
                # }))
                # await websocket.send_text(stomp_answer)

                # STOMP 메시지를 수동으로 작성
                # stomp_answer = f"SEND\ndestination:/sub/cam/123\n\n{json.dumps({'type': 'answer', 'data': {'sdp': pc.localDescription.sdp, 'type': pc.localDescription.type}})}\x00"
                stomp_answer = f"SEND\ndestination:/sub/client/123\n\n{json.dumps({'type': 'answer', 'data': {'sdp': pc.localDescription.sdp, 'type': pc.localDescription.type}})}\x00"
                print(f"서버에서 전송한 STOMP 메시지: {stomp_answer}")  # 서버에서 전송 로그 추가

                # SockJS 세션에 메시지를 전송
                session.send(stomp_answer)

            # ICE 후보 처리

            elif signal["type"] == "candidate":
                print("ICE 후보 데이터: ", signal["data"])

                ice_candidate_data = signal["data"]["data"]

                # 필수 필드가 모두 존재하는지 확인
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

                # ICE Candidate 추가
                await pc.addIceCandidate(candidate)

                session.send(f"서버에서 받은 candidate 처리 완료: {signal['data']}")


                # 필요한 필드가 없는 경우, 기본값을 설정하거나 오류 처리
                # ice_candidate_data = signal["data"]

                # # 예외 처리 추가
                # if "foundation" not in ice_candidate_data:
                #     print("foundation 키가 존재하지 않습니다.")
                #     return

                # # RTCIceCandidate 생성
                # # candidate = RTCIceCandidate(
                # #     foundation=ice_candidate_data["foundation"],
                # #     component=ice_candidate_data.get("component", 1),
                # #     protocol=ice_candidate_data["protocol"],
                # #     priority=ice_candidate_data["priority"],
                # #     ip=ice_candidate_data["ip"],
                # #     port=ice_candidate_data["port"],
                # #     type=ice_candidate_data["type"]
                # # )
                # # await pc.addIceCandidate(candidate)

                # candidate = RTCIceCandidate(sdpMid=ice_candidate_data["sdpMid"],
                #                             sdpMLineIndex=ice_candidate_data["sdpMLineIndex"],
                #                             candidate=ice_candidate_data["candidate"])
                # await pc.addIceCandidate(candidate)

                # ICE 후보 처리
                # if signal["type"] == "candidate":
                #     ice_candidate_data = signal["data"]

                #     # 필수 필드가 모두 존재하는지 확인 후 기본값을 설정
                #     candidate = RTCIceCandidate(
                #         foundation=ice_candidate_data.get("foundation", "default"),
                #         component=ice_candidate_data.get("component", 1),  # 기본값 설정
                #         priority=ice_candidate_data.get("priority", 1),
                #         protocol=ice_candidate_data.get("protocol", "udp"),
                #         ip=ice_candidate_data.get("address"),  # 콘솔에 찍힌 데이터에서 "ip" 대신 "address" 사용
                #         port=ice_candidate_data.get("port", 9),
                #         type=ice_candidate_data.get("type", "host"),
                #         tcpType=ice_candidate_data.get("tcpType", None),  # tcpType 필드 추가
                #     )
                    
                #     # ICE Candidate 추가
                #     await pc.addIceCandidate(candidate)



    elif msg.tp == sockjs.MSG_CLOSE:
        print("SockJS 연결 닫힘")
        pc = None  # 연결 닫힘 시 RTCPeerConnection 초기화

# aiohttp 앱 생성
aio_app = web.Application()

# SockJS 라우트 추가
sockjs_mgr = sockjs.add_endpoint(aio_app, sockjs_handler, name='sockjs', prefix='/ws')

# FastAPI와 aiohttp 통합: FastAPI가 시작할 때 aiohttp 서버도 함께 시작
@app.on_event("startup")
async def startup_event():
    runner = web.AppRunner(aio_app)
    await runner.setup()
    site = web.TCPSite(runner, '0.0.0.0', 8081)  # aiohttp 서버는 8080 포트에서 실행
    await site.start()

# FastAPI 시작
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)  # FastAPI는 8000 포트에서 실행
