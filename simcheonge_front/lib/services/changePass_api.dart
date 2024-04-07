// changePass_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> changePassword(String currentPassword, String newPassword) async {
  final prefs = await SharedPreferences.getInstance();
  final url = Uri.parse("도메인");
  final accessToken = prefs.getString('accessToken');
  print(accessToken);
  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    }),
  );
  print('여기여기 ${response.statusCode}');
  if (response.statusCode == 200) {
    return true; // 비밀번호 변경 성공
  } else {
    return false; // 비밀번호 변경 실패
  }
}
