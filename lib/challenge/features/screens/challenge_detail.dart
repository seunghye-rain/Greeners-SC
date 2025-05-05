import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChallengeDetail extends StatefulWidget {
  final int challengeId;

  const ChallengeDetail({super.key, required this.challengeId});

  @override
  State<ChallengeDetail> createState() => _ChallengeDetailState();
}

class _ChallengeDetailState extends State<ChallengeDetail> {
  Map<String, dynamic>? challenge;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChallengeDetail();
  }

  Future<void> fetchChallengeDetail() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/challenge/detail/${widget.challengeId}/'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        challenge = data['data'];
        isLoading = false;
      });
    } else {
      print('오류: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || challenge == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = challenge!['name'];
    final current = challenge!['current_participants'];
    final max = challenge!['max_participants'];
    final endTime = DateTime.parse(challenge!['end_time']);
    final remainingMinutes = endTime.difference(DateTime.now()).inMinutes;

    return Scaffold(
      appBar: AppBar(title: const Text('챌린지 상세')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Container(
            width: 300,
            height: 150,
            color: Colors.green[300],
            //TODO: recycling 아이콘 챌린지 사진이나 다른 것으로 교체하기 (각 챌린지에 맞게)
            child: const Icon(Icons.recycling, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                CircleAvatar(child: Text('$remainingMinutes분')),
                const Text('남은 시간'),
              ]),
              Column(children: [
                CircleAvatar(child: Text('$current명')),
                const Text('참여 인원'),
              ]),
            ],
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // 참여 화면 이동 시 challengeId 전달
              Navigator.pushNamed(context, '/challengejoin/${widget.challengeId}');
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
