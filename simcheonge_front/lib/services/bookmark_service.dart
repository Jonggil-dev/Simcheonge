import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/models/bookmark_detail.dart';

class BookmarkService {
  static const String _baseUrl = "도메인";
// BookmarkService 클래스 내 getBookmarks 메서드 수정
  Future<List<Bookmark>> getBookmarks(String bookmarkType) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    final Uri url = Uri.parse('$_baseUrl?bookmarkType=$bookmarkType');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedBody);
      final List<dynamic> bookmarksJson = jsonResponse['data'] ?? [];
      List<Bookmark> bookmarks = bookmarksJson
          .map((bookmarkJson) => Bookmark.fromJson(bookmarkJson))
          .toList();

      return bookmarks;
    } else {
      print(
          'Failed to load bookmarks with status code: ${response.statusCode}');

      throw Exception('Failed to load bookmarks');
    }
  }

  Future<int?> createBookmark(String bookmarkType,
      {int? policyId, int? postId}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    Map<String, dynamic> body = {
      'bookmarkType': bookmarkType,
      if (bookmarkType == "POL") 'policyId': policyId,
      if (bookmarkType == "POS") 'postId': postId,
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );
    print('여기여기 ${response.statusCode}');
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // 서버 응답에서 bookmarkId 추출
      return jsonResponse['bookmarkId'];
    } else {
      // 오류 처리: 상태 코드가 200이 아닌 경우, 실패로 간주
      print('Failed to create bookmark: ${response.body}');
      return null; // 실패 시 null 반환
    }
  }

  Future<void> deleteBookmark(int bookmarkId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final response = await http.delete(
      Uri.parse('$_baseUrl/$bookmarkId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('Bookmark deleted successfully');
    } else {
      print('Failed to delete bookmark');
    }
  }
}
