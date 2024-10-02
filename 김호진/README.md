# 1주차

## 8월 28일 수요일

### 기획

- 많은 다양한 아이디어를 발산함
- 하지만 결국 식물 제테크로 돌아와서 기획을 구체화함
- 팀원들과 함께 기능 정리 및 와이어프레임 제작에 힘씀

## 8월 29일 목요일

### 기획

- 오전 팀 미팅을 통해 식물 제테크 기획에서 서비스가 가치가 있어야한다는 점에 너무 매몰됐다는 걸 알게 됐고, 팀 전체적으로 식물에 큰 관심이 없어 기획이 지지부진해진다는 문제가 느껴져서 기획을 갈아 엎기로 함
- 데이터셋 사이트에서 다양한 데이터들을 찾았음
- 그런데 팀원의 아이디어 중 괜찮은 아이디어가 있어 그걸 디벨롭하는 데에 노력을 했음

## 8월 30일 금요일

### 기획 마지막날 일지

- 디벨롭했던 기획은 주변인 블러를 기반으로 이뤄졌음. 주변인 블러가 가장 필요한 사람들이 스트리머, 유튜버 등 라이브 방송을 하는 사람들이라고 생각해서 PRISM같은 송출 어플리케이션을 만들어서 주변인 블러를 라이브로 해주는 기획을 했다.
- 과정에서 나온 많은 아이디어들이 전체적인 기획 방향성과 일치하는지를 많이 생각했고 팀 회의에서 적극적으로 아이디어의 타당성, 합리성, 실현가능성을 따지면서 기획을 다듬으려고 노력했다.
- 그 중 블러처리 동작을 하게 될 곳이 클라이언트일지 서버일지 실현가능성을 따져보았다. 정답이 잘 나오지 않아 컨님에게도 팀미팅에서 여쭤보았고 서버에서 아마 될 것으로 예상 중이다. 차주부터 인프라, 백팀에서 관련 조사를 진행해 주기를 요청했다.
- 차주부터 나를 포함한 프론트팀은 AI팀에 합류하여 블러처리라는 핵심 기능 그리고 몇가지 기능에 대해 구현 가능성을 조사해볼 것이다. 모델을 학습시킬 수 있는지, 학습된 모델을 활용할 수 있는지.. 모두가 AI 입문자이기 때문에 (특히 나는 진짜 뭐가뭔지 모르겠지만) 열심히 조사해서 메인 핵심 기능의 실현 가능성을 확인하면 기획이 엎어질 일은 없으니 그때부터 프론트 업무를 시작하자고 제안했고 다음주 중에는 프론트 업무를 시작할 수 있게 하고자 한다.

# 2주차

## 9월 2일 월요일

### AI 리스트업 및 조사

- FE팀과 AI팀이 함께 AI 관련 구현사항 리스트업 및 가장 우선순위에 있는 얼굴 구분 및 블러처리 구현을 위한 기술 조사를 했다. 리스트업 및 우선순위 설정을 주도했고 얼굴을 구분하는 기능을 구현하기 위해 참고할 수 있는 자료들을 찾아 공유했다.
- 이후 메인 기능 구현이 가능할 것으로 보여 FE팀은 프론트 업무를 시작했다. 와이어프레임을 우선 만들었고 초안은 80프로 정도 완성한 것 같다. 내일은 와이어프레임을 더 다음고 디자인, 컴포넌트 등과 관련된 컨벤션을 정하면 될 것 같다.

## 9월 3일 화요일

### 와이어프레임

- 디테일하게 완성되진 않았지만 적당히 구성이 되어있어서 Flutter 학습을 시작했다.

### Flutter

