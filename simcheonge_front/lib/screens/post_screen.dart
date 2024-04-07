import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/login_screen.dart';
import 'package:simcheonge_front/screens/post_create_screen.dart';
import 'package:simcheonge_front/screens/post_detail_screen.dart';
import 'package:simcheonge_front/services/post_service.dart';
import 'package:simcheonge_front/widgets/postList_widget.dart';

class DataSearch extends SearchDelegate<String> {
  final List<String> items;

  DataSearch(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? items
        : items
            .where((p) => p.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }
}

Future<String?> getSavedToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final List<Map<String, dynamic>> _categoryOptions = [
    {'number': 1, 'name': '전체'},
    {'number': 2, 'name': '정책 추천'},
    {'number': 3, 'name': '공모전'},
    {'number': 4, 'name': '생활 꿀팁'},
    {'number': 5, 'name': '기타'},
  ];

  int _selectedCategoryNumber = 1;
  late Future<List<dynamic>> _postFuture;
  List<String> postTitles = []; // 게시물 제목을 저장하기 위한 변수

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    _postFuture =
        PostService.fetchPosts(categoryNumber: _selectedCategoryNumber)
            .then((posts) {
      // posts를 'createdAt'을 기준으로 내림차순 정렬
      posts.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
      postTitles = posts.map((post) => post['postName'].toString()).toList();
      return posts;
    });
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _loadPosts();
    });
  }

  void _filterPosts(BuildContext context, int categoryNumber) {
    Navigator.of(context).pop(); // 다이얼로그 닫기
    setState(() {
      _selectedCategoryNumber = categoryNumber; // 선택된 카테고리 번호 업데이트
      _loadPosts(); // 선택된 카테고리에 따라 게시글을 다시 로드
    });
  }

  String getCategoryName(int categoryNumber) {
    var category = _categoryOptions.firstWhere(
      (option) => option['number'] == categoryNumber,
      orElse: () => {'name': '기타'},
    );
    return category['name'];
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('카테고리 선택'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: const Text('전체'),
                  onTap: () => _filterPosts(context, 1),
                ),
                ListTile(
                  title: const Text('정책 추천'),
                  onTap: () => _filterPosts(context, 2),
                ),
                ListTile(
                  title: const Text('공모전'),
                  onTap: () => _filterPosts(context, 3),
                ),
                ListTile(
                  title: const Text('생활 꿀팁'),
                  onTap: () => _filterPosts(context, 4),
                ),
                ListTile(
                  title: const Text('기타'),
                  onTap: () => _filterPosts(context, 5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetailOrLogin(BuildContext context, int postId) async {
    String? token = await getSavedToken();
    if (token == null) {
      // 로그인하지 않았다면, 로그인 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // 로그인했다면, 게시글 상세 화면으로 이동
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: postId)),
      );
      if (result != null) {
        _refreshPosts(); // 목록 새로고침
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(postTitles), // Pass postTitles here
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.create),
              onPressed: () async {
                String? token = await getSavedToken();
                print(token);
                if (token == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostCreateScreen(
                        onPostCreated: () {
                          // 게시글 목록을 다시 로드합니다
                          _refreshPosts();
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshPosts,
          child: FutureBuilder<List<dynamic>>(
            future: _postFuture, // 수정된 부분
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var post = snapshot.data![index];
                      return PostListItem(
                        categoryName: post['categoryName'] ?? '기타',
                        title: post['postName'] ?? '제목 없음',
                        subtitle: post['userNickname'] ?? '익명',
                        date: post['createdAt']?.substring(0, 10) ?? '날짜 정보 없음',
                        onTap: () =>
                            _navigateToDetailOrLogin(context, post['postId']),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('오류 발생: ${snapshot.error}');
                }
                return const Text('데이터가 없습니다.');
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
