import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationManager {
  static const _serverUrl = "도메인";

  // 토큰 유효성 검사 및 갱신
  static Future<bool> checkAndRefreshTokenIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');
    // final accessToken = prefs.getString('accessToken');

    if (refreshToken == null) {
      // 리프레시 토큰이 없으면 로그인 화면으로
      return false;
    }

    // 리프레시 토큰으로 새로운 토큰 요청
    final response = await http.post(
      Uri.parse('$_serverUrl/reissue'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      // 토큰 갱신 성공, 새 토큰 저장
      final data = jsonDecode(response.body);
      await prefs.setString('accessToken', data['accessToken']);
      return true;
    } else {
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken'); // 토큰 갱신 실패, 로그인 화면으로
      return false;
    }
  }
}