- GetX 상태관리 라이브러리를 적용한 Flutter를 위주로 학습하고 있고, 자유도가 매우 높은 프레임워크여서 프로젝트 구조를 최대한 초기에 잡고 가고 싶은데 좀 어려움이 있다.
- Dart의 변수선언 중 final과 const가 있는데, const는 빌드 타임 상수이고 final은 런타임 변수여서 컴파일 전에 변수를 선언한다면 const, 이후 선언이 돼야한다면 final을 사용해야 한다. 사실 항상 final을 사용하면 에러는 나지 않지만 최적화를 위해 const를 쓸 수 있다면 const를 사용하는 게 메모리가 절약된다.
- 프로젝트 구조를 짜려고 보니 1학기에 배운 MVVM, MVC 이런 디자인 패턴 개념이 많이 보인다. 아마 MVC패턴을 기반으로 GetX + Flutter 프로젝트의 구조를 구성해보려고 한다.
- Flutter에서는 어떻게 API를 HTTP통신으로 주고받는지 몰라 찾아보니 DIO 라이브러리를 사용하면 되는 것 같다.

## 9월 4일 수요일

### Flutter

- GetX를 도입한 상태관리는 3가지 주요 관리를 제공한다. 상태관리, 라우트관리 종속성관리.. 그 중 상태관리와 종속성관리를 위주로 학습과 실습을 진행했다.
- 어느정도 Flutter와 GetX의 구조와 흐름을 파악한 것 같아서 프로젝트를 생성하고 프론트엔드 브렌치에 초기설정을 마친 바닐라 프로젝트를 커밋했다.
- 내일은 라우트 관리를 좀 빠르게 훑고 메인 페이지 구현에 돌입할 예정이다.

## 9월 5일 목요일

### fe팀 git branch 전략 수립 및 초기화

- git branch를 fe/master로 시작해서 feature 등의 브렌치로 깃 컨벤션을 정해두었고, 메인페이지 구현에 앞서 fe/master에 플러터 프로젝트 초기화를 해두고 fe/feature/main-page/camera 브렌치에서 메인페이지 카메라 연동 구현을 시작했다.

### 메인페이지 카메라 연동

- 메인페이지에서 카메라를 화면에 띄우는 걸 만들었는데, 상태바 등의 UI를 무시하고 화면에 카메라 영상을 띄우는 걸 알아봤다. 이렇게 띄워둔 카메라 화면을 뒤로하고 UI를 위에 엎어써야하는데 이 구현들이 좀 어려울 것 같다. 내일 와서 이부분들 집중적으로 개발할 예정이다.

## 9월 6일 금요일

### 메인페이지 UI 구현

- 카메라 연동은 됐는데 UI들을 구현하기가 상당히 어렵다. 상태관리를 하려고 GetX를 시도해봤지만 온갖 에러를 만나서 일단 GetX 없이 구현해보고 구조가 좀 이해되면 나중에 도입하려고 한다.
- 카메라 모드를 좌우로 슬라이드하는 방식으로 하려는데 관련해서 구현하려고 노력 중이다.
- 페이지 이동에 대해 조금 이해가 생겼다. 기본적인 라우트 문법으로 구현을 일단 해보고 있으며, 나중에 GetX로 편하게 코드가 작성되게끔 해볼 예정이다.

# 3주차

## 9월 9일 월요일

### 메인페이지 Live, Video, Photo 모드 선택 UI 구현

- carousel로 메뉴를 구성해서 좌우 스크롤과 터치로 모드를 선택할 수 있게 구현했다.

### 이상무 팀원의 LandingPage, FaceRegistrationPage와 코드 통합 및 fe/develop 브렌치 초기화

## 9월 10일 화요일

### 메인페이지

- 갤러리 아이콘 추가
- 메인페이지에 뭉쳐놨던 코드들을 위젯별로 따로 파일을 분리함

### 기타

- 카메라 라이브러리에 대해 학습하면서 플러터의 라이프사이클 같은 부분들을 조금씩 이해하기 시작함
- 코드 통합에 있어 충돌이 나지 않도록 코드 리뷰하고 진행함
- 갤러리 연동 구현을 시작하려고 하는데 영상이나 사진을 찍거나 불러오면 그 다음에 어떻게 해야할지 구체화를 하고 내일부터 해당 페이지나 기능들 구현을 시작해볼 것 같다.

## 9월 11일 수요일

### 메인페이지

