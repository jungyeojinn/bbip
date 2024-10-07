import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart' as gt;

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  Offset _imagePosition = Offset(215, 30); // 이미지의 초기 위치
  Offset _chatBoxPosition = Offset(100, 200); // 채팅 박스의 초기 위치
  Size _chatBoxSize = Size(200, 100); // 채팅 박스의 초기 크기
  bool isChatBoxVisible = false; // 채팅 박스의 가시성 상태

  late WebSocketChannel channel;
  final String socketUrl = 'ws://70.12.247.94:8000/rtc/ws';

  RTCPeerConnection? peerConnection;
  final Map<String, RTCPeerConnection> peerConnections = {};

  final localVideoRenderer = RTCVideoRenderer();
  final remoteVideoRenderer = RTCVideoRenderer();
  MediaStream? localStream;
  MediaStream? remoteStream;

  bool isCameraReady = false;
  bool showingLocalStream = true;
  bool isUsingFrontCamera = true;

  @override
  void dispose() {
    localVideoRenderer.dispose();
    remoteVideoRenderer.dispose();
    peerConnections.forEach((key, value) {
      value.dispose();
    });
    channel.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    localStream = gt.Get.arguments as MediaStream?;
    localVideoRenderer.initialize().then((_) {
      setState(() {
        localVideoRenderer.srcObject = localStream;
        isCameraReady = true;
      });
    });
    remoteVideoRenderer.initialize();
    _connectToWebSocket();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    print('_requestPermissions');
    var status = await [Permission.camera, Permission.microphone].request();
    if (status[Permission.camera]!.isGranted && status[Permission.microphone]!.isGranted) {
      print('_startLocalStream1');
      _startLocalStream();
    } else {
      print('Camera or Microphone permission denied.');
    }
  }

  Future<void> _startLocalStream() async {
    print('_startLocalStream2');
    try {
      final config = {
        'sdpSemantics': 'unified-plan',
      };
      peerConnection = await createPeerConnection(config);

      peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        final candidateData = {
          'type': 'candidate',
          'candidate': candidate.toMap(),
        };
        final jsonCandidate = jsonEncode(candidateData);
        channel.sink.add(jsonCandidate);
      };

      peerConnection!.onTrack = (RTCTrackEvent event) {
        setState(() {
          remoteStream = event.streams[0];
          remoteVideoRenderer.srcObject = remoteStream;
        });
      };

      localStream?.getTracks().forEach((track) {
        peerConnection!.addTrack(track, localStream!);
      });

      final offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);

      final offerData = {
        'type': 'offer',
        'sdp': offer.sdp,
      };

      channel.sink.add(jsonEncode(offerData));
    } catch (e) {
      print("Error accessing camera: $e");
    }
  }

  void _connectToWebSocket () async {
    print('_connectToWebSocket');
    channel = IOWebSocketChannel.connect(socketUrl);
    print('IOWebSocketChannel.connect');

    channel.stream.listen((message) {
      print('received message: $message');
      final signal = jsonDecode(message!);
      _handleSignal(signal);
    }, onDone: () {
      print('WebSocket connection closed.');
    });
  }

  void _handleSignal(Map<String, dynamic> signal) {
    switch (signal['type']) {
      case 'answer':
        print('received answer');
        _handleAnswer(signal);
        break;
      case 'candidate':
        print('received candidate');
        _addCandidate(signal['candidate']);
        break;
      default:
        print('Received unknown signal type: ${signal['type']}');
        break;
    }
  }

  void _handleAnswer(Map<String, dynamic> offer) async {
    String? sdp = offer['sdp'];
    String? type = offer['type'];

    await peerConnection!.setRemoteDescription(RTCSessionDescription(sdp, type));
    peerConnections['sender'] = peerConnection!;
  }

  void _addCandidate(Map<String, dynamic> candidate) async {
    final pc = peerConnections['sender'];
    if (pc != null) {
      pc.addCandidate(RTCIceCandidate(
        candidate['candidate'],
        candidate['sdpMid'],
        candidate['sdpMLineIndex'],
      ));
    } else {
      print("Error: Peer connection is null for candidate: $candidate");
    }
  }

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

  void toggleChatBox() {
    setState(() {
      isChatBoxVisible = !isChatBoxVisible; // 채팅 박스의 가시성을 토글
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale = 1 / (1.7777777777777777777777777777778 * MediaQuery.of(context).size.aspectRatio);
    return Scaffold(
      body: Stack(
        children: [
          Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: isCameraReady
              ? (showingLocalStream
                ? RTCVideoView(localVideoRenderer)
                : (remoteStream != null
                  ? RTCVideoView(remoteVideoRenderer)
                  : Center(child: const CircularProgressIndicator()))
            ) : Center(child: const CircularProgressIndicator()),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              onPressed: () {},
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
                onPressed: () { gt.Get.back(); },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 20.0),
                ),
                child: const Text('Stop Live'),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: IconButton(
              icon: Icon(
                showingLocalStream ? Icons.blur_on : Icons.blur_off,
                color: Colors.white,
                size: 55,
              ),
              onPressed: () {
                setState(() {
                  showingLocalStream = !showingLocalStream;
                });
              },
            )
          )
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
