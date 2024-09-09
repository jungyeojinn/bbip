// main_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fe/view/components/common/camera_widget.dart';

class FaceRegistrationPage extends StatefulWidget {
  const FaceRegistrationPage({super.key});

  @override
  _FaceRegistrationPageState createState() => _FaceRegistrationPageState();
}

class _FaceRegistrationPageState extends State<FaceRegistrationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection Page'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 40, // 카메라 화면을 위로 올리기 위한 위치 조정
            left: MediaQuery.of(context).size.width * 0.2, // 좌우 중앙 정렬
            child: ClipOval(
              // 원형으로 클리핑
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6, // 가로 크기 설정
                height: MediaQuery.of(context).size.width *
                    0.6, // 높이를 가로 크기와 동일하게 설정하여 원형으로 만듦
                child: AspectRatio(
                  aspectRatio: 1, // 1:1 비율 설정
                  child: CameraWidget(), // 카메라 화면 표시
                ),
              ),
            ),
          ),
          // "얼굴 인식 중입니다..." 문구 추가
          const Positioned(
            bottom: 240, // 화면 아래에서 120픽셀 위로 위치 조정
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