import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static final String _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  static Future<String?> getChallengeRecommendation(String userInput) async {
    if (_apiKey.isEmpty) {
      return 'API 키가 설정되지 않았어요 😢 .env 파일을 확인해주세요.';
    }

    final headers = {'Content-Type': 'application/json'};

    final prompt = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {
              "text":
              "이 앱은 사용자들이 기후행동 챌린지를 서로 만들고 참여할 수 있는 플랫폼이에요. "
                  "사용자가 지금 추천을 원해요. '${userInput}'과 같은 활동을 하고 싶다고 했을 때 어떤 기후행동 챌린지를 추천해줄 수 있을까요? "
                  "간단하고 실천 가능한 챌린지 1가지를 귀엽고 친절하게 대답해주세요."
            }
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: headers,
        body: jsonEncode(prompt),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final content = body['candidates'][0]['content']['parts'][0]['text'];
        return content;
      } else {
        return '❌ 추천에 실패했어요 (${response.statusCode})';
      }
    } catch (e) {
      return '❌ 에러 발생: $e';
    }
  }
}