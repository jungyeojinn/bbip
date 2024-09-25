import datetime
import cv2
import numpy as np
import base64
from fastapi import FastAPI, WebSocket
from ultralytics import YOLO
from pydantic import BaseModel
import io
from PIL import Image
import uvicorn

app = FastAPI()

# YOLO 모델 로드
model = YOLO('../model/best3.pt')

# 최소 정확도 정의
CONFIDENCE_THRESHOLD = 0.4

def process_and_blur_license_plate(frame, xmin, ymin, xmax, ymax):
    """
    회전된 번호판을 블러 처리하는 함수.
    """
    license_plate = frame[ymin:ymax, xmin:xmax].copy()

    gray = cv2.cvtColor(license_plate, cv2.COLOR_BGR2GRAY)
    _, thresh = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY)

    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if contours:
        cnt = max(contours, key=cv2.contourArea)
        rect = cv2.minAreaRect(cnt)
        box = cv2.boxPoints(rect)
        box = np.int0(box)

        mask = np.zeros_like(license_plate)
        cv2.drawContours(mask, [box], 0, (255, 255, 255), -1)

        blurred_license_plate = cv2.GaussianBlur(license_plate, (11, 11), 10)

        license_plate = np.where(mask == np.array([255, 255, 255]), blurred_license_plate, license_plate)

        frame[ymin:ymax, xmin:xmax] = license_plate

    return frame

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

        if frame_count % 20 == 0:  # 20프레임마다 YOLO 모델 호출
            detection = model(img)[0]
            plate_boxes = []

            for data in detection.boxes.data.tolist():
                confidence = float(data[4])
                if confidence < CONFIDENCE_THRESHOLD:
                    continue

                xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
                plate_boxes.append((xmin, ymin, xmax, ymax))
            
            for (xmin, ymin, xmax, ymax) in plate_boxes:
                img = process_and_blur_license_plate(img, xmin, ymin, xmax, ymax)
        
        # 처리된 이미지를 base64로 인코딩
        _, img_encoded = cv2.imencode('.jpg', img)
        img_base64 = base64.b64encode(img_encoded.tobytes()).decode('utf-8')

        # 클라이언트로 전송
        await websocket.send_text(img_base64)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
