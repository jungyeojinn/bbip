// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fe/view/pages/main_page.dart';
import 'package:fe/view/pages/landing_page.dart';
import 'package:fe/view/pages/face_registration_page.dart';
import 'package:fe/view/pages/my_page.dart';
import 'package:fe/view/pages/live_page.dart';
import 'package:fe/view/pages/blur_page.dart';
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/landing', // 초기 페이지 설정
      getPages: [
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
