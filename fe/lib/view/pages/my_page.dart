import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('This is MyPage.'),
      ),
      body: Center(
        child: Text('Hello'),
      ),
    );
  }
}
