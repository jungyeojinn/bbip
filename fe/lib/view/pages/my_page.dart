import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart'; // GetX 사용을 위해 임포트
import 'package:fe/controller/face_controller.dart'; // FaceController 임포트

import 'package:fe/view/components/common/platform_list_widget.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String userName = '';
  String userEmail = '';
  final FaceController _faceController = Get.put(FaceController()); // FaceController 등록

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Secure Storage에서 accessToken 가져오기
      String? accessToken = await _secureStorage.read(key: 'accessToken');

      if (accessToken != null) {
        // dio 헤더 설정
        _dio.options.headers['Authorization'] = accessToken;

        // 사용자 정보 요청
        final response =
        await _dio.get('http://j11a203.p.ssafy.io:8080/api/users');

        if (response.statusCode == 200) {
          final responseData = response.data;
          final userData = responseData['data'];

          setState(() {
            userName = userData['name'] ?? 'Unknown';
            userEmail = userData['email'] ?? 'unknown@example.com';
          });
        } else {
          // 에러 처리
          print('Failed to fetch user data: ${response.statusMessage}');
        }
      } else {
        print('Access token not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? savedImage = _faceController.getImage(); // 저장된 이미지 가져오기

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyPage'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // 배경색 흰색으로 설정
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 섹션
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40, // 이미지 크기를 좀 더 키움
                    backgroundImage: savedImage != null
                        ? MemoryImage(savedImage) // 저장된 이미지 사용
                        : const AssetImage('assets/jangwoo.png') as ImageProvider, // 기본 이미지
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // 나머지 UI는 기존 코드 유지
              const SizedBox(height: 24),
              Row(
                children: const [
                  Text(
                    '플랫폼 추가',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 4),
                  Tooltip(
                    message: '송출하고 싶은 플랫폼의 RTMP KEY를 입력해서 송출을 할 수 있습니다.',
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
              PlatformListWidget(),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Text(
                    '얼굴 추가',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 4),
                  Tooltip(
                    message: '송출 화면에 Blur 표시가 안되게 할 인물들을 추가할 수 있습니다',
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DottedBorder(
                color: Colors.blueAccent,
                strokeWidth: 2,
                dashPattern: const [8, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Center(
                      child: Text(
                        '얼굴 추가 +',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '얼굴 목록',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...List.generate(1, (index) => _buildProfileRow(savedImage ?? Uint8List(0), userEmail)), // 저장된 이미지 전달
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(Uint8List image, String email) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: image.isNotEmpty
                  ? MemoryImage(image) // 저장된 이미지 사용
                  : const AssetImage('assets/jangwoo.png') as ImageProvider, // 기본 이미지
            ),
            const SizedBox(width: 16),
            Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
