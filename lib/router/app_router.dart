import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../home/features/screens/home_screen.dart';
import '../login/features/screens/start_screen.dart';
import '../login/features/screens/login_screen.dart';
import '../login/features/screens/signup_screen.dart';
import '../mypage/features/screens/mypage_screen.dart';
import '../../challenge/features/screens/challenge_list.dart';
import 'package:greeners_sc/challenge/features/screens/challenge_list.dart';
import 'package:greeners_sc/challenge/features/screens/challenge_detail.dart';
import 'package:greeners_sc/challenge/features/screens/challenge_join.dart' as join;

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

    GoRoute(path: '/mypage', builder: (context, state) => const MyPageScreen()),
    GoRoute(
      path: '/challengelist',
      builder: (context, state) => const ChallengeList(),
    ),
    GoRoute(
      path: '/challengedetail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ChallengeDetail(challengeId: id);
      },
    ),


    GoRoute(
      path: '/challengejoin/:id',
      builder: (context, state) {
        // id 없앨거면 final id 부분 삭제
        return const join.ChallengeJoin(); //join. 로 접근
      },
    ),
  ],
);
