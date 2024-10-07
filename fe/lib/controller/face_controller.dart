import 'dart:typed_data'; // Uint8List 사용을 위해 import
import 'package:get/get.dart';

class FaceController extends GetxController {
  Rx<Uint8List?> croppedFaceBytes = Rx<Uint8List?>(null); // Uint8List로 변경

  void setCroppedFace(Uint8List? faceBytes) {
    croppedFaceBytes.value = faceBytes;
  }

  void clearCroppedFace() {
    croppedFaceBytes.value = null;
  }
}
