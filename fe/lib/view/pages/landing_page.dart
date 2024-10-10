import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:uni_links/uni_links.dart';
import 'package:video_player/video_player.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final storage = const FlutterSecureStorage();
  StreamSubscription? _linkSubscription;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initUniLinks();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.asset('assets/blurvideo.mp4')
      ..initialize().then((_) {
        setState(() {
          _videoController?.setLooping(true);
          _videoController?.play();
        });
      });
  }

  Future<void> _initUniLinks() async {
    _linkSubscription = linkStream.listen((String? link) {
      if (link != null) {
        final uri = Uri.parse(link);
        final accessToken = uri.queryParameters['accessToken'];
        final refreshToken = uri.queryParameters['refreshToken'];

        if (accessToken != null && refreshToken != null) {
          storage.write(key: 'accessToken', value: accessToken);
          storage.write(key: 'refreshToken', value: refreshToken);
          Get.toNamed('/face_registration');
        }
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _videoController != null && _videoController!.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 150),
              child: Text(
                'BBIP',
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ElevatedButton.icon(
                onPressed: () {
                  _signInWithGoogle(context);
                },
                icon: Image.asset(
                  'assets/google_logo.png',
                  height: 24.0,
                  width: 24.0,
                ),
                label: const Text(
                  'Sign In with Google',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await FlutterWebAuth.authenticate(
        url: 'http://j11a203.p.ssafy.io:8080/oauth2/authorization/google',
        callbackUrlScheme: 'bbip',
      );
    } catch (e) {
      print('Failed to authenticate with Google: $e');
    }
  }
}