- 갤러리 연동을 위해 image_picker 패키지를 사용했다. 에뮬레이터 안에 사진을 저장하는 방법을 알아봤다.
- 사진을 찍으면 그 사진을 블러 페이지로 전달하는 로직을 구현했는데, CameraWidgetState를 활용하다보니 모드를 바꿀 때마다 배경 카메라 영상이 계속 재로딩 되는 것 같다. 다른 방식을 내일 사용해볼 것.

## 9월 12일 목요일

### 상태관리, 위젯 분리하다가 망했다.

- 플러터, 안드로이드 개발이 미숙한데 처음부터 상태관리하고 위젯분리하고 유지보수성 좋게 만들려고 욕심부리다가 전체 구조가 슬슬 꼬이기 시작하고 디버깅이 불가능해지는 수준에 이르렀다. 더 늦기전에 전체 구조와 흐름을 완벽하게 파악하기 위해 상태관리와 위젯분리를 뒤로 미뤄두고 한 페이지 파일 안에 모든 기능과 위젯을 몰아넣고 그 다음에 리팩토링하면서 상태관리, 위젯분리를 해 전체 구조를 파악하면서 상태관리를 해야겠다고 생각해 처음부터 다시 코드를 짜고 정리하고 있다.
- 적어도 내일까지는 원래 코드를 상태관리를 따로 하지 않는 구조로 프로젝트를 복구하고 추후 리팩토링을 완벽하게 이뤄내 보이겠다.

# 4주차

## 9월 19일 목요일

### 페이지마다 하나의 통합 파일로 구현 중

- 처음부터 다시 한 파일에 코드를 다시 짰다. 결국 잘 되긴 하는데, 녹화한 영상 재생시킬 때 화면 비율과 방향이 이상하다. 메인페이지 프리뷰도 비율이 늘어진다. 화면 비율은 아무리 해도 해결이 안 된다...
- 내일부터는 화면 비율은 재쳐두고.. 왜냐하면 실제로 녹화된 영상을 저장해보면 잘 녹화가 되긴 했으니, 보여지는 부분이 문제일 뿐이니까 미뤄두고 나중에 고치는 게 나을 수도 있겠다..

## 9월 20일 금요일

### 라이브 블러 기능 긴급 상황

- 다른 페이지, 디자인, 기능들을 우선으로 하다가 라이브 블러 기능을 구현을 우선으로 해야된다는 걸 모두의 논의 끝에 도출해냈다. 그런데 막상 구현을 하려고 보니 많은 문제가 있었다. 음성과 영상을 같이 보내고 받고를 해야하는데 그 딜레이를 어떻게 매꿀 것인가.. 일단 플러터로 단순 스트림이 아닌, 우리 서버로 프레임 단위 또는 버퍼 단위로 어떻게 보내야할지 부터가 문제이다. 주말동안 많이 연구해봐야겠다..

# 5주차

## 9월 23일 월요일

### 라이브 블러 기능 긴급 구현

- 이미지 스트림 메서드를 활용해서 프레임들을 서버로 보낼 수 있었다. base64로 변환해야하는데, 이미지 스트림은 YUV420 형식이기 때문에 RGB형식으로 변환해야 했는데, 이부분에서 많이 해맸다.

## 9월 24일 화요일

### 유튜브 송출 테스트용 코드 작성

- node 서버를 백서버 대신 사용해 유튜브 송출을 테스트해봤다. 테스트용 html+js 클라이언트 코드를 통해 단순히 카메라에 접근해 서버로 보내고, 서버에서 유튜브로 송출하는 코드이다. ffmpeg을 활용해야 하는데, 이제부터 우리가 원하는 방식으로 코드를 하나씩 바꿔야한다. 영상을 어찌저찌 완성한다고 해도 소리도 나중에 영상에 합쳐야하는데 이게 될지가 너무 미지수다. 기간이 많이 남지 않았는데 개발이 많이 더뎌서 걱정이지만 차근차근 구현해나가자.

## 9월 25일 수요일

### 유튜브 송출 테스트용 코드 완성

