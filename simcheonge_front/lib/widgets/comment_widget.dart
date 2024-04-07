import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentWidget extends StatefulWidget {
  final int? postId;
  final int? policyId;
  final String commentType;

  const CommentWidget({
    super.key,
    this.policyId,
    this.postId,
    required this.commentType,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  List<dynamic> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('accessToken');
      String url0 = '';
      print(widget.postId);

      if (widget.commentType == 'POS') {
        url0 =
            "도메인";
      } else if (widget.commentType == 'POL') {
        url0 =
            "도메인";
      } else {
        // postId 또는 policyId가 제공되지 않았을 때의 처리
        print('Error: No valid ID provided for the comment type.');
        return;
      }

      final url = Uri.parse(url0);
      print(url);
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedData = json.decode(responseBody);

        setState(() {
          _comments = parsedData['data'];
        });
      } else {
        print('Failed to load comments: ${response.body}');
      }
    } catch (e) {
      print('CommentWidget: 댓글 로딩 중 예외 발생 - $e');
    }
  }

  Future<void> _addComment(String content) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final url = Uri.parse("도메인");

    int? referencedId;
    if (widget.commentType == 'POS') {
      referencedId = widget.postId;
    } else if (widget.commentType == 'POL') {
      referencedId = widget.policyId;
    }

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'commentType': widget.commentType,
          'referencedId': referencedId,
          'content': content,
        }));

    if (response.statusCode == 200) {
      _commentController.clear();
      _fetchComments();
    } else {
      print('Failed to add comment: ${response.body}');
    }
  }

  Future<void> _deleteComment(int commentId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final url = Uri.parse("도메인");
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      _fetchComments();
    } else {
      print('Failed to delete comment: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            final comment = _comments[index];
            print('코멘트는 $comment["isMyComment"]');

            return ListTile(
              title: Text(comment['content']),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Text(comment['nickname'] ?? 'Unknown'),
                  ),
                  Text(
                    comment['createAt'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: comment['myComment'] == true
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('댓글 삭제'),
                              content: const Text('댓글을 삭제하시겠습니까?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                  },
                                  child: const Text('아니오'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    _deleteComment(
                                        comment['id']); // 댓글 삭제 메소드 호출
                                  },
                                  child: const Text('예'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  : null,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: '댓글 추가...',
                  ),
                ),
              ),
              InkWell(
                onTap: () => _addComment(_commentController.text),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
