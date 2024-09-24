import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryIconWidget extends StatefulWidget {
  const GalleryIconWidget({super.key});

  @override
  GalleryIconWidgetState createState() => GalleryIconWidgetState();
}

class GalleryIconWidgetState extends State<GalleryIconWidget> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

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
          getImage(ImageSource.gallery);
        },
      ),
    );
  }
}
