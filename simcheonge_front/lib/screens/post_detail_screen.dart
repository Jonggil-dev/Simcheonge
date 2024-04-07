import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/post_edit_screen.dart';
import 'package:simcheonge_front/services/post_service.dart';
import 'package:simcheonge_front/widgets/bookmark_widget.dart';
import 'package:simcheonge_front/widgets/comment_widget.dart'; // 댓글 위젯 import

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Map<String, dynamic> post = {}; // 초기 게시물 데이터를 저장할 변수
  String? currentUserNickname;
  @override
  void initState() {
    super.initState();
    _loadCurrentUserNickname();
    _loadPostDetail(); // 게시물 상세 정보를 로드하는 로직
  }

  Future<void> _loadCurrentUserNickname() async {
    currentUserNickname = await getSavedUserNickname();
    setState(() {});
  }

  Future<String?> getSavedUserNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userNickname');
  }

  Future<void> _loadPostDetail() async {
    final fetchedPost = await PostService.fetchPostDetail(widget.postId);
    setState(() {
      post = fetchedPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true); // 항상 true를 반환하여 새로고침을 유도
        return true; // 시스템이 뒤로 가기 액션을 자동으로 처리하도록 함
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('게시글 상세'),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: PostService.fetchPostDetail(widget.postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final post = snapshot.data!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                post['categoryName'] ?? '카테고리 없음',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.blue.shade800),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: () {
                              print(widget.postId);
                              BookmarkWidget(
                                bookmarkType: 'POS', // 'POS' 타입으로 북마크 위젯 설정
                                postId: widget.postId, // 현재 게시물 ID 전달
                              );
                              // 북마크 로직 구현
                            },
                          ),
                          if (post['userNickname'] == currentUserNickname) ...[
                            // if (isOwner)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final updatedPost =
                                    await Navigator.push<Map<String, dynamic>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PostEditScreen(post: post),
                                  ),
                                );

                                if (updatedPost != null) {
                                  await PostService.updatePost(
                                      widget.postId, updatedPost);
                                  setState(() {});
                                  // 게시글 수정 후 새로고침 등의 로직이 필요한 경우 여기에 구현
                                }
                              },
                            ),
                            // if (isOwner)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final bool confirm = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("게시글 삭제"),
                                      content: const Text("정말로 게시글을 삭제하시겠습니까?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("취소"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text("삭제"),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm) {
                                  final bool deleted =
                                      await PostService.deletePost(
                                          post['postId']);
                                  if (deleted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('게시글이 삭제되었습니다.')));
                                    Navigator.of(context)
                                        .pop(true); // 게시글 목록 화면으로 돌아가기
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('작성한 게시글만 삭제할 수 있습니다.')));
                                  }
                                }
                              },
                            ),
                          ],
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          post['postName'] ?? '제목 없음',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // 양쪽 끝에 자식들을 정렬
                        children: [
                          Text('작성자 : ${post['userNickname']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight
                                      .w200)), // 여기서는 작성자 닉네임 등의 실제 데이터를 표시하도록 변경할 수 있습니다.
                          Text(
                            '작성일: ${post['createdAt'].substring(0, 10)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          post['postContent'] ?? '내용 없음',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      CommentWidget(
                        postId: widget.postId,
                        commentType: 'POS',
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('데이터 로딩 중 에러가 발생했습니다.'));
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
