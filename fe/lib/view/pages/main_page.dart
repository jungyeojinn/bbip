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
              icon: Image.asset(
                'assets/rotate-button.png',
                width: 32.0,
                height: 32.0,
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
                icon: Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // 테두리 색상
                      width: 1.0, // 테두리 두께
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      // 나중에 본인이 등록한 이미지를 보여줄 것이고
                      // default 값은 아이콘으로 해둘 것임. 지금은 IU로 돼있음.
                      'assets/iu.png',
                      width: 36.0,
                      height: 36.0,
                      fit: BoxFit.cover, // 이미지를 원 안에 꽉 채우기
                    ),
                  ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