- 프레임을 단순히 ai채널과 주고받고, 받아온 프레임을 rtmp채널로 주면서 노드 서버에서 ffmpeg을 활용해 유튜브로 송출하는 테스트용 코드들이 완성됐다. 그런데 심각한 이슈들이 존재해 서비스를 위해선 이를 반드시 해결해야한다.
- 이슈는 다음과 같다. 프레임율이 지나치게 낮게 나온다. 프레임율이 목표치보다 낮으면 유튜브 라이브가 배속이 되고 프레임을 모두 소진하면 몇초정도 버퍼링이 걸린다. 이 프레임율 저하가 플러터에서 발생하는지, 노드서버에서 발생하는지 디버깅해보고 있다. 
- 이를 해결할 수 없다면 구조적인 해결방안이 필요한데.. 뭐 하나 할 때마다 문제가 생기니까 너무 쉽지않다. 새로운 정보는 많이 알아가는 것 같다. ffmpeg에 대한 것과 공식문서 보는법과.. 남은 기간이 얼마없어 빠르게 해야하는데 갈길이 너무 멀다..

## 9월 26일 목요일

> 그간의 문제점을 정리하고 새로운 구조를 설계했다. 아래는 정리했던 내용과 결론이다.

### 기존 코드

- Flutter (main.dart)
    
    ```dart
    import 'dart:convert';
    import 'dart:typed_data';
    import 'package:flutter/material.dart';
    import 'package:camera/camera.dart';
    import 'package:image/image.dart' as img;
    import 'package:web_socket_channel/web_socket_channel.dart';
    import 'dart:async';
    
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
    
      runApp(MyApp(camera: firstCamera));
    }
    
    class MyApp extends StatelessWidget {
      final CameraDescription camera;
    
      const MyApp({super.key, required this.camera});
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          theme: ThemeData.dark(),
          home: CameraScreen(camera: camera),
        );
      }
    }
    
    class CameraScreen extends StatefulWidget {
      final CameraDescription camera;
    
      const CameraScreen({Key? key, required this.camera}) : super(key: key);
    
      @override
      CameraScreenState createState() => CameraScreenState();
    }
    
    class CameraScreenState extends State<CameraScreen> {
      late CameraController _controller;
      late Future<void> _initializeControllerFuture;
      bool _isStreaming = false;
      Uint8List? _webSocketImage;
      int _lastFrameTime = 0;
      int _frameConditionCount = 0;
      Timer? _frameConditionTimer;
      WebSocketChannel? _aiChannel;
      WebSocketChannel? _rtmpChannel;
    
      int _sentFrames = 0;
      int _receivedFrames = 0;
      Timer? _sentFrameTimer;
      Timer? _receivedFrameTimer;
    
      @override
      void initState() {
        super.initState();
        _initializeControllerFuture = _initializeCameraController();
    
        _sentFrameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          print("Sent FPS to AI channel: $_sentFrames");
          _sentFrames = 0;
        });
    
        _receivedFrameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          print("Received FPS from AI channel: $_receivedFrames");
          _receivedFrames = 0;
        });
    
        _frameConditionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          print("Condition check entered count (every 1 second): $_frameConditionCount");
          _frameConditionCount = 0;
        });
      }
    
      Future<void> _initializeCameraController() async {
        _controller = CameraController(
          widget.camera,
          ResolutionPreset.low,
        );
        await _controller.initialize();
      }
    
      void _toggleStreaming() {
        setState(() {
          _isStreaming = !_isStreaming;
          if (_isStreaming) {
            _startWebSocket();
            _controller.startImageStream(_processCameraImage);
          } else {
            _controller.stopImageStream();
            _aiChannel?.sink.close();
            _rtmpChannel?.sink.close();
          }
        });
      }
    
      void _startWebSocket() {
        _aiChannel = WebSocketChannel.connect(
          Uri.parse('ws://192.168.8.47:8000/ws'),
        );
    
        _rtmpChannel = WebSocketChannel.connect(
          Uri.parse('ws://192.168.8.47:8080/ws/rtmps'),
        );
    
        _aiChannel!.stream.listen((message) {
          if (!mounted) return;
          final int startTime = DateTime.now().millisecondsSinceEpoch;
    
          setState(() {
            _webSocketImage = base64Decode(message);
            _sendImageToRTMPS(_webSocketImage!);
            _receivedFrames++;
          });
    
          final int endTime = DateTime.now().millisecondsSinceEpoch;
          print("WebSocket message received and processed in: ${endTime - startTime} ms");
        });
      }
    
      void _processCameraImage(CameraImage image) {
        final int now = DateTime.now().millisecondsSinceEpoch;
        _frameConditionCount++;
    
        // if (now - _lastFrameTime >= 33) {
        final int startTime = DateTime.now().millisecondsSinceEpoch;
    
        final img.Image convertedImage = convertYUV420toImageColor(image);
        Uint8List pngBytes = Uint8List.fromList(img.encodePng(convertedImage));
        String base64Image = base64Encode(pngBytes);
    
        final int endTime = DateTime.now().millisecondsSinceEpoch;
        print("Camera image processed in: ${endTime - startTime} ms");
    
        _sendImageToAi(base64Image);
    
        _lastFrameTime = now;
    
        // }
      }
    
      void _sendImageToAi(String base64Image) {
        if (_aiChannel != null) {
          final int startTime = DateTime.now().millisecondsSinceEpoch;
    
          _aiChannel!.sink.add(base64Image);
          _sentFrames++;
    
          final int endTime = DateTime.now().millisecondsSinceEpoch;
          print("Image sent to AI channel in: ${endTime - startTime} ms");
        }
      }
    
      void _sendImageToRTMPS(Uint8List imageBytes) {
        if (_rtmpChannel != null) {
          final int startTime = DateTime.now().millisecondsSinceEpoch;
    
          _rtmpChannel!.sink.add(imageBytes);
    
          final int endTime = DateTime.now().millisecondsSinceEpoch;
          print("Image sent to RTMPS channel in: ${endTime - startTime} ms");
        }
      }
    
      img.Image convertYUV420toImageColor(CameraImage image) {
        final int width = image.width;
        final int height = image.height;
        final int uvRowStride = image.planes[1].bytesPerRow;
        final int? uvPixelStride = image.planes[1].bytesPerPixel;
    
        var img2 = img.Image(width: width, height: height);
    
        for (int x = 0; x < width; x++) {
          for (int y = 0; y < height; y++) {
            final int uvIndex = uvPixelStride! * (x ~/ 2) + uvRowStride * (y ~/ 2);
            final int bytesPerRowY = image.planes[0].bytesPerRow;
            final int index = y * bytesPerRowY + x;
    
            final yp = image.planes[0].bytes[index];
            final up = image.planes[1].bytes[uvIndex];
            final vp = image.planes[2].bytes[uvIndex];
    
            int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
            int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
                .round()
                .clamp(0, 255);
            int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
    
            img2.setPixelRgba(x, y, r, g, b, 255);
          }
        }
    
        return img.copyRotate(img2, angle: 90);
      }
    
      @override
      void dispose() {
        _controller.stopImageStream();
        _controller.dispose();
        _aiChannel?.sink.close();
        _rtmpChannel?.sink.close();
        _sentFrameTimer?.cancel();
        _receivedFrameTimer?.cancel();
        _frameConditionTimer?.cancel();
        super.dispose();
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Camera Stream')),
          body: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return RepaintBoundary(
                  child: Center(
                    child: _isStreaming
                        ? (_webSocketImage != null
                        ? Image.memory(_webSocketImage!, gaplessPlayback: true)
                        : const Text('이미지를 불러오는 중입니다...'))
                        : CameraPreview(_controller),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleStreaming,
            child: Icon(_isStreaming ? Icons.stop : Icons.videocam),
          ),
        );
      }
    }
    
    ```
    

