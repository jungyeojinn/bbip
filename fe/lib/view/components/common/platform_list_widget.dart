import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PlatformListWidget extends StatefulWidget {

  const PlatformListWidget({
    super.key,
  });

  @override
  State<PlatformListWidget> createState() => _PlatformListWidgetState();
}

class _PlatformListWidgetState extends State<PlatformListWidget> {
  bool isRegistered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isRegistered == false)
        GestureDetector(
          onTap: () {
            setState(() {
              isRegistered = !isRegistered;
            });
            showPlatformDialog(context);
          },
          child: DottedBorder(
            color: Colors.blueAccent,
            strokeWidth: 2,
            dashPattern: const [8, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
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
        if (isRegistered == true)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 10,),
            SizedBox(
              height: 80,
              width: 80,
              child: _buildPlatformButton(
                context, 'youtube', 'assets/youtube-icon.png',
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                setState(() {
                  isRegistered = !isRegistered;
                });
                showPlatformDialog(context);
              },
              child: DottedBorder(
                color: Colors.blueAccent,
                strokeWidth: 2,
                dashPattern: const [8, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Container(
                  height: 80,
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 90,),
            SizedBox(width: 100,),
          ],
        ),
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