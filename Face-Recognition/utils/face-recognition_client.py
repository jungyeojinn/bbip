import datetime
import cv2
import numpy as np
from fastapi import FastAPI, WebSocket
from tensorflow.keras.models import load_model
from ultralytics import YOLO
from pydantic import BaseModel
import base64
import io
from PIL import Image
import uvicorn

app = FastAPI()

# FaceNet 모델 로드
facenet_model = load_model('../model/facenet_keras.h5')

# YOLO 모델 설정
model = YOLO('../model/best.pt')

# 등록된 얼굴 임베딩과 이름을 저장하는 리스트 초기화
known_face_embeddings = []
known_face_names = []

# 얼굴 임베딩(벡터)을 추출하는 함수
def get_face_embedding(model, face_pixels):
    face_pixels = cv2.resize(face_pixels, (160, 160))  # FaceNet 입력 크기로 맞춤
    face_pixels = face_pixels.astype('float32')
    mean, std = face_pixels.mean(), face_pixels.std()
    if std == 0:  # 표준편차가 0인 경우 예외 처리
        std = 1e-6
    face_pixels = (face_pixels - mean) / std
    face_pixels = np.expand_dims(face_pixels, axis=0)
    embedding = model.predict(face_pixels)
    return embedding[0]

# 얼굴 임베딩을 비교하는 함수 (L2 거리 사용)
def is_match(known_embedding, candidate_embedding, threshold=8.5):
    distance = np.linalg.norm(known_embedding - candidate_embedding)
    return distance < threshold

# 얼굴 등록 함수
def register_face(face_image, name):
    face_embedding = get_face_embedding(facenet_model, face_image)
    known_face_embeddings.append(face_embedding)
    known_face_names.append(name)
    print(f'{name} 등록 완료')

# 특정 얼굴 등록 (이미지를 파일에서 불러오는 경우)
image = cv2.imread('../img/myl.jpg')
register_face(image, 'yelim')

# 추적기 리스트
trackers = []
tracker_faces = []

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    frame_count = 0

    while True:
        # 클라이언트에서 프레임 수신
        data = await websocket.receive_text()

        # base64로 인코딩된 이미지 데이터를 디코딩
        img_bytes = base64.b64decode(data)
        img = np.array(Image.open(io.BytesIO(img_bytes)))

        frame_count += 1

        if frame_count % 20 == 0 or len(trackers) == 0:
            detection = model(img)[0]
            face_boxes = []
            trackers = []
            tracker_faces = []

            for data in detection.boxes.data.tolist():
                confidence = float(data[4])
                if confidence < 0.6:
                    continue

                xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
                w = xmax - xmin
                h = ymax - ymin
                face_boxes.append((xmin, ymin, w, h))

            # YOLO로 감지된 얼굴에 대해 KCF 추적기 추가
            for (xmin, ymin, w, h) in face_boxes:
                tracker = cv2.TrackerKCF_create()
                trackers.append((tracker, (xmin, ymin, w, h)))
                tracker.init(img, (xmin, ymin, w, h))

                # 추적된 얼굴 부분을 잘라내서 얼굴 인식 수행
                face_region = img[ymin:ymin+h, xmin:xmin+w]
                if face_region.size > 0:
                    face_embedding = get_face_embedding(facenet_model, face_region)
                    match_found = False
                    name = "Unknown"
                    for i, known_embedding in enumerate(known_face_embeddings):
                        if is_match(known_embedding, face_embedding):
                            match_found = True
                            name = known_face_names[i]
                            break
                    tracker_faces.append(name)
                else:
                    tracker_faces.append("Unknown")

        # 추적된 얼굴들 업데이트
        for i, (tracker, bbox) in enumerate(trackers):
            ret, bbox = tracker.update(img)
            if ret:
                (xmin, ymin, w, h) = [int(v) for v in bbox]
                xmax = xmin + w
                ymax = ymin + h
                face_region = img[ymin:ymax, xmin:xmax]

                # 매칭된 이름 가져오기
                name = tracker_faces[i] if i < len(tracker_faces) else "Unknown"

                # 이름 표시
                cv2.putText(img, name, (xmin, ymin - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)

                if name == "Unknown":
                    # # 얼굴 부분 블러 처리
                    # if face_region.size > 0:
                    #     blur_face = cv2.GaussianBlur(face_region, (51, 51), 20)
                    #     img[ymin:ymax, xmin:xmax] = blur_face
                    # 얼굴 부분을 원형으로 블러 처리
                    if face_region.size > 0:
                        mask = np.zeros_like(frame)
                        center = (xmin + w // 2, ymin + h // 2)
                        radius = int(min(w, h) / 2)
                        cv2.circle(mask, center, radius+10, (255, 255, 255), -1)

                        # 블러 처리된 이미지를 생성하고 원형 마스크를 적용하여 블러 처리
                        blurred_frame = cv2.GaussianBlur(frame, (11, 11), 20)
                        frame = np.where(mask == (255, 255, 255), blurred_frame, frame)
                else:
                    # 등록된 얼굴은 블러 해제 (아무 처리도 하지 않음)
                    pass

            else:
                # 추적 실패 시 해당 추적기 제거
                trackers.pop(i)
                tracker_faces.pop(i)

        # 처리된 이미지를 base64로 인코딩
        _, img_encoded = cv2.imencode('.jpg', img)
        img_base64 = base64.b64encode(img_encoded.tobytes()).decode('utf-8')

        # 클라이언트로 전송
        await websocket.send_text(img_base64)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