<aside>
💡

버튼을 누르면 startImageStream → 이미지 변환: YUV420 → RGB → (압축)PNG → (인코딩)base64 → AI서버 웹소켓으로부터 이미지 전송 → AI서버 웹소켓으로부터 이미지 수신 → 이미지 변환: base64 → (디코딩)PNG → 화면에 이미지 랜더링 + 백서버 웹소켓으로 이미지 전송

</aside>

- node 서버 1 (AI서버 대용)
    
    ```jsx
    const WebSocket = require('ws');
    
    const wss = new WebSocket.Server({ port: 8000 });
    
    let receivedFrames = 0;
    let sentFrames = 0;
    let lastReceivedTime = Date.now();
    let lastSentTime = Date.now();
    
    // 1초마다 프레임율 출력하는 타이머 설정
    setInterval(() => {
      const currentTime = Date.now();
    
      const receivedFps = receivedFrames / ((currentTime - lastReceivedTime) / 1000);
      console.log(`Received FPS: ${receivedFps.toFixed(2)}`);
      receivedFrames = 0;  // 프레임 카운트 초기화
      lastReceivedTime = currentTime;
    
    }, 1000);
    
    wss.on('connection', (ws) => {
      console.log('클라이언트가 연결되었습니다.');
    
      ws.on('message', (message) => {
        // 메시지를 수신한 시점에서 receivedFrames 카운트 증가
        receivedFrames++;
    
        // 받은 데이터를 다시 클라이언트로 돌려보냄
        const messageStr = message.toString('utf-8');
        ws.send(messageStr);
    
        // 데이터를 보낸 후 sentFrames 카운트 증가
        sentFrames++;
      });
    
      ws.on('close', () => {
        console.log('클라이언트 연결이 종료되었습니다.');
      });
    });
    
    console.log('웹소켓 서버가 포트 8000에서 실행 중입니다.');
    
    ```
    

