import 'dart:typed_data'; // Uint8List 사용을 위해 import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fe/controller/face_controller.dart';

class PreviewPage extends StatelessWidget {
  final FaceController _faceController = Get.find<FaceController>();
  final Future<void> Function(Uint8List?) onSave;

  PreviewPage({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('얼굴 미리보기')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Obx(() {
                final croppedFaceBytes = _faceController.croppedFaceBytes.value;
                if (croppedFaceBytes != null) {
                  return Image.memory(croppedFaceBytes); // 잘라낸 얼굴 이미지 표시
                } else {
                  return const Text('이미지가 없습니다.');
                }
              }),
            ),
          ),
          const SizedBox(height: 20), // 이미지와 버튼 사이에 여유 공간 추가
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: const Text('다시 촬영하기'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await onSave(
                      _faceController.croppedFaceBytes.value); // 저장하기 버튼
                },
                child: const Text('저장하기'),
              ),
            ],
          ),
          const SizedBox(height: 20), // 버튼과 하단의 여유 공간 추가
        ],
      ),
    );
  }
}
