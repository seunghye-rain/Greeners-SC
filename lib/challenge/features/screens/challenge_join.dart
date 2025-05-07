import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

// 조건부 import
// 웹 환경일 때만 dart:html 사용
// 'web_image_helper.dart'와 'mobile_image_helper.dart' 파일을 따로 만들어서 사용
import 'package:greeners_sc/conditional_import/image_helper_stub.dart'
if (dart.library.html) 'package:greeners_sc/conditional_import/web_image_helper.dart'
if (dart.library.io) 'package:greeners_sc/conditional_import/mobile_image_helper.dart';



class ChallengeJoin extends StatefulWidget {
  final int challengeId;

  const ChallengeJoin({super.key, required this.challengeId});

  @override
  State<ChallengeJoin> createState() => _ChallengeJoinState();
}


class _ChallengeJoinState extends State<ChallengeJoin> {
  io.File? _imageFile;
  String? _webImageDataUrl;
  final TextEditingController commentController = TextEditingController();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final imageUrl = await pickWebImage();
      if (imageUrl != null) {
        setState(() {
          _webImageDataUrl = imageUrl;
        });
      }
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = io.File(pickedFile.path);
        });
      }
    }
  }


  Future<void> _submitParticipation() async {
    final comment = commentController.text;

    if ((kIsWeb && _webImageDataUrl == null) || (!kIsWeb && _imageFile == null) || comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진과 코멘트를 모두 입력해주세요')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    if (idToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증 토큰을 가져올 수 없습니다')),
      );
      return;
    }

    final uri = Uri.parse('http://10.0.2.2:8000/api/challenge/${widget.challengeId}/join/');

    try {
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $idToken';
      request.fields['comment'] = comment;

      if (!kIsWeb) {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('웹에서는 현재 이미지 업로드를 지원하지 않습니다.')),
        );
        return;
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('참여 완료')),
        );
        Navigator.pop(context, true);
      } else {
        String errorMessage = '참여 실패';
        try {
          final decoded = jsonDecode(respStr);
          errorMessage = decoded['message'] ?? errorMessage;
        } catch (_) {
          debugPrint('JSON 파싱 실패: $respStr');
        }

        debugPrint('참여 실패: $respStr');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }

    } catch (e) {
      debugPrint('참여 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('오류가 발생했습니다')),
      );
    }
  }


  Widget _buildImageWidget() {
    if (kIsWeb) {
      if (_webImageDataUrl != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            _webImageDataUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      }
    } else {
      if (_imageFile != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _imageFile!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      }
    }

    return const Center(
      child: Text(
        '+\n사진 업로드',
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('챌린지 참여하기')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildImageWidget(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: '코멘트 입력...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitParticipation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('참여하기', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
