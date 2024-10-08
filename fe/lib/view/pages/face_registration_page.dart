import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data'; // Uint8List 사용을 위해 import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  // SecureStorage 객체 생성
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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

  // accessToken을 가져오는 메서드
  Future<String?> _getAccessToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }

  Future<void> _sendFaceToSpringBoot(Uint8List? croppedFaceBytes) async {
    if (croppedFaceBytes == null) {
      print('전송할 이미지가 없습니다.');
      return;
    }

    try {
      // Dio 객체 생성
      dio.Dio dioClient = dio.Dio();

      // SecureStorage에서 accessToken 가져오기
      String? accessToken = await _getAccessToken();

      // 이미지 파일을 dio의 MultipartFile로 변환
      dio.MultipartFile imageFile = dio.MultipartFile.fromBytes(
        croppedFaceBytes,
        filename: 'cropped_face.png',
      );

      // FormData 생성
      dio.FormData formData = dio.FormData.fromMap({
        'image': imageFile,
      });

      // 요청 헤더에 accessToken 추가
      dio.Response response = await dioClient.post(
        'https://j11a203.p.ssafy.io:8080/api/faces', // 서버의 엔드포인트로 변경
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $accessToken', // Authorization 헤더 추가
          },
        ),
      );

      print(response.statusCode);
      Get.offNamed('/main');
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = _cameraController.value.previewSize;
    final aspectRatio = size!.width / size.height;
    final scale = 1 / (aspectRatio * MediaQuery.of(context).size.aspectRatio);
    return Scaffold(
      body: Stack(
        children: [
          // Transform.scale을 이용해 화면에 꽉 차는 카메라 프리뷰
          Transform.scale(
            scale: scale,
            child: Center(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_cameraController);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),

          // 얼굴 맞추기 안내 틀
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 안내 문구
                const Text(
                  '얼굴을 맞춰주세요',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                // 얼굴을 맞추기 위한 사각형 틀
                Container(
                  width: 250, // 원하는 틀의 너비
                  height: 350, // 원하는 틀의 높이
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),

          // 촬영하기 버튼 - 화면 중앙에 위치
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

          // 건너뛰기 버튼 - 화면 하단 오른쪽에 위치
          Positioned(
            bottom: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Get.offNamed('/main');
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
