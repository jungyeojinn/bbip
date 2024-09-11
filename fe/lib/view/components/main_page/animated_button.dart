import 'package:flutter/material.dart';

class AnimatedRecordButton extends StatefulWidget {
  final bool isVideoRecording;
  final VoidCallback onPressed;

  const AnimatedRecordButton({
    super.key,
    required this.isVideoRecording,
    required this.onPressed,
  });

  @override
  _AnimatedRecordButtonState createState() => _AnimatedRecordButtonState();
}

class _AnimatedRecordButtonState extends State<AnimatedRecordButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed, // 버튼을 눌렀을 때 수행할 작업
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400), // 애니메이션 지속 시간
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(
                widget.isVideoRecording
                    ? 'assets/recorded-button.png' // 녹화 중일 때 이미지
                    : 'assets/record-button.png', // 녹화 중이 아닐 때 이미지
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
