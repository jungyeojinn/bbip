import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'package:fe/view/pages/main_page.dart';
import 'package:fe/view/pages/landing_page.dart';
import 'package:fe/view/pages/face_registration_page.dart';
import 'package:fe/view/pages/my_page.dart';
import 'package:fe/view/pages/live_page.dart';
import 'package:fe/view/pages/blur_page.dart';
import 'package:fe/view/pages/splash_screen.dart'; // 스플래시 스크린 추가

// getX 상태관리
import 'package:fe/controller/mode_controller.dart';


void main() {
  // ModeController를 GetX의 의존성 주입 시스템에 등록
  Get.put(ModeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // 초기 페이지를 SplashScreen으로 설정
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()), // 스플래시 스크린 경로 추가
        GetPage(name: '/landing', page: () => const LandingPage()),
        GetPage(
            name: '/face_registration',
            page: () => const FaceRegistrationPage()),
        GetPage(name: '/main', page: () => const MainPage()),
        GetPage(name: '/my', page: () => const MyPage()),
        GetPage(name: '/live', page: () => const LivePage()),
        GetPage(name: '/blur', page: () => const BlurPage()),
      ],
    );
  }
}
