// camera_menu_widget.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:fe/controller/mode_controller.dart';

class CameraMenuWidget extends StatefulWidget {
  final Function(String) onModeChanged;

  const CameraMenuWidget({super.key, required this.onModeChanged});

  @override
  CameraMenuWidgetState createState() => CameraMenuWidgetState();
}

class CameraMenuWidgetState extends State<CameraMenuWidget> {
  final List<String> _modes = ['Live', 'Video', 'Photo'];
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ModeController modeController = Get.find();

    return Center(
      child: Obx(() {
        _currentIndex = modeController.currentIndex.value;

        return CarouselSlider(
          carouselController: _controller,
          items: _modes.asMap().entries.map(
            (entry) {
              int index = entry.key;
              String mode = entry.value;
              return GestureDetector(
                onTap: () {
                  modeController.setCurrentMode(mode, index);
                  _controller.animateToPage(index); // 페이지로 애니메이션
                  widget.onModeChanged(mode);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: Text(
                      mode,
                      style: TextStyle(
                        fontSize: 18,
                        color: modeController.currentMode.value == mode
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: modeController.currentMode.value == mode
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
          options: CarouselOptions(
            viewportFraction: 0.18,
            enableInfiniteScroll: false,
            initialPage: _currentIndex, // 시작할 때 현재 인덱스 설정
            onPageChanged: (index, reason) {
              String newMode = _modes[index];
              modeController.setCurrentMode(newMode, index);
              widget.onModeChanged(newMode);
            },
          ),
        );
      }),
    );
  }
}
