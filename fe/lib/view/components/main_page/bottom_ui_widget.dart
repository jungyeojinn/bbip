import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'animated_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fe/view/components/main_page/gallery_icon_widget.dart';
import 'blur_mode_selection_widget.dart';

class BottomUiWidget extends StatefulWidget {
  final String selectedMode;
  final bool isVideoRecording;
  final VoidCallback onRecordPressed;
  final Function(String) onGoLivePressed;

  const BottomUiWidget({
    super.key,
    required this.selectedMode,
    required this.isVideoRecording,
    required this.onRecordPressed,
    required this.onGoLivePressed,
  });

  @override
  State<BottomUiWidget> createState() => BottomUiWidgetState();
}

class BottomUiWidgetState extends State<BottomUiWidget> {
  late String blurMode = '얼굴';

  void _showPopup() {
    Get.dialog(
      Stack(
        children: [
          Positioned(
            bottom: 200,
            left: 20,
            right: 20,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 연결할 플랫폼을 선택하세요.
                    Text(
                      '연결할 플랫폼을 선택하세요.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Image.asset(
                              'assets/youtube-icon.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {},
                          child: DottedBorder(
                            color: Colors.blueAccent,
                            strokeWidth: 2,
                            dashPattern: const [8, 4],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            child: Container(
                              height: 80,
                              width: 80,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: const Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // 블러 처리할 부분을 선택하세요.
                    Text(
                      '블러 처리할 부분을 선택하세요.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    BlurModeSelectionWidget(
                      blurMode: blurMode,
                      onBlurModeChanged: (label) {
                        setState(() {
                          blurMode = label;
                          print('onBlurModeChanged: blurMode=$blurMode');
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                            widget.onGoLivePressed(blurMode);
                          },
                          child: Text(
                            'Go Live',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back(); // 팝업 닫기
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _buildModeSpecificUI(),
        ),
        if (!widget.isVideoRecording && widget.selectedMode == 'Video' ||
            widget.selectedMode == 'Photo')
          GalleryIconWidget()
      ],
    );
  }

  Widget _buildModeSpecificUI() {
    switch (widget.selectedMode) {
      case 'Live':
        return ElevatedButton(
          onPressed: () => _showPopup(),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            textStyle: const TextStyle(fontSize: 20.0),
          ),
          child: const Text('Go Live'),
        );
      case 'Video':
        return AnimatedRecordButton(
          isVideoRecording: widget.isVideoRecording,
          onPressed: widget.onRecordPressed,
        );
      case 'Photo':
        return IconButton(
          icon: Image.asset('assets/camera-button.png',
              width: 60.0, height: 60.0),
          onPressed: () {},
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
