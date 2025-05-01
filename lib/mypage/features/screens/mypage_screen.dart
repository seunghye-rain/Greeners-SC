import 'package:flutter/material.dart';
import '../../../core/app_color.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import 'package:go_router/go_router.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String filter = '전체';

  final List<Map<String, String>> challenges = [
    {'name': '분리수거', 'status': '성공'},
    {'name': '텀블러 사용', 'status': '실패'},
    {'name': '메일 삭제', 'status': '진행중'},
    {'name': '걷기 챌린지', 'status': '성공'},
    {'name': '플라스틱 줄이기', 'status': '진행중'},
  ];

  List<Map<String, String>> get filteredChallenges {
    if (filter == '전체') return challenges;
    return challenges.where((c) => c['status'] == filter).toList();
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로그아웃 완료')),
    );
    context.go('/');
  }

  void _withdraw() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('탈퇴 완료')),
    );
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset('assets/logo.png', width: 120),
              const Text(
                'Greeners',
                style: TextStyle(
                  fontSize: 28,
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text('회원님이 참여한 챌린지',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 16),

              // 필터 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['전체', '진행중', '성공', '실패'].map((status) {
                  final isActive = filter == status;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isActive ? AppColors.forestGreen : const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => setState(() => filter = status),
                      child: Text(status, style: TextStyle(color: Colors.white)),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // 테이블
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FractionColumnWidth(0.15),
                  1: FractionColumnWidth(0.55),
                  2: FractionColumnWidth(0.3),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: AppColors.forestGreen),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('번호', style: TextStyle(color: Colors.white))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('챌린지 이름', style: TextStyle(color: Colors.white))),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('상태', style: TextStyle(color: Colors.white))),
                      ),
                    ],
                  ),
                  ...filteredChallenges.asMap().entries.map(
                        (entry) {
                      final index = entry.key;
                      final challenge = entry.value;
                      Color statusColor;
                      switch (challenge['status']) {
                        case '성공':
                          statusColor = Colors.green;
                          break;
                        case '실패':
                          statusColor = Colors.red;
                          break;
                        case '진행중':
                          statusColor = Colors.blue;
                          break;
                        default:
                          statusColor = Colors.black;
                      }

                      return TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('${index + 1}')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(challenge['name']!)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              challenge['status']!,
                              style: TextStyle(color: statusColor),
                            ),
                          ),
                        ),
                      ]);
                    },
                  )
                ],
              ),

              const SizedBox(height: 24),

              // 로그아웃 및 탈퇴 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('로그아웃', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _withdraw,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('탈퇴하기', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}