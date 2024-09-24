import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyPage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                // 동그란 사진
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 16),
                // 이메일 텍스트
                Text(
                  'xxx@gmail.com',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // "Enter YouTube Rtmp url" 문구
            const Text(
              'Enter YouTube Rtmp url',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Input TextField for URL
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter YouTube Rtmp url',
              ),
            ),
            const SizedBox(height: 24),
            // "Enter YouTube Rtmp Key" 문구
            const Text(
              'Enter YouTube Rtmp Key',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Input TextField for Key
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter YouTube Rtmp Key',
              ),
            ),
            const SizedBox(height: 24),
            // Connect 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 여기서 backend 서버에 보내는 로직 추가
                },
                child: const Text('Connect'),
              ),
            ),
            const SizedBox(height: 24),
            // 왼쪽 + 버튼과 오른쪽 "Add Face" 텍스트
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      // + 버튼 클릭 시 로직 추가
                    },
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(backgroundColor: Colors.grey)),
                SizedBox(width: 12),
                const Text(
                  'Add Face',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                // 동그란 사진
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 16),
                // 이메일 텍스트
                Text(
                  'xxx@gmail.com',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: const [
                // 동그란 사진
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 16),
                // 이메일 텍스트
                Text(
                  'xxx@gmail.com',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: const [
                // 동그란 사진
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 16),
                // 이메일 텍스트
                Text(
                  'xxx@gmail.com',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
