import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/main.dart';
import 'package:simcheonge_front/screens/login_screen.dart';

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  return accessToken != null;
}

void logout(BuildContext context) async {
  final bool confirmLogout = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('아니오'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('예'),
            ),
          ],
        ),
      ) ??
      false;

  if (confirmLogout) {
    final prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString('refreshToken');
    final String? accessToken = prefs.getString('accessToken');
    print(accessToken);
    print(refreshToken);
    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse("도메인"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      print('로그아웃 요청 응답: ${response.statusCode}');
      Navigator.of(context).pop(); // 팝업 닫기

      if (response.statusCode == 200) {
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const MyHomePage()), // 여기 수정 필요
        );
      } else {
        try {
          final body = response.body;
          print('response');
          print(response);
          print('서버로부터 받은 응답: $body');
          if (body.isEmpty) {
            throw const FormatException('No response body.');
          }
          final data = jsonDecode(body);
          final errorMessage = data['message'] ?? 'Unknown error';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        } catch (e) {
          print('로그아웃 중 오류 발생: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그아웃에 실패하였습니다.')),
          );
        }
      }
    } else {
      print('refreshToken이 없습니다.');
    }
  }
}
