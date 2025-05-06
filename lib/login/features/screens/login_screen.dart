import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("오류"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }


  void _handleLogin() async {
    final email = _idController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError("이메일과 비밀번호를 입력하세요.");
      return;
    }

    try {
      // ✅ 로그인 요청
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ 성공 시 홈으로 이동
      context.go('/home');
    } on FirebaseAuthException catch (e) {
      // ✅ 실패 시 오류 메시지 표시
      String message = "로그인에 실패했습니다.";
      if (e.code == 'user-not-found') {
        message = "존재하지 않는 사용자입니다.";
      } else if (e.code == 'wrong-password') {
        message = "비밀번호가 올바르지 않습니다.";
      }
      _showError(message);
    } catch (e) {
      _showError("알 수 없는 오류가 발생했습니다.");
    }
  }


  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 사용자가 취소

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final additionalInfo = authResult.additionalUserInfo;
      debugPrint('isNewUser: ${additionalInfo?.isNewUser}');

      if (additionalInfo != null && additionalInfo.isNewUser) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("회원가입이 되지 않은 계정입니다."),
          ),
        );

        Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });

        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        return;
      }
      context.go('/home');
    } catch (e) {
      debugPrint("Google 로그인 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 120,
              ),
              const SizedBox(height: 12),
              const Text(
                'Greeners',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: '아이디',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _handleGoogleSignIn,
                child: Image.asset(
                  'assets/google_signin.png',
                  width: double.infinity,
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}