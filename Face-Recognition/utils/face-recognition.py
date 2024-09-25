import datetime
import cv2
import numpy as np
from tensorflow.keras.models import load_model
from ultralytics import YOLO

# FaceNet 모델 로드 (GPU 사용)
facenet_model = load_model('../model/facenet_keras.h5')

# YOLO 모델 설정 (더 가벼운 YOLO 모델 사용)
model = YOLO('../model/best.pt')

# 등록된 얼굴 임베딩과 이름을 저장하는 리스트 초기화
known_face_embeddings = []
known_face_names = []

# 웹캠 설정 (더 작은 해상도로 설정)
cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 320)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)

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
def is_match(known_embedding, candidate_embedding, threshold=8.5):  # 임계값 조정 가능
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
tracker_faces = []  # 각 추적기와 얼굴의 인식 결과를 저장하는 리스트

# 실시간 얼굴 감지 및 처리
frame_count = 0  # 프레임 카운터

while True:
    start = datetime.datetime.now()
    ret, frame = cap.read()
    if not ret:
        print('Cam Error')
        break

    frame_count += 1

    # 일정 프레임마다 YOLO를 실행하여 새로운 얼굴을 감지
    if frame_count % 20 == 0 or len(trackers) == 0:
        detection = model(frame)[0]
        face_boxes = []
        trackers = []
        tracker_faces = []
        for data in detection.boxes.data.tolist():
            confidence = float(data[4])
            if confidence < 0.6:  # 최소 신뢰도
                continue

            xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
            w = xmax - xmin
            h = ymax - ymin
            face_boxes.append((xmin, ymin, w, h))

        # YOLO로 감지된 얼굴에 대해 KCF 추적기 추가
        for (xmin, ymin, w, h) in face_boxes:
            tracker = cv2.TrackerKCF_create()  # 최신 OpenCV 버전에서 사용
            trackers.append((tracker, (xmin, ymin, w, h)))
            tracker.init(frame, (xmin, ymin, w, h))
            # 추적된 얼굴 부분을 잘라내서 얼굴 인식 수행
            face_region = frame[ymin:ymin+h, xmin:xmin+w]
            if face_region.size > 0:
                face_embedding = get_face_embedding(facenet_model, face_region)
                match_found = False
                name = "Unknown"
                for i, known_embedding in enumerate(known_face_embeddings):
                    if is_match(known_embedding, face_embedding):
                        match_found = True
                        name = known_face_names[i]
                        break
                tracker_faces.append(name)  # 추적기와 매칭된 이름을 저장
            else:
                tracker_faces.append("Unknown")  # 얼굴이 감지되지 않으면 기본값 추가

    # 추적된 얼굴들 업데이트
    for i, (tracker, bbox) in enumerate(trackers):
        ret, bbox = tracker.update(frame)
        if ret:
            (xmin, ymin, w, h) = [int(v) for v in bbox]
            xmax = xmin + w
            ymax = ymin + h
            face_region = frame[ymin:ymax, xmin:xmax]

            # 매칭된 이름 가져오기
            name = tracker_faces[i] if i < len(tracker_faces) else "Unknown"
            # 이름 표시
            cv2.putText(frame, name, (xmin, ymin - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)

            if name == "Unknown":
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

    end = datetime.datetime.now()
    total = (end - start).total_seconds()
    fps = f'FPS: {1 / total:.2f}'
    cv2.putText(frame, fps, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (255, 255, 255), 2)

    cv2.imshow('frame', frame)

    if cv2.waitKey(1) & 0xFF == 27:  # ESC 키로 종료
        break

cap.release()
cv2.destroyAllWindows()
