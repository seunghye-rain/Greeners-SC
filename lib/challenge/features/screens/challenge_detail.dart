import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

class ChallengeDetail extends StatefulWidget {
  final int challengeId;
  final bool isJoined;

  const ChallengeDetail({
    super.key,
    required this.challengeId,
    required this.isJoined,
  });

  @override
  State<ChallengeDetail> createState() => _ChallengeDetailState();
}

class _ChallengeDetailState extends State<ChallengeDetail> {
  Map<String, dynamic>? challenge;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isJoined = widget.isJoined;
    fetchChallengeDetail();
    checkIfJoined();
  }


  bool isJoined = false;

  Future<void> checkIfJoined() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    if (idToken == null) return;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/user/challenges/'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final List challenges = data['challenges'];

      // 🔍 여기 추가
      print("user joined challenge ids: ${challenges.map((c) => c['id'])}");

      final joined = challenges.any((c) => c['id']?.toString() == widget.challengeId.toString());
      setState(() {
        isJoined = joined;
      });
    } else {
      print("유저 참여 챌린지 불러오기 실패: ${response.statusCode}");
    }
  }


  Future<void> fetchChallengeDetail() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/challenge/detail/${widget.challengeId}/'),
      headers: {
        'Authorization': 'Bearer ${await FirebaseAuth.instance.currentUser?.getIdToken() ?? ""}',
      },
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
            onPressed: isJoined  // ✅ 변경
                ? null
                : () {
              context.push('/challengejoin/${widget.challengeId}');

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isJoined ? Colors.grey : Colors.green[800], // ✅ 변경
            ),
            child: Text(
              isJoined ? '참여완료' : '참여하기', // ✅ 변경
              style: const TextStyle(color: Colors.white),
            ),
          ),





        ],
      ),
    );
  }
}
