import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart' as gt;
import 'dart:async';
import 'package:fe/view/components/main_page/camera_menu_widget.dart';
import 'package:fe/view/components/main_page/bottom_ui_widget.dart';
import 'package:fe/controller/face_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final localVideoRenderer = RTCVideoRenderer();
  MediaStream? localStream;
  late double scale = 1 / (1.78 * MediaQuery.of(context).size.aspectRatio);

  String selectedMode = 'Live';
  bool isVideoRecording = false;
  bool isCameraReady = false;
  bool isUsingFrontCamera = true;

  final FaceController _faceController = gt.Get.put(FaceController());

  @override
  void dispose() {
    localVideoRenderer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    localVideoRenderer.initialize();
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
      final videoStream = await navigator.mediaDevices.getUserMedia({
        'video': {
          'facingMode': isUsingFrontCamera ? 'user' : 'environment',
          'mandatory': { 'minFrameRate': '15', 'maxFrameRate': '15', },
        },
        'audio': false,
      });

      localStream = videoStream;
      final settings = localStream?.getVideoTracks()[0].getSettings();
      final double aspectRatio = settings?['width'] / settings?['height'];

      setState(() {
        localVideoRenderer.srcObject = localStream;
        scale = 1 / (aspectRatio * MediaQuery.of(context).size.aspectRatio);
        isCameraReady = true;
      });
    } catch (e) {
      print("Error accessing camera: $e");
    }
  }

  void updateMode(String mode) {
    setState(() {
      selectedMode = mode;
      if (mode == 'Video') {
        isVideoRecording = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? savedImage = _faceController.getImage();

    return Scaffold(
      body: Stack(
        children: [
          if (isCameraReady)
            Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: RTCVideoView(
                  localVideoRenderer,
                  mirror: isUsingFrontCamera,
                )
            ),
          if (!isCameraReady)
            Center(child: const CircularProgressIndicator()),
          Positioned(
            top: 30.0,
            left: 20.0,
            child: IconButton(
              onPressed: () async {
                setState(() {
                  isUsingFrontCamera = !isUsingFrontCamera;
                });
                await _startLocalStream();
              },
              icon: Image.asset(
                'assets/rotate-button.png',
                width: 32.0,
                height: 32.0,
              ),
            ),
          ),
          if (!isVideoRecording)
            Positioned(
              top: 30.0,
              right: 20.0,
              child: IconButton(
                onPressed: () {
                  gt.Get.toNamed('/my');
                },
                icon: Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  child: ClipOval(
                    child: savedImage != null
                        ? Image.memory(
                      savedImage,
                      width: 36.0,
                      height: 36.0,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/iu.png', // 기본 이미지
                      width: 36.0,
                      height: 36.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          if (!isVideoRecording)
            Positioned(
              bottom: 30.0,
              left: 0,
              right: 0,
              child: Center(
                child: CameraMenuWidget(onModeChanged: updateMode),
              ),
            ),
          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Center(
              child: BottomUiWidget(
                selectedMode: selectedMode,
                isVideoRecording: isVideoRecording,
                onRecordPressed: () {
                  setState(() {
                    isVideoRecording = !isVideoRecording;
                  });
                },
                onGoLivePressed: (blurMode) {
                  final String selectedMode;
                  final List<String> blurModeIcons;
                  if (blurMode == '얼굴') {
                    selectedMode = 'face';
                    blurModeIcons = ['assets/face-detection-onclick.png'];
                  } else if (blurMode == '상표/차번호') {
                    selectedMode = 'text';
                    blurModeIcons = ['assets/license-plate-onclick.png', 'assets/brand-onclick.png'];
                  } else {
                    selectedMode = 'weapon';
                    blurModeIcons = ['assets/knife-onclick.png'];
                  }
                  print('selectedMode: $selectedMode');
                  gt.Get.toNamed(
                    '/live',
                    arguments: {
                      'localStream': localStream,
                      'isUsingFrontCamera': isUsingFrontCamera,
                      'blurMode': selectedMode,
                      'blurModeIcons': blurModeIcons,
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
