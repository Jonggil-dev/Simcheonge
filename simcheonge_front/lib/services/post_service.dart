import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/widgets/my_post_detail.dart';
import 'package:simcheonge_front/models/post_detail.dart';

class PostService {
  static const String _baseUrl = "도메인";

  static Future<Map<String, dynamic>> fetchPostDetail(int postId) async {
    final url = Uri.parse('$_baseUrl/$postId');
    final prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('accessToken');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': "Bearer $accessToken", // JWT 토큰을 여기에 삽입
      },
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes); // UTF-8로 디코딩
      final decodedJson = json.decode(responseBody);
      return decodedJson['data'];
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('로그인이 필요 합니다.');
    } else {
      throw Exception('게시글을 불러오는 데 실패했습니다.');
    }
  }

  List<Map<String, dynamic>> categoryOptions = [
    {'name': '정책 추천', 'number': 2},
    {'name': '공모전', 'number': 3},
    {'name': '생활 꿀팁', 'number': 4},
    {'name': '기타', 'number': 5},
  ];

  int? findCategoryNumber(String categoryName) {
    final category = categoryOptions.firstWhere(
      (option) => option['name'] == categoryName,
      orElse: () => {'number': null},
    );
    return category['number'];
  }

  static Future<List<dynamic>> fetchPosts(
      {int? categoryNumber, String keyword = ''}) async {
    // 올바른 URI 구성
    final url = Uri.parse(
        '$_baseUrl?categoryCode=POS&categoryNumber=${categoryNumber ?? 1}&keyword=$keyword');

    final prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('accessToken');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      }, // 필요에 따라 헤더 추가
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes); // UTF-8로 디코딩
      final decodedJson = json.decode(responseBody);
      return decodedJson['data'];
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<void> updatePost(
      int postId, Map<String, dynamic> updatedPost) async {
    final prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('accessToken');
    final url = Uri.parse('$_baseUrl/$postId');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'categoryNumber': updatedPost['categoryNumber'], // 2~5 중 하나
        'postName': updatedPost['postName'],
        'postContent': updatedPost['postContent'],
        'categoryCode': 'POS', // 고정 값
      }),
    );

    if (response.statusCode != 200) {
      print(updatedPost);
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      throw Exception('Failed to update post');
    }
  }

  static Future<bool> deletePost(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final url = Uri.parse('$_baseUrl/$postId');

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': "Bearer $accessToken",
      },
    );

    return response.statusCode == 200;
  }

  static Future<List<MyPost>> getMyPosts(
      String categoryCode, int categoryNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final url = Uri.parse(
        '$_baseUrl/my?categoryCode=$categoryCode&categoryNumber=$categoryNumber');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes); // UTF-8로 디코딩
      final decodedJson = json.decode(responseBody);

      List<dynamic> jsonList = decodedJson['data'];
      List<MyPost> posts =
          jsonList.map((jsonItem) => MyPost.fromJson(jsonItem)).toList();
      return posts;
    } else {
      throw Exception('Failed to load my posts');
    }
  }
}
