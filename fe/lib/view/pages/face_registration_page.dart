import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data'; // Uint8List 사용을 위해 import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart' as dio;

import 'package:fe/controller/face_controller.dart';
import 'package:fe/view/pages/preview_page.dart';

class FaceRegistrationPage extends StatefulWidget {
  const FaceRegistrationPage({super.key});

  @override
  FaceRegistrationPageState createState() => FaceRegistrationPageState();
}

class FaceRegistrationPageState extends State<FaceRegistrationPage> {
  late final FaceDetector _faceDetector;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  final FaceController _faceController = Get.put(FaceController());

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
    _initializeControllerFuture = _initializeCamera();
  }

  @override
  void dispose() {
    _faceDetector.close();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[1],
      ResolutionPreset.medium,
    );
    await _cameraController.initialize();
    setState(() {});
  }

  Future<void> _captureAndProcessImage() async {
    try {
      final XFile capturedImage = await _cameraController.takePicture();
      print('이미지 캡처 성공: ${capturedImage.path}');

      final inputImage = InputImage.fromFilePath(capturedImage.path);
      final face = await _detectFace(inputImage);

      if (face != null) {
        print('얼굴을 성공적으로 찾았습니다.');
        final croppedFaceBytes =
            await _cropFace(capturedImage.path, face.boundingBox);
        if (croppedFaceBytes != null) {
          print('얼굴 이미지를 성공적으로 크롭했습니다.');
          _faceController.setCroppedFace(croppedFaceBytes);

          final retake = await Get.to(() => PreviewPage(
                onSave: _sendFaceToSpringBoot,
              ));

          if (retake == true) {
            _faceController.clearCroppedFace();
          }
        } else {
          print('얼굴 이미지를 크롭하는 데 실패했습니다.');
        }
      } else {
        print('얼굴을 찾을 수 없습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  Future<Face?> _detectFace(InputImage image) async {
    final List<Face> faces = await _faceDetector.processImage(image);
    if (faces.isNotEmpty) {
      return faces.first;
    }
    return null;
  }

  Future<Uint8List?> _cropFace(String imagePath, Rect faceRect) async {
    final imageBytes = await File(imagePath).readAsBytes();
    final originalImage = await decodeImageFromList(imageBytes);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, faceRect);
    final paint = Paint();

    canvas.drawImageRect(
      originalImage,
      faceRect,
      Rect.fromLTWH(0, 0, faceRect.width, faceRect.height),
      paint,
    );

    final croppedImage = await recorder.endRecording().toImage(
          faceRect.width.toInt(),
          faceRect.height.toInt(),
        );

    final byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _sendFaceToSpringBoot(Uint8List? croppedFaceBytes) async {
    if (croppedFaceBytes == null) {
      print('전송할 이미지가 없습니다.');
      return;
    }

    try {
      // Dio 객체 생성
      dio.Dio dioClient = dio.Dio();

      // 이미지 파일을 dio의 MultipartFile로 변환
      dio.MultipartFile imageFile = dio.MultipartFile.fromBytes(
        croppedFaceBytes,
        filename: 'cropped_face.png',
      );

      // FormData 생성
      dio.FormData formData = dio.FormData.fromMap({
        'image': imageFile,
      });

      // 서버로 POST 요청 보내기
      dio.Response response = await dioClient.post(
        'http://your-spring-boot-server-url/upload', // 서버의 엔드포인트로 변경
        data: formData,
      );

      // 응답 처리
      if (response.statusCode == 200) {
        print('이미지 업로드 성공: ${response.data}');
      } else {
        print('이미지 업로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _captureAndProcessImage,
                child: const Text('촬영하기'),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/main');
              },
              child: const Text(
                '건너뛰기 ->',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
