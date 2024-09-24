import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  final storage = const FlutterSecureStorage(); // Secure Storage 인스턴스 생성

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 올라와도 배경 이미지가 밀려 올라가지 않도록
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/wallpaper.jpg'), // 배경 이미지
          ),
        ),
        child: Stack(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가로로 가운데 정렬
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start, // 세로로 위쪽에 배치
                  crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
                  children: [
                    SizedBox(height: 150), // 중앙보다 위로 이동시키기 위한 간격
                    Text(
                      'BBIP',
                      style: TextStyle(
                        fontSize: 48, // 텍스트 크기
                        color: Colors.white, // 흰색 글자
                        fontWeight: FontWeight.bold, // 글자 굵게
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 60), // 화면 맨 아래에서 조금 위로 띄움
                child: ElevatedButton.icon(
                  onPressed: () {
                    _signInWithGoogle(context); // Google 로그인 함수 호출
                  },
                  icon: Image.asset(
                    'assets/google_logo.png', // 구글 로고 이미지 파일
                    height: 24.0,
                    width: 24.0,
                  ),
                  label: const Text(
                    'Sign In with Google',
                    style: TextStyle(
                      fontSize: 18, // 텍스트 크기
                      color: Colors.black, // 검정색 글자
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 흰색 배경
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12), // 패딩 조절
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    print('signUpWithGoogle Pressed');

    // Spring 서버로 로그인 요청 보내기
    final response = await http.get(
      Uri.parse('http://localhost:8080/oauth2/authorization/google'),
    );

    // 서버로부터 accessToken과 refreshToken 헤더 받기
    if (response.statusCode == 200) {
      String? accessToken = response.headers['accessToken'];
      String? refreshToken = response.headers['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        // Secure Storage에 토큰 저장
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);

        print('Tokens saved in secure storage');
        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');

        // 페이지 이동
        Get.toNamed('/face_registration');
      } else {
        print('Token not found in response headers');
      }
    } else {
      print('Failed to authenticate with Google');
    }
  }
}
