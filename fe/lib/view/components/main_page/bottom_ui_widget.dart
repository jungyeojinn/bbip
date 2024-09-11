// bottom_ui_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'animated_button.dart'; // 새로 만든 애니메이션 위젯 import
import 'package:fe/view/components/main_page/gallery_icon_widget.dart';

class BottomUiWidget extends StatefulWidget {
  final String selectedMode;
  bool isVideoRecording;

  BottomUiWidget({
    super.key,
    required this.selectedMode,
    required this.isVideoRecording,
  });

  @override
  BottomUiWidgetState createState() => BottomUiWidgetState();
}

class BottomUiWidgetState extends State<BottomUiWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _buildModeSpecificUI(),
        ),
        if (widget.selectedMode == 'Video' || widget.selectedMode == 'Photo')
          GalleryIconWidget()
      ],
    );
  }

  Widget _buildModeSpecificUI() {
    switch (widget.selectedMode) {
      case 'Live':
        return ElevatedButton(
          onPressed: () {
            _goLive(context);
          },
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            textStyle: const TextStyle(fontSize: 20.0),
          ),
          child: const Text('Go Live'),
        );
      case 'Video':
        // 애니메이션 효과가 있는 녹화 버튼 사용
        return AnimatedRecordButton(
          isVideoRecording: widget.isVideoRecording,
          onPressed: () {
            setState(() {
              widget.isVideoRecording = !widget.isVideoRecording; // 녹화 상태 토글
            });
          },
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

  Future<void> _goLive(BuildContext context) async {
    Get.toNamed('/live');
  }
}
