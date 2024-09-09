// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fe/view/pages/main_page.dart';
import 'package:fe/view/pages/landing_page.dart';
import 'package:fe/view/pages/face_registration_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        GetPage(name: '/face_registration', page: () => const FaceRegistrationPage()),
        GetPage(name: '/main', page: () => const MainPage()),
      ],
    );
  }
}
