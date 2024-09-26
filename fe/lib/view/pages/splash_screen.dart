// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 3초 동안 애니메이션 진행
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // 애니메이션 시작
    _controller.forward();

    // 3초 후에 자동으로 페이지 이동
    Future.delayed(const Duration(seconds: 5), () {
      Get.offNamed('/landing'); // 3초 후에 LandingPage로 이동
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue, // 배경색 설정
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'BBIP',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white, // 텍스트 색상
            ),
          ),
        ),
      ),
    );
  }
}