<aside>
💡

이미지 수신 → 그대로 이미지 전송 (실제로는 블러 처리)

</aside>

- node 서버 2 (백서버 대용)
    
    ```dart
    const WebSocket = require('ws');
    const { spawn } = require('child_process');
    
    const wss = new WebSocket.Server({ port: 8080 });
    
    wss.on('connection', (ws) => {
        console.log('클라이언트 연결됨');
    
        const ffmpegPath = 'C:/ffmpeg/bin/ffmpeg.exe';
        const ffmpeg = spawn(ffmpegPath, [
            '-re',                         // 실시간 입력 데이터 처리
            '-f', 'image2pipe',            // 이미지 스트림 입력
            '-i', '-',                     // 표준 입력으로부터 이미지 수신
            '-f', 'lavfi',                 // 빈 오디오 트랙 추가
            '-i', 'anullsrc=r=44100:cl=stereo',
            '-vsync', 'cfr',               // 고정 프레임율 처리 (30fps로 설정)
            '-r', '30',                    // 30fps 고정
            '-c:v', 'libx264',             // 비디오 인코딩
            '-c:a', 'aac',                 // 오디오 인코딩
            '-pix_fmt', 'yuv420p',         // 픽셀 포맷 설정
            '-preset', 'ultrafast',        // 속도 개선
            '-b:v', '3000k',               // 비트레이트 설정
            '-maxrate', '3000k',           // 최대 비트레이트
            '-bufsize', '6000k',           // 버퍼 크기
            '-vf', 'scale=-1:720',         // 가로 비율 자동, 세로 해상도 고정
            '-f', 'flv',                   // FLV 포맷으로 송출
            '-rtbufsize', '1500M',         // 입력 버퍼 크기 설정
            'rtmp://a.rtmp.youtube.com/live2/ku1c-um9s-yu6r-frs5-21a8',  // 유튜브 스트림 URL
        ]);
    
        let lastLogTime = 0;
    
        ffmpeg.stdin.on('error', (e) => {
            console.error('FFmpeg stdin 에러:', e);
        });
    
        ffmpeg.stdout.on('data', (data) => {
            const now = Date.now();
            if (now - lastLogTime > 1000) {  // 1초에 한 번 출력
                console.log(`FFmpeg stdout 로그: ${data}`);
                lastLogTime = now;
            }
        });
    
        ffmpeg.stderr.on('data', (data) => {
            const now = Date.now();
            if (now - lastLogTime > 1000) {  // 1초에 한 번 출력
                console.error(`FFmpeg stderr 로그: ${data}`);
                lastLogTime = now;
            }
        });
    
        let lastMessageTime = 0;
        ws.on('message', (message) => {
            const now = Date.now();
            if (now - lastMessageTime > 1000) {  // 1초에 한 번 출력
                console.log('웹소켓을 통해 메시지 수신. FFmpeg로 전송 중...');
                lastMessageTime = now;
            }
    
            const buffer = Buffer.from(message);
            ffmpeg.stdin.write(buffer);  // 이미지 데이터를 ffmpeg로 전송
        });
    
        ws.on('close', () => {
            console.log('클라이언트 연결 종료');
            ffmpeg.stdin.end();
        });
    
        ffmpeg.on('close', (code) => {
            console.log(`ffmpeg 프로세스 종료됨, 코드: ${code}`);
        });
    });
    
    console.log('웹소켓 서버가 포트 8080에서 실행 중입니다.');
    
    ```
    

