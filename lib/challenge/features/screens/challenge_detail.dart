import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChallengeDetail extends StatelessWidget {
  const ChallengeDetail({super.key}); // 💬 id 필요 없음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('챌린지 상세')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '분리수거 같이 해요~',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Container(
            width: 300,
            height: 150,
            color: Colors.green[300],
            child: const Icon(Icons.recycling, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Column(children: [
                CircleAvatar(child: Text('15분')),
                Text('남은 시간'),
              ]),
              Column(children: [
                CircleAvatar(child: Text('7명')),
                Text('참여 인원'),
              ]),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              context.go('/challengejoin/1'); // 🔥 그냥 id 1번 챌린지로 이동
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
            ),
            child: const Text('참여하기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}