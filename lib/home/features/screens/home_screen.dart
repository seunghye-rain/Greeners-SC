import 'package:flutter/material.dart';
import '../../../core/widgets/app_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('홈 화면')),
      bottomNavigationBar: AppBottomNav(currentIndex: 1),
    );
  }
}