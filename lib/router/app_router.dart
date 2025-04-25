import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../home/features/screens/home_screen.dart';
import '../login/features/screens/start_screen.dart';
import '../login/features/screens/login_screen.dart';
import '../login/features/screens/signup_screen.dart';
import '../mypage/features/screens/mypage_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // 앱 처음 시작 경로
  routes: [
    GoRoute(
      path: '/',
      name: 'start',
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(), // 아직 작성 전
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(), // 아직 작성 전
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/mypage', builder: (context, state) => const MyPageScreen()),
    GoRoute(
      path: '/challengelist',
      builder: (context, state) => const Placeholder(), // 추후 교체 예정
    ),
  ],
);
