import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dio/dio.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyPage'),
      ),
      body: Container(
        color: Colors.white, // 배경색 흰색으로 설정
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 섹션
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                // 동그란 사진
                CircleAvatar(
                  radius: 40, // 이미지 크기를 좀 더 키움
                  backgroundImage: AssetImage('assets/jangwoo.png'),
                ),
                SizedBox(width: 20),
                // 이메일 및 사용자 정보 텍스트
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jangwoo Lee',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'xxx@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 플랫폼 추가 섹션
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
            const SizedBox(height: 12),
            // Dotted Border Button
            DottedBorder(
              color: Colors.blueAccent,
              strokeWidth: 2,
              dashPattern: const [8, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: GestureDetector(
                onTap: () {
                  showPlatformDialog(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text(
                      '플랫폼 추가 +',
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
            ...List.generate(3, (index) => _buildProfileRow('xxx@gmail.com')),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String email) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/jangwoo.png'),
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

  void showPlatformDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('플랫폼 선택'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildPlatformButton(
                    context, 'youtube', 'assets/youtube-icon.png'),
                _buildPlatformButton(
                    context, 'twitch', 'assets/twitch-icon.png'),
                _buildPlatformButton(
                    context, 'afreeca_tv', 'assets/afreecatv-icon.png'),
                _buildPlatformButton(context, 'chzzk', 'assets/chzzk-icon.png'),
                _buildPlatformButton(
                    context, 'periscope', 'assets/periscope-icon.png'),
                _buildPlatformButton(
                    context, 'facebook', 'assets/facebook-icon.png'),
                _buildPlatformButton(
                    context, 'd_live', 'assets/dlive-icon.png'),
                _buildPlatformButton(context, 'trovo', 'assets/trovo-icon.png'),
                _buildPlatformButton(context, 'custom', null, text: '커스텀RTMP'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlatformButton(
      BuildContext context, String platformName, String? assetPath,
      {String? text}) {
    return ElevatedButton(
      onPressed: () {
        showBottomSheetDialog(context, platformName);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: assetPath != null
          ? Image.asset(
              assetPath,
              width: 50,
              height: 50,
            )
          : Text(
              text!,
              style: const TextStyle(fontSize: 16),
            ),
    );
  }

  void showBottomSheetDialog(BuildContext context, String platformName) {
    TextEditingController streamKeyController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$platformName RTMP 설정',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$platformName 스트림 Key 입력',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: streamKeyController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '스트림 Key를 입력하세요',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            int? serverId = getServerId(platformName);
                            if (serverId != null) {
                              await sendStreamKey(
                                  serverId, streamKeyController.text);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('등록'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('취소'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int? getServerId(String platformName) {
    Map<String, int> platformMap = {
      'youtube': 1,
      'twitch': 2,
      'afreeca_tv': 3,
      'chzzk': 4,
      'periscope': 5,
      'facebook': 6,
      'd_live': 7,
      'trovo': 8,
      'custom': 9,
    };
    return platformMap[platformName];
  }

  Future<void> sendStreamKey(int serverId, String streamKey) async {
    try {
      Dio dio = Dio();
      String apiUrl = 'https://j11a203.p.ssafy.io:8080/api/rtmp/key';
      final storage = FlutterSecureStorage();

      // SecureStorage에서 accessToken 가져오기
      String? accessToken = await storage.read(key: 'accessToken');
      print(accessToken);

      // accessToken이 있는 경우 헤더에 추가
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      // POST 요청 보내기
      Response response = await dio.post(
        apiUrl,
        data: {
          'serverId': serverId,
          'key': streamKey,
        },
        options: Options(
          validateStatus: (status) {
            return status != null && status < 500; // 500 미만 상태 허용
          },
        ),
      );

      print('응답: ${response.data}');
    } catch (e) {
      print('오류 발생: $e');
    }
  }
}
