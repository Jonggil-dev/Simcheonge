import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/models/search_model.dart';
import 'package:flutter/material.dart'; // debugPrint를 사용하기 위해 추가

class SearchApi {
  Future<SearchModel> searchPolicies(
      Map<String, dynamic> requestBody, int page) async {
    final url = Uri.parse(
        "도메인"); // 페이지 번호 추가

    debugPrint('Request body: ${jsonEncode(requestBody)}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      return SearchModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load policies');
    }
  }
}
