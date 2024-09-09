// lib/controller/camera_menu_controller.dart

import 'package:get/get.dart';

class CameraMenuController extends GetxController {
  var selectedMode = 'Live'.obs;

  void selectMode(String mode) {
    selectedMode.value = mode;
  }
}
