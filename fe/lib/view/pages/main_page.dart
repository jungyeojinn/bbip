import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fe/view/components/common/camera_widget.dart';
import 'package:fe/view/components/main_page/camera_menu_widget.dart';
import 'package:fe/view/components/main_page/bottom_ui_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  String selectedMode = 'Live';
  bool isVideoRecording = false;
  int cameraIndex = 0;

  void updateMode(String mode) {
    setState(() {
      selectedMode = mode;
      if (mode == 'Video') {
        isVideoRecording = false;
      }
    });
  }

  void toggleCamera() {
    setState(() {
      cameraIndex = (cameraIndex == 0) ? 1 : 0;
    });
  }

  // 녹화 상태 변경 함수 추가
  void toggleVideoRecording() {
    setState(() {
      isVideoRecording = !isVideoRecording;
    });
  }

  // _goLive 메서드 MainPage에 정의
  Future<void> _goLive(BuildContext context) async {
    Get.toNamed('/live');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraWidget(cameraIndex: cameraIndex),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              onPressed: toggleCamera,
              icon: const Icon(
                Icons.cached,
                color: Colors.white,
                size: 32.0,
              ),
            ),
          ),
          if (!isVideoRecording)
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

          // 녹화 중이 아닐 때만 CameraMenuWidget 보이게 설정
          if (!isVideoRecording)
            Positioned(
              bottom: 30.0,
              left: 0,
              right: 0,
              child: Center(
                child: CameraMenuWidget(onModeChanged: updateMode),
              ),
            ),
          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Center(
              child: BottomUiWidget(
                selectedMode: selectedMode,
                isVideoRecording: isVideoRecording, // 상태 전달
                onRecordPressed: toggleVideoRecording, // 녹화 상태 변경
                onGoLivePressed: () => _goLive(context), // Go Live 콜백 전달
              ),
            ),
          ),
        ],
      ),
    );
  }
}
