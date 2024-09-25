# from ultralytics import YOLO

# # YOLOv8 모델 로드 (가장 작은 모델인 yolov8n을 사용)
# model = YOLO('yolov8n.pt')

# # 모델 학습
# model.train(data='widerface.yaml', epochs=61, imgsz=640)

# -------------------------------------------

from ultralytics import YOLO

if __name__ == "__main__":
    model = YOLO('yolov8n.pt')
    model.train(data='widerface.yaml', epochs=61, imgsz=640)
