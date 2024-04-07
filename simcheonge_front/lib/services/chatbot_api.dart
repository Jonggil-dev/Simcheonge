import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/models/chatbot_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotAPI {
  static const String _baseUrl =
      "도메인";

  // SharedPreferences에서 토큰을 가져오는 메소드
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // 사용자 입력을 받아 서버에 POST 요청을 보내고 응답을 받는 메소드
  static Future<ChatbotModel?> postUserInput(String sentence) async {
    final accessToken = await _getAccessToken(); // 액세스 토큰을 가져옵니다.
    if (accessToken == null) {
      print('Access token not found');
      return null;
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // 헤더에 액세스 토큰을 추가합니다.
      },
      body: jsonEncode({'sentence': sentence}),
    );

    if (response.statusCode == 200) {
      // 응답이 성공적일 때, UTF-8로 디코딩합니다.
      final decodedBody = utf8.decode(response.bodyBytes);
      return ChatbotModel.fromJson(jsonDecode(decodedBody));
    } else {
      // 에러 처리
      print('Failed to load chatbot response: ${response.statusCode}');
      print('토큰은 $accessToken');
      return null;
    }
  }
}
