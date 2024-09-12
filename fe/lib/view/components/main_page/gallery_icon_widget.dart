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
      left: 60.0,
      bottom: 0,
      child: IconButton(
        onPressed: () {
          getImage(ImageSource.gallery);
        },
        icon: Container(
          width: 48.0,
          height: 48.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white, // 테두리 색상
              width: 1.0, // 테두리 두께
            ),
            borderRadius: BorderRadius.circular(8.0), // 네모와 원 중간 정도의 모양
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // 동일한 반지름으로 이미지도 자르기
            child: Image.asset(
              // 나중에 gallery에 있는 첫 번째 사진으로 바꿀 것임.
              'assets/IU.png',
              width: 48.0,
              height: 48.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
