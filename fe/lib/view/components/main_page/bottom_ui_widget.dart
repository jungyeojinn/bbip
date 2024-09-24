import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'animated_button.dart'; // 애니메이션 위젯 import
import 'package:fe/view/components/main_page/gallery_icon_widget.dart';

class BottomUiWidget extends StatelessWidget {
  final String selectedMode;
  final bool isVideoRecording; // MainPage에서 전달받은 값
  final VoidCallback onRecordPressed; // 녹화 상태 변경 함수

  const BottomUiWidget({
    super.key,
    required this.selectedMode,
    required this.isVideoRecording,
    required this.onRecordPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _buildModeSpecificUI(),
        ),
        if (!isVideoRecording && selectedMode == 'Video' ||
            selectedMode == 'Photo')
          GalleryIconWidget()
      ],
    );
  }

  Widget _buildModeSpecificUI() {
    switch (selectedMode) {
      case 'Live':
        return ElevatedButton(
          onPressed: () {Get.toNamed('/live');}, // MainPage에서 전달받은 Go Live 콜백 호출
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            textStyle: const TextStyle(fontSize: 20.0),
          ),
          child: const Text('Go Live'),
        );
      case 'Video':
        return AnimatedRecordButton(
          isVideoRecording: isVideoRecording, // MainPage에서 전달받은 상태
          onPressed: onRecordPressed, // 녹화 상태 변경 함수 호출
        );
      case 'Photo':
        return IconButton(
          icon: Image.asset(
            'assets/camera-button.png',
            width: 60.0,
            height: 60.0,
          ),
          onPressed: () {},
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
