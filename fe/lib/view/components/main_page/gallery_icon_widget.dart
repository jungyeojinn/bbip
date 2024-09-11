import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryIconWidget extends StatelessWidget {
  const GalleryIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 50.0,
      bottom: 0,
      child: IconButton(
        icon: const Icon(
          Icons.photo_library,
          color: Colors.white,
          size: 40.0,
        ),
        onPressed: () {
          Get.toNamed('/my');
        },
      ),
    );
  }
}
