// camera_menu_widget.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CameraMenuWidget extends StatefulWidget {
  final Function(String) onModeChanged; // 모드 변경 시 호출할 콜백 추가

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
    return Center(
      child: sliderWidget(),
    );
  }

  Widget sliderWidget() {
    return CarouselSlider(
      carouselController: _controller,
      items: _modes.asMap().entries.map(
            (entry) {
          int index = entry.key;
          String mode = entry.value;
          return GestureDetector(
            onTap: () {
              _controller.animateToPage(index);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Center(
                child: Text(
                  mode,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
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
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
            widget.onModeChanged(_modes[index]); // 모드 변경 시 콜백 호출
          });
        },
      ),
    );
  }
}
