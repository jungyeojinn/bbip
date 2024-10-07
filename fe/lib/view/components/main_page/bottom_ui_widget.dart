import 'package:flutter/material.dart';
import 'animated_button.dart';
import 'package:fe/view/components/main_page/gallery_icon_widget.dart';

class BottomUiWidget extends StatelessWidget {
  final String selectedMode;
  final bool isVideoRecording;
  final VoidCallback onRecordPressed;
  final VoidCallback onGoLivePressed;

  const BottomUiWidget({
    super.key,
    required this.selectedMode,
    required this.isVideoRecording,
    required this.onRecordPressed,
    required this.onGoLivePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _buildModeSpecificUI(),
        ),
        if (!isVideoRecording && selectedMode == 'Video' || selectedMode == 'Photo')
          GalleryIconWidget()
      ],
    );
  }

  Widget _buildModeSpecificUI() {
    switch (selectedMode) {
      case 'Live':
        return ElevatedButton(
          onPressed: onGoLivePressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            textStyle: const TextStyle(fontSize: 20.0),
          ),
          child: const Text('Go Live'),
        );
      case 'Video':
        return AnimatedRecordButton(
          isVideoRecording: isVideoRecording,
          onPressed: onRecordPressed,
        );
      case 'Photo':
        return IconButton(
          icon: Image.asset('assets/camera-button.png', width: 60.0, height: 60.0),
          onPressed: () {},
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
