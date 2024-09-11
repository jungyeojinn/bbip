import datetime
import cv2
import numpy as np
from ultralytics import YOLO

# 최소 정확도, 녹색과 흰색 정의
CONFIDENCE_THRESHOLD = 0.6
GREEN = (0, 255, 0)
WHITE = (255, 255, 255)

def load_model(model_path='../model/best.pt'):
    """
    YOLO 모델을 로드하는 함수.
    
    :param model_path: 사용할 YOLO 모델의 경로
    :return: 로드된 YOLO 모델
    """
    return YOLO(model_path)

def setup_camera(width=640, height=480):
    """
    웹캠을 설정하는 함수.
    
    :param width: 카메라의 가로 해상도
    :param height: 카메라의 세로 해상도
    :return: 설정된 웹캠 객체
    """
    cap = cv2.VideoCapture(0)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, width)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, height)
    return cap

def process_frame(frame, model):
    """
    웹캠에서 받은 프레임을 YOLO 모델로 처리하고 객체를 탐지하는 함수.
    
    :param frame: 현재 웹캠 프레임
    :param model: YOLO 모델
    :return: 블러 처리된 프레임
    """
    detection = model(frame)[0]

    for data in detection.boxes.data.tolist():
        confidence = float(data[4])
        if confidence < CONFIDENCE_THRESHOLD:
            continue

        # 얼굴의 네모 박스 좌표
        xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
        
        # 얼굴의 중심 좌표 및 반지름 계산
        x_center = (xmin + xmax) // 2
        y_center = (ymin + ymax) // 2
        radius = min((xmax - xmin), (ymax - ymin)) // 2

        # 원형 마스크 생성
        mask = np.zeros_like(frame, dtype=np.uint8)
        cv2.circle(mask, (x_center, y_center), radius+18, (255, 255, 255), -1)

        # 원 안에만 블러 처리
        face_region = cv2.GaussianBlur(frame, (51, 51), 30)
        frame = np.where(mask == (255, 255, 255), face_region, frame)

        # 원형 마스크를 표시 (필요시 활성화)
        # cv2.circle(frame, (x_center, y_center), radius, GREEN, 2)

    return frame

def calculate_fps(start_time):
    """
    FPS를 계산하는 함수.
    
    :param start_time: 프레임 처리 시작 시간
    :return: FPS 값
    """
    end_time = datetime.datetime.now()
    total_time = (end_time - start_time).total_seconds()
    
    print("프레임 처리시간: ", f"{total_time*1000:.2f}", "ms")

    return 1 / total_time

def main():
    """
    메인 실행 함수: 카메라 설정, YOLO 모델 로드 및 실시간 객체 탐지.
    """
    # 모델 로드
    model = load_model()
    
    # 카메라 설정
    cap = setup_camera()

    while True:
        start_time = datetime.datetime.now()

        ret, frame = cap.read()
        if not ret:
            print('Cam Error')
            break

        # 프레임을 YOLO로 처리
        frame = process_frame(frame, model)

        # FPS 계산 및 출력 (필요시 활성화)
        fps = calculate_fps(start_time)
        # cv2.putText(frame, f'FPS: {fps:.2f}', (10, 20), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 2)
        
        print("FPS: ", f"{fps:.2f}")


        # 화면에 출력
        cv2.imshow('frame', frame)

        if cv2.waitKey(1) & 0xFF == 27:  # ESC 키를 누르면 종료
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
