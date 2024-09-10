// bottom_ui_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          Positioned(
            left: 50.0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(
                Icons.photo_library,
                color: Colors.white,
                size: 40.0,
              ),
              onPressed: () {},
            ),
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            textStyle: const TextStyle(fontSize: 20.0),
          ),
          child: const Text('Go Live'),
        );
      case 'Video':
        return IconButton(
          icon: widget.isVideoRecording ? Image.asset(
            'assets/recorded-button.png',
            width: 60.0,
            height: 60.0,
          ) : Image.asset(
            'assets/record-button.png',
            width: 60.0,
            height: 60.0,
          ),
          onPressed: () {
            setState(() {
              widget.isVideoRecording = !widget.isVideoRecording;
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
