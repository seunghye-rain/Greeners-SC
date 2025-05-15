import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../home/features/screens/home_screen.dart';
import '../login/features/screens/start_screen.dart';
import '../login/features/screens/login_screen.dart';
import '../login/features/screens/signup_screen.dart';
import '../mypage/features/screens/mypage_screen.dart';
import '../challenge/features/screens/challenge_list.dart';
import '../challenge/features/screens/challenge_create_screen.dart';
import '../challenge/features/screens/challenge_recommend_screen.dart';
import '../challenge/features/screens/challenge_select_screen.dart';
import '../challenge/features/screens/challenge_join_ai_screen.dart';
import 'package:greeners_sc/challenge/features/screens/challenge_detail.dart';
import 'package:greeners_sc/challenge/features/screens/challenge_join.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'start',
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

    GoRoute(path: '/mypage', builder: (context, state) => const MyPageScreen()),
    GoRoute(
      path: '/challengelist',
      builder: (context, state) => const ChallengeList(),
    ),
    GoRoute(
      path: '/challengedetail/:id',
      name: 'challengedetail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final isJoined = state.extra != null && state.extra is Map<String, dynamic>
            ? (state.extra as Map<String, dynamic>)['isJoined'] ?? false
            : false;

        return ChallengeDetail(
          challengeId: id,
          isJoined: isJoined,
        );
      },
    ),
    GoRoute(
      path: '/challenge/select',
      builder: (context, state) => const ChallengeSelectScreen(),
    ),
    GoRoute(
      path: '/challenge/create',
      builder: (context, state) => const ChallengeCreateScreen(),
    ),
    GoRoute(
      path: '/challenge/recommend',
      builder: (context, state) => const ChallengeRecommendScreen(),
    ),

    GoRoute(
      path: '/challenge/join/ai',
      builder: (context, state) => const ChallengeJoinAiScreen(
        challengeTitle: '기본 챌린지 제목',
      ),
    ),




    GoRoute(
      path: '/challengejoin/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ChallengeJoin(challengeId: id);
      },
    ),

  ],
);
