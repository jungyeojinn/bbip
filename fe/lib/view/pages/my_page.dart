import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

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
                // i 버튼 추가 (Tooltip 사용)
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
              color: Colors.blueAccent, // 테두리 색상을 파란색으로 변경
              strokeWidth: 2, // 테두리 두께
              dashPattern: const [8, 4], // 대시 패턴 설정
              borderType: BorderType.RRect, // 둥근 모서리
              radius: const Radius.circular(12), // 둥글게 할 반경 설정
              child: GestureDetector(
                onTap: () {
                  showPlatformDialog(
                      context); // 플랫폼 추가 버튼 클릭 시 fullscreen dialog 호출
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
            // 얼굴 추가 섹션
            Row(
              children: const [
                Text(
                  '얼굴 추가',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                // i 버튼 추가 (Tooltip 사용)
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
              color: Colors.blueAccent, // 테두리 색상을 파란색으로 변경
              strokeWidth: 2, // 테두리 두께
              dashPattern: const [8, 4], // 대시 패턴 설정
              borderType: BorderType.RRect, // 둥근 모서리
              radius: const Radius.circular(12), // 둥글게 할 반경 설정
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
            // 사용자 프로필 이미지 리스트
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

  // 프로필 이미지와 이메일을 포함한 행을 생성하는 함수
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

  // Fullscreen dialog 표시하는 함수
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
              crossAxisCount: 3, // 3x3 형태로 버튼 배치
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

  // 플랫폼 버튼을 생성하는 함수
  Widget _buildPlatformButton(
      BuildContext context, String platformName, String? assetPath,
      {String? text}) {
    return ElevatedButton(
      onPressed: () {
        showBottomSheetDialog(context, platformName);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 둥근 모서리 설정
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

  // 하단에서 작은 다이얼로그 표시하는 함수
  void showBottomSheetDialog(BuildContext context, String platformName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 다이얼로그 크기를 전체 화면에 맞추도록 설정
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16), // 상단만 둥글게
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // 키보드가 올라올 때 화면에 맞게 패딩 조절
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width, // 너비를 화면 전체로 설정
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 다이얼로그 크기를 내용에 맞게 조절
                  crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
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
                        '$platformName 스트림 URL 입력',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '스트림 URL을 입력하세요',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$platformName 스트림 Key 입력',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '스트림 Key를 입력하세요',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('등록'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
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
}
