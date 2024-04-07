import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/models/comment_detail.dart';
import 'package:simcheonge_front/screens/my_post_comment_screen.dart';
import 'package:simcheonge_front/screens/policy_detail_screen.dart';
import 'package:simcheonge_front/screens/post_detail_screen.dart';
import 'package:simcheonge_front/services/post_service.dart';

class MyPostCommentScreen extends StatefulWidget {
  const MyPostCommentScreen({super.key});

  @override
  _MyPostCommentScreenState createState() => _MyPostCommentScreenState();
}

class _MyPostCommentScreenState extends State<MyPostCommentScreen> {
  List<Comment> comments = [];
  List<Comment> displayedComments = []; // 필터링된 댓글의 리스트
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMyPostComments();
    _controller.addListener(() {
      updateSearchQuery(_controller.text);
    });
  }

  Future<void> _fetchMyPostComments() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final url = Uri.parse("도메인");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print('나는 프론트의왕 서준하다 ${response.statusCode}');
      if (response.statusCode == 200) {
        // 명시적으로 UTF-8로 디코드
        final responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(responseBody);
        final List<dynamic> fetchedComments = data['data'];
        setState(() {
          comments =
              fetchedComments.map((json) => Comment.fromJson(json)).toList();
        });
      } else {
        print('서버 오류: ${response.body}');
      }
    } catch (e) {
      print('데이터 로드 실패: $e');
    }
  }

  Future<void> _filterComments(String query) async {
    if (query.isEmpty) {
      // 검색어가 비어있을 경우 초기 댓글 목록을 불러오거나 다른 로직을 수행
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    const String commentType = "POS"; // 예시로 "POL"을 사용, 필요에 따라 변경
    final url = Uri.parse(
        "도메인");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> fetchedComments = data['data'];
        setState(() {
          comments =
              fetchedComments.map((json) => Comment.fromJson(json)).toList();
        });
      } else {
        print('서버 오류: ${response.body}');
      }
    } catch (e) {
      print('데이터 로드 실패: $e');
    }
  }

  void updateSearchQuery(String newQuery) {
    if (mounted) {
      setState(() {
        displayedComments = newQuery.isNotEmpty
            ? comments
                .where((comments) => comments.content
                    .toLowerCase()
                    .contains(newQuery.toLowerCase()))
                .toList()
            : comments;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // 컨트롤러를 정리합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: '검색...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                    },
                  )
                : null,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchMyPostComments,
        child: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return InkWell(
              onTap: () {
                // 여기에 탭했을 때 실행할 로직을 추가합니다. 예를 들어, 상세 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(
                      postId: comment.referencedId,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      comment.content,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )), // 긴 텍스트 처리를 위해 Expanded 사용

                    Text(
                      comment.createdAt,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: MyPostCommentScreen()));
}