<aside>
💡

이미지 수신 → FFMPEG: 이미지 + 빈 소리 합성 → 유튜브 송출

</aside>

### 성능 분석

출력 로그

- main.dart
    
    ```bash
    I/flutter (15465): converted to RGB in: 10 ms
    I/flutter (15465): converted to PNG in: 51 ms
    I/flutter (15465): encoded to base64 in: 1 ms
    I/flutter (15465): Image sent to AI channel in: 2 ms
    I/flutter (15465): Image sent to RTMPS channel in: 0 ms
    I/flutter (15465): WebSocket message received and processed in: 1 ms
    ```
    
    PNG로 압축과정에서 40~50ms 정도 발생 → 성능저하 가능성 있음
    
- 서버 1 (AI서버 대용)
    
    ```bash
    Received FPS: 16.97
    Received FPS: 11.87
    Received FPS: 11.01
    Received FPS: 12.90
    Received FPS: 13.93
    Received FPS: 17.96
    Received FPS: 20.02
    Received FPS: 13.00
    Received FPS: 14.96
    Received FPS: 10.90
    Received FPS: 14.90
    Received FPS: 17.86
    ```
    
    수신 프레임율 불안정 (+ 30FPS에 한참 못미침)
    
- 서버 2 (백서버 대용)
    
    ```bash
    FFmpeg stderr 로그: frame= 1761 fps= 15 q=24.0 size=   22396KiB 
    time=00:11:04.90 bitrate= 275.9kbits/s dup=297 drop=0 speed=5.51x
    ```
    
    프레임율 1/2 저하 (목표치 = 30FPS)
    

[유튜브 라이브 결과](https://www.youtube.com/live/1aqTs_z3hGo?si=oQik2d_qBtQXSkrZ&t=26)

### 문제점으로 확인된 것

- AI서버로 이미지 전송 전, 이미지 변환 과정에서 성능 저하가 있으며, AI서버, 백서버 모두 수신받는 이미지의 프레임율이 매우 불안정하고 목표 프레임율보다 많은 저하가 있음
- 유튜브 라이브를 확인해보면, 약 1.5~2배정도 배속돼서 재생됨. 부족한 프레임만큼 배속되는 것 같은데, 배속재생으로 인해 프레임이 다 소진되면 버퍼링이 주기적으로 수초 동안 발생함

### 결론

- 앱에서 이미지 변환을 raw이미지로 까지만 변환하고 압축은 하지 않아볼까? → 전송 용량이 지나치게 많아짐 (한 장당 심하면 수십MB가 될지도)
- 웹소켓이 메시지 기반이다보니 실시간 영상 통신을 하기에 적합하지 않다. 실제로 프레임율 변동이 큰 것으로 보아 안정성, 효율성이 많이 떨어지는 것 같다.
- 결과적으로 영상 변환, 영상 실시간 통신에 있어 성능을 향상시키기 위해선 이런 방면으로 많은 사람들이 고민을 해봤을 WebRTC를 사용하기로 했다.

# 6주차

## 10월 2일 수요일

### 프로젝트는 다시 미궁속으로..

- rtc도 결국 정답이 아니었던 것 같다. 결국 websocket으로 돌아오긴 했는데 여전히 성능이 매우 떨어질 것으로 예상된다. 일단 하기로 했으니 구현은 해놓겠지만, 연동을 해보면 분명 문제가 생길 것이다. 내일 휴일동안 다른 방법을 최대한 강구해볼 생각이다..