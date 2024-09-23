// main_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fe/view/components/common/camera_widget.dart';

class FaceRegistrationPage extends StatefulWidget {
  const FaceRegistrationPage({super.key});

  @override
  FaceRegistrationPageState createState() => FaceRegistrationPageState();
}

class FaceRegistrationPageState extends State<FaceRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5, // 화면의 50% 높이
              decoration: BoxDecoration(
                color: Colors.black, // 카메라 배경색
              ),
              child: ClipRRect(
                child: CameraWidget(cameraIndex: 0), // 카메라 화면 표시
              ),
            ),
          ),
          // "얼굴 인식 중입니다..." 문구 추가
          const Positioned(
            bottom: 240, // 화면 아래에서 240픽셀 위로 위치 조정
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '얼굴 등록 중입니다...',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50, // 화면 아래에서 50픽셀 위로 위치 조정
            right: 20, // 오른쪽으로 20픽셀 간격
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/main'); // '/main'으로 이동
              },
              child: const Text(
                '건너뛰기 ->',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue, // 텍스트 색상
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
