import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fe/view/components/common/camera_widget.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  Offset _imagePosition = Offset(215, 30); // 이미지의 초기 위치
  Offset _chatBoxPosition = Offset(100, 200); // 채팅 박스의 초기 위치
  Size _chatBoxSize = Size(200, 100); // 채팅 박스의 초기 크기
  int cameraIndex = 0;
  bool isChatBoxVisible = false; // 채팅 박스의 가시성 상태

  void _updateImagePosition(Offset newPosition) {
    setState(() {
      _imagePosition = newPosition;
    });
  }

  void _updateChatBoxPosition(Offset newPosition) {
    setState(() {
      _chatBoxPosition = newPosition;
    });
  }

  void toggleCamera() {
    setState(() {
      cameraIndex = (cameraIndex == 0) ? 1 : 0;
    });
  }

  void toggleChatBox() {
    setState(() {
      isChatBoxVisible = !isChatBoxVisible; // 채팅 박스의 가시성을 토글
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraWidget(cameraIndex: cameraIndex),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              onPressed: toggleCamera,
              icon: Image.asset(
                'assets/rotate-button.png',
                width: 32.0,
                height: 32.0,
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: IconButton(
              onPressed: toggleChatBox,
              icon: Image.asset(
                'assets/chatting-button.png',
                width: 32.0,
                height: 32.0,
              ),
            ),
          ),
          // 드래그 가능한 이미지와 텍스트
          Positioned(
            left: _imagePosition.dx,
            top: _imagePosition.dy,
            child: Draggable(
              feedback: _buildRecordingImage(),
              childWhenDragging: Container(), // 드래그 중에는 빈 컨테이너
              onDragEnd: (details) {
                _updateImagePosition(details.offset);
              },
              child: _buildRecordingImage(),
            ),
          ),
          // 채팅 박스
          if (isChatBoxVisible)
            Positioned(
              left: _chatBoxPosition.dx,
              top: _chatBoxPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // 채팅 박스의 위치를 조정
                    _chatBoxPosition = Offset(
                      _chatBoxPosition.dx + details.delta.dx,
                      _chatBoxPosition.dy + details.delta.dy,
                    );
                  });
                },
                child: Stack(
                  children: [
                    _buildChatBox(),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isChatBoxVisible = false; // 채팅 박스 닫기
                          });
                        },
                      ),
                    ),
                    // 크기 조절 핸들 추가
                    _buildResizeHandle(
                      color: Colors.blue,
                      alignment: Alignment.centerRight,
                      onPanUpdate: (details) {
                        setState(() {
                          _chatBoxSize = Size(
                            (_chatBoxSize.width + details.delta.dx)
                                .clamp(100.0, double.infinity),
                            _chatBoxSize.height,
                          );
                        });
                      },
                    ),
                    _buildResizeHandle(
                      color: Colors.red,
                      alignment: Alignment.bottomCenter,
                      onPanUpdate: (details) {
                        setState(() {
                          _chatBoxSize = Size(
                            _chatBoxSize.width,
                            (_chatBoxSize.height + details.delta.dy)
                                .clamp(100.0, double.infinity),
                          );
                        });
                      },
                    ),
                    _buildResizeHandle(
                      color: Colors.green,
                      alignment: Alignment.topCenter,
                      onPanUpdate: (details) {
                        setState(() {
                          _chatBoxSize = Size(
                            _chatBoxSize.width,
                            (_chatBoxSize.height - details.delta.dy)
                                .clamp(100.0, double.infinity),
                          );
                          _chatBoxPosition = Offset(
                            _chatBoxPosition.dx,
                            _chatBoxPosition.dy + details.delta.dy,
                          );
                        });
                      },
                    ),
                    _buildResizeHandle(
                      color: Colors.yellow,
                      alignment: Alignment.centerLeft,
                      onPanUpdate: (details) {
                        setState(() {
                          _chatBoxSize = Size(
                            (_chatBoxSize.width - details.delta.dx)
                                .clamp(100.0, double.infinity),
                            _chatBoxSize.height,
                          );
                          _chatBoxPosition = Offset(
                            _chatBoxPosition.dx + details.delta.dx,
                            _chatBoxPosition.dy,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/live');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 20.0),
                ),
                child: const Text('Go Live'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // recording.png와 텍스트를 포함하는 위젯
  Widget _buildRecordingImage() {
    return SizedBox(
      width: 100, // 원하는 너비 설정
      height: 100, // 원하는 높이 설정
      child: Stack(
        children: [
          Image.asset(
            'assets/recording.png',
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 10,
            top: 1,
            child: Text(
              '00:00', // 원하는 왼쪽 숫자
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 1,
            child: Text(
              '0502', // 원하는 오른쪽 숫자
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 채팅 박스 위젯
  Widget _buildChatBox() {
    // 더미 데이터
    final List<Map<String, String>> dummyChatData = [
      {'name': 'User1', 'chat': '안녕하세요!'},
      {'name': 'User2', 'chat': '반갑습니다!'},
      {'name': 'User1', 'chat': '어떻게 지내세요?'},
      {'name': 'User2', 'chat': '잘 지내고 있습니다!'},
      {'name': 'User1', 'chat': '안녕하세요!'},
      {'name': 'User2', 'chat': '반갑습니다!'},
      {'name': 'User1', 'chat': '어떻게 지내세요?'},
      {'name': 'User2', 'chat': '잘 지내고 있습니다!'},
      {'name': 'User1', 'chat': '안녕하세요!'},
      {'name': 'User2', 'chat': '반갑습니다!'},
      {'name': 'User1', 'chat': '어떻게 지내세요?'},
      {'name': 'User2', 'chat': '잘 지내고 있습니다!'},
      {'name': 'User1', 'chat': '안녕하세요!'},
      {'name': 'User2', 'chat': '반갑습니다!'},
      {'name': 'User1', 'chat': '어떻게 지내세요?'},
      {'name': 'User2', 'chat': '잘 지내고 있습니다!'},
    ];

    return Container(
      width: _chatBoxSize.width,
      height: _chatBoxSize.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white), // 흰색 테두리
        color: Colors.black.withOpacity(0.1), // 반투명 배경
      ),
      child: Stack(
        children: [
          // 여기에 x 버튼을 넣으면 창이 닫히지 않고 부모 위젯에서 x 버튼을 넣어야 한다. 이유는 ? 알아가봐야 함.
          // Positioned(
          //   right: 5,
          //   top: 5,
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.close,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       setState(() {
          //         isChatBoxVisible = false; // 채팅 박스 닫기
          //       });
          //     },
          //   ),
          // ),
          // 여기에 추가적인 채팅 UI 요소를 넣을 수 있습니다
          ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: dummyChatData.length,
            itemBuilder: (context, index) {
              final chatItem = dummyChatData[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이름
                    Text(
                      chatItem['name']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 이름과 채팅 사이의 간격
                    SizedBox(width: 12.0),
                    // 채팅 내용
                    Expanded(
                      child: Text(
                        chatItem['chat']!,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis, // 내용이 길 경우 생략 표시
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 크기 조절 핸들 위젯
  Widget _buildResizeHandle({
    required Color color,
    required Alignment alignment,
    required void Function(DragUpdateDetails) onPanUpdate,
  }) {
    return Positioned(
      left: alignment == Alignment.centerRight
          ? _chatBoxSize.width - 10
          : (alignment == Alignment.centerLeft ? -10 : 0),
      top: alignment == Alignment.bottomCenter
          ? _chatBoxSize.height - 10
          : (alignment == Alignment.topCenter ? -10 : 0),
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        child: Container(
          // 색깔 투명화
          color: Colors.transparent,
          width: alignment == Alignment.centerLeft ||
                  alignment == Alignment.centerRight
              ? 20.0
              : _chatBoxSize.width,
          height: alignment == Alignment.topCenter ||
                  alignment == Alignment.bottomCenter
              ? 20.0
              : _chatBoxSize.height,
          child: Align(
            alignment: alignment,
            child: Container(
              color: color,
              width: 10.0,
              height: 10.0,
            ),
          ),
        ),
      ),
    );
  }
}
