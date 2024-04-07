import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/models/news_detail_model.dart'; // NewsDetail 모델을 정의한 경로로 변경해주세요.

Future<NewsDetail> fetchNewsDetail(String newsLink) async {
  final response = await http.get(
      Uri.parse("도메인"));

  if (response.statusCode == 200) {
    return NewsDetail.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to load news detail');
  }
}
