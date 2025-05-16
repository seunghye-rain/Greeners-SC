import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/app_bottom_nav.dart';

class ChallengeJoinAiScreen extends StatefulWidget {
  final String challengeTitle;

  const ChallengeJoinAiScreen({
    super.key,
    required this.challengeTitle,
  });

  @override
  State<ChallengeJoinAiScreen> createState() => _ChallengeJoinAiScreenState();
}

class _ChallengeJoinAiScreenState extends State<ChallengeJoinAiScreen> {
  io.File? _imageFile;
  final TextEditingController _commentController = TextEditingController();

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = io.File(pickedFile.path);
        });
      }
    }
  }

  void _submit() {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("코멘트를 입력해주세요")),
      );
      return;
    }

    // 실제 업로드 로직은 여기에 추가
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("챌린지 참여 완료!")),
    );

    Navigator.pop(context); // 이전 화면으로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('챌린지 참여')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.challengeTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : const Center(child: Text("+ 사진 업로드")),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: '코멘트를 입력해주세요',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("참여하기", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}