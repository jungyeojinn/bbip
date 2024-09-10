import datetime
import cv2
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

        # 화면에 출력
        cv2.imshow('frame', frame)

        if cv2.waitKey(1) & 0xFF == 27:  # ESC 키를 누르면 종료
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
