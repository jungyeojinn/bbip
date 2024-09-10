// main_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fe/view/pages/second_page.dart';
import 'package:fe/view/components/main_page/camera_menu_widget.dart';
import 'package:fe/view/components/common/camera_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  String selectedMode = 'Live'; // 기본 모드를 Live로 설정
  bool isVideoRecording = false; // Video 모드 상태를 관리
  int cameraIndex = 0; // 추가: 현재 선택된 카메라 인덱스 (0: 후면, 1: 전면)

  void updateMode(String mode) {
    setState(() {
      selectedMode = mode;
      if (mode == 'Video') {
        isVideoRecording = false; // Video 모드로 돌아오면 초기화
      }
    });
  }

  void toggleCamera() {
    setState(() {
      cameraIndex = (cameraIndex == 0) ? 1 : 0; // 카메라 인덱스를 토글
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraWidget(cameraIndex: cameraIndex), // 변경: 카메라 인덱스를 전달
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              onPressed: toggleCamera, // 카메라 전환 기능 추가
              icon: const Icon(
                Icons.cached,
                color: Colors.white,
                size: 32.0,
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: IconButton(
              onPressed: () {
                Get.toNamed('/my');
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                size: 40.0,
              ),
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 0,
            right: 0,
            child: Center(
              child: CameraMenuWidget(
                onModeChanged: updateMode, // 모드 변경 시 호출할 함수
              ),
            ),
          ),
          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Center(
              child: _buildModeSpecificUI(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSpecificUI() {
    switch (selectedMode) {
      case 'Live':
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            textStyle: const TextStyle(fontSize: 20.0),
          ),
          child: const Text('Go Live'),
        );
      case 'Video':
        return IconButton(
          icon: Icon(
            isVideoRecording
                ? Icons.stop_circle_outlined // 녹화 중이면 stop circle 아이콘
                : Icons
                    .radio_button_checked, // 녹화 중이 아니면 Radio Button checked 아이콘
            color: Colors.white,
            size: 60.0,
          ),
          onPressed: () {
            setState(() {
              isVideoRecording = !isVideoRecording; // 버튼 터치할 때마다 아이콘 변경
            });
          },
        );
      case 'Photo':
        return IconButton(
          icon: const Icon(
            Icons.radio_button_unchecked,
            color: Colors.white,
            size: 60.0,
          ),
          onPressed: () {},
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
