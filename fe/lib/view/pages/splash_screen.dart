import 'dart:ui'; // BackdropFilter를 사용하기 위해 추가
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blurController;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();

    // 블러 애니메이션 컨트롤러 초기화
    _blurController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _blurAnimation = Tween<double>(begin: 0.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _blurController,
        curve: Curves.easeOut,
      ),
    );

    // 1초 후에 애니메이션 시작
    Future.delayed(const Duration(seconds: 1), () {
      _blurController.forward();
    });

    // 3초 후에 landing 페이지로 이동
    Future.delayed(const Duration(seconds: 4), () {
      Get.offNamed('/landing');
    });
  }

  @override
  void dispose() {
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff008fff),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.asset(
              'assets/splashscreen.png',
              width: 300, // 이미지 너비 조정
              height: 300, // 이미지 높이 조정
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 270.0), // 필요에 따라 조정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon('assets/brand.png'),
                  const SizedBox(width: 25), // 아이콘 간격
                  _buildIcon('assets/face-detection.png'),
                  const SizedBox(width: 25), // 아이콘 간격
                  _buildIcon('assets/license-plate.png'),
                ],
              ),
            ),
          ),
          // 전체 화면 블러 효과
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _blurAnimation,
              builder: (context, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: Container(
                    color: Colors.transparent, // 배경색을 투명으로 설정
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String assetPath) {
    return Image.asset(
      assetPath,
      width: 50, // 아이콘 너비 조정
      height: 50, // 아이콘 높이 조정
    );
  }
}
