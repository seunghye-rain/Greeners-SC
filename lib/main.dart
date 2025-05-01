import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'core/app_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Greeners',
      theme: ThemeData(
        fontFamily: 'Money', // 공통 폰트
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primaryGreen,
          onPrimary: AppColors.white,
          secondary: AppColors.forestGreen,
          onSecondary: AppColors.white,
          background: AppColors.white,
          onBackground: AppColors.black,
          surface: AppColors.white,
          onSurface: AppColors.black,
          error: AppColors.darkRed,
          onError: AppColors.white,
        ),
        useMaterial3: true,
      ),
    );
  }
}