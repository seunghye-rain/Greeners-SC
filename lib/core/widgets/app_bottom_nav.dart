import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_color.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: AppColors.primaryGreen,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list), label: '챌린지'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/challengelist');
            break;
          case 1:
            context.go('/home');
            break;
          case 2:
            context.go('/mypage');
            break;
        }
      },
    );
  }
}