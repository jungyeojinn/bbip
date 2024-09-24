// mode_controller.dart
import 'package:get/get.dart';

class ModeController extends GetxController {
  var currentMode = 'Live'.obs;
  var currentIndex = 0.obs;

  void setCurrentMode(String mode, int index) {
    currentMode.value = mode;
    currentIndex.value = index;
  }
}
