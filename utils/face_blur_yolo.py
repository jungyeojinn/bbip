import datetime
import cv2
from ultralytics import YOLO

# 최소 정확도, 녹색과 흰색 정의
CONFIDENCE_THRESHOLD = 0.6
GREEN = (0, 255, 0)
WHITE = (255, 255, 255)

def load_model(model_path='../model/facedetection_yolo.pt'):
    """
    YOLO 모델을 로드하는 함수.
    
    :param model_path: 사용할 YOLO 모델의 경로
    :return: 로드된 YOLO 모델
    """
    return YOLO(model_path)

def process_frame(frame, model):
    """
    웹캠에서 받은 프레임을 YOLO 모델로 처리하고 객체를 탐지하는 함수.
    
    :param frame: 현재 웹캠 프레임
    :param model: YOLO 모델
    :return: 객체가 탐지된 프레임
    """
    detection = model(frame)[0]

    for data in detection.boxes.data.tolist():
        confidence = float(data[4])
        if confidence < CONFIDENCE_THRESHOLD:
            continue

        xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
        # cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), GREEN, 2)
        # 얼굴 부분을 블러 처리
        face_region = frame[ymin:ymax, xmin:xmax]
        blurred_face = cv2.GaussianBlur(face_region, (51, 51), 20)
        frame[ymin:ymax, xmin:xmax] = blurred_face
        
    return frame

def calculate_fps(start_time):
    """
    FPS를 계산하는 함수.
    
    :param start_time: 프레임 처리 시작 시간
    :return: FPS 값
    """
    end_time = datetime.datetime.now()
    total_time = (end_time - start_time).total_seconds()
    return 1 / total_time