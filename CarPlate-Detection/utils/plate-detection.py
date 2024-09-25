import datetime
import cv2
import numpy as np
from ultralytics import YOLO

# 최소 정확도, 흰색 정의
CONFIDENCE_THRESHOLD = 0.4

def load_model(model_path='../model/best3.pt'):
    """
    YOLO 모델을 로드하는 함수.
    """
    return YOLO(model_path)

def setup_camera(width=640, height=480):
    """

    웹캠을 설정하는 함수.
    """
    cap = cv2.VideoCapture(0)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, width)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, height)
    return cap

def calculate_fps(start_time):
    """
    FPS를 계산하는 함수.
    """
    end_time = datetime.datetime.now()
    total_time = (end_time - start_time).total_seconds()
    return total_time

def process_and_blur_license_plate(frame, xmin, ymin, xmax, ymax):
    """
    회전된 번호판을 블러 처리하는 함수.
    """
    # 번호판 부분만 추출 (ROI)
    # license_plate = frame[ymin:ymax, xmin:xmax].copy()
    license_plate = frame[ymin:ymax, xmin:xmax]


    # 회전된 사각형 감지 및 회전된 사각형의 영역을 블러 처리
    gray = cv2.cvtColor(license_plate, cv2.COLOR_BGR2GRAY)
    _, thresh = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY)

    # 윤곽선 찾기
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if contours:
        # 가장 큰 윤곽선에 대해 회전된 사각형을 찾음
        cnt = max(contours, key=cv2.contourArea)
        rect = cv2.minAreaRect(cnt)
        box = cv2.boxPoints(rect)
        box = np.int0(box)

        # 회전된 번호판 영역을 블러 처리
        mask = np.zeros_like(license_plate)
        cv2.drawContours(mask, [box], 0, (255, 255, 255), -1)  # 번호판 영역을 마스크로 만듦

        # 블러 처리된 이미지
        blurred_license_plate = cv2.GaussianBlur(license_plate, (11, 11), 10)

        # 마스크 영역만 블러 처리된 이미지로 대체
        license_plate = np.where(mask == np.array([255, 255, 255]), blurred_license_plate, license_plate)

        # 블러 처리된 부분을 원본 프레임에 적용
        frame[ymin:ymax, xmin:xmax] = license_plate

    return frame

def main():
    """
    메인 실행 함수: 카메라 설정, YOLO 모델 로드 및 실시간 객체 탐지.
    """
    # 모델 로드
    model = load_model()
    
    # 카메라 설정
    cap = setup_camera()

    # 추적기 리스트
    trackers = []

    frame_count = 0

    while True:
        start_time = datetime.datetime.now()

        ret, frame = cap.read()
        if not ret:
            print('Cam Error')
            break

        frame_count += 1
        
        if frame_count % 20 == 0:  # 20프레임마다 YOLO 모델 호출
            detection = model(frame)[0]
            plate_boxes = []
            trackers = []

            for data in detection.boxes.data.tolist():
                confidence = float(data[4])
                if confidence < CONFIDENCE_THRESHOLD:
                    continue

                xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
                w = xmax - xmin
                h = ymax - ymin
                plate_boxes.append((xmin, ymin, w, h))
            
            # YOLO로 감지된 번호판에 대해 KCF 추적기 추가
            for (xmin, ymin, w, h) in plate_boxes:
                # KCF 추적기를 초기화
                tracker = cv2.TrackerKCF_create()
                trackers.append((tracker, (xmin, ymin, w, h)))
                tracker.init(frame, (xmin, ymin, w, h))
            
        # 추적된 번호판 업데이트
        for i, (tracker, bbox) in enumerate(trackers):
            ret, bbox = tracker.update(frame)
            if ret:
                (xmin, ymin, w, h) = [int(v) for v in bbox]
                xmax = xmin + w
                ymax = ymin + h

                # 회전된 번호판을 블러 처리
                frame = process_and_blur_license_plate(frame, xmin, ymin, xmax, ymax)
            else:
                # 추적 실패 시 해당 추적기 제거
                trackers.pop(i)

        # FPS 계산 및 출력
        total = calculate_fps(start_time)
        fps = f'FPS: {1 / total:.2f}'
        cv2.putText(frame, fps, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (255, 255, 255), 2)

        # 화면에 출력
        cv2.imshow('frame', frame)

        if cv2.waitKey(1) & 0xFF == 27:  # ESC 키를 누르면 종료
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
