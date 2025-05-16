import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../services/gemini_service.dart';

class ChallengeRecommendScreen extends StatefulWidget {
  const ChallengeRecommendScreen({super.key});

  @override
  State<ChallengeRecommendScreen> createState() => _ChallengeRecommendScreenState();
}

class _ChallengeRecommendScreenState extends State<ChallengeRecommendScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _recommendation;
  bool _loading = false;

  Future<void> _getRecommendation() async {
    setState(() {
      _loading = true;
      _recommendation = null;
    });

    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final result = await GeminiService.getChallengeRecommendation(input);
    setState(() {
      _recommendation = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('챌린지 추천 받기')),
      body: SingleChildScrollView( // ✅ overflow 방지용 스크롤 래퍼
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '어떤 기후행동을 해볼까요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '예: 바다 지키는 활동 추천해줘!',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getRecommendation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Gemini에게 추천받기', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_recommendation != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _recommendation!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            const SizedBox(height: 40),
            if (_recommendation != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/challenge/join/ai');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('이 챌린지로 참여할래요!', style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}