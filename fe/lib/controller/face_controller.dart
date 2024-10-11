import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class FaceController extends GetxController {
  Rx<Uint8List?> croppedFaceBytes = Rx<Uint8List?>(null);
  Rx<Uint8List?> capturedImageBytes = Rx<Uint8List?>(null);

  void setCroppedFace(Uint8List? faceBytes) {
    croppedFaceBytes.value = faceBytes;
  }

  void clearCroppedFace() {
    croppedFaceBytes.value = null;
  }

  void saveFaceImage(XFile? imageXFile) async {
    print('saveFaceImage');
    final imageBytes = await imageXFile?.readAsBytes();
    print('final imageBytes = imageXFile?.readAsBytes()');
    capturedImageBytes.value = imageBytes;
    print('capturedImageBytes.value = imageBytes as Uint8List?');
  }

  Uint8List? getImage() {
    return capturedImageBytes.value;
  }
}
