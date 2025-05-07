import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _handleSignup() async{
    final name = _nameController.text;
    final id = _idController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || id.isEmpty || password.isEmpty) {
      _showAlert("모든 정보를 입력해주세요.");
      return;
    }

    if (password != confirmPassword) {
      _showAlert("비밀번호가 일치하지 않습니다.");
      return;
    }

    try {
      // Firebase에 회원가입 요청
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: id,
        password: password,
      );


      // 성공 시 이동
      context.go('/login');
    } on FirebaseAuthException catch (e) {
      String message = "회원가입에 실패했습니다.";
      if (e.code == 'email-already-in-use') {
        message = "이미 사용 중인 이메일입니다.";
      } else if (e.code == 'weak-password') {
        message = "비밀번호가 너무 약합니다.";
      }
      _showAlert(message);
    } catch (e) {
      _showAlert("알 수 없는 오류가 발생했습니다.");
    }
  }
  Future<void> _handleGoogleSignup() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 사용자가 로그인 취소

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _showAlert("구글 계정으로 회원가입 완료!");
      context.go('/home');
    } catch (e) {
      debugPrint("Google 회원가입 실패: $e");
      _showAlert("구글 회원가입에 실패했습니다.");
    }
  }
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text(message)),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: SingleChildScrollView(
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
              const SizedBox(height: 16),
              const Text(
                '뜻깊은 기후행동에 함께 해주어 감사해요!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 입력 필드
              _buildInputField(_nameController, '이름'),
              _buildInputField(_idController, '아이디'),
              _buildInputField(_passwordController, '비밀번호', obscureText: true),
              _buildInputField(_confirmPasswordController, '비밀번호 확인', obscureText: true),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _handleGoogleSignup,
                child: Image.asset(
                  'assets/google_signup.png',
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

  Widget _buildInputField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}