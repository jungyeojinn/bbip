import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX 패키지 임포트

class BlurPage extends StatefulWidget {
  const BlurPage({super.key});

  @override
  State<BlurPage> createState() => _BlurPageState();
}

class _BlurPageState extends State<BlurPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.scaleDown, // 이미지를 화면에 꽉 채우고 중앙에 맞춤
            alignment: Alignment.center, // 이미지를 중앙에 맞추기
            image: AssetImage('assets/korea-wallpaper.jpg'),
          ),
        ),
        child: Stack(
          children: [
            // 왼쪽 상단에 뒤로 가기 아이콘 추가
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white), // 뒤로 가기 아이콘
                onPressed: () {
                  Get.back(); // 이전 페이지로 이동
                },
              ),
            ),
            // 버튼을 화면 하단 가운데에 위치
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 50.0), // 버튼을 화면 하단에서 살짝 위로
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가로로 나란히 배치
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 저장 버튼 클릭 시 SnackBar 보여주기
                        Get.snackbar(
                          '저장 완료', // 제목
                          '사진이 저장되었습니다.', // 메시지
                          snackPosition: SnackPosition.BOTTOM, // 스낵바 위치
                          duration: const Duration(seconds: 3), // 3초 동안 표시
                          colorText: Colors.white,
                        );
                      },
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 20), // 두 버튼 간 간격
                    ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          '블러 처리 완료', // 제목
                          '사진이 저장되었습니다.', // 메시지
                          snackPosition: SnackPosition.BOTTOM, // 스낵바 위치
                          duration: const Duration(seconds: 3), // 3초 동안 표시
                          colorText: Colors.white,
                        );
                      },
                      child: const Text('Blur'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
