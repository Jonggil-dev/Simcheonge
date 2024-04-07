import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/post_detail_screen.dart';
import 'package:simcheonge_front/services/post_service.dart';
import 'package:simcheonge_front/widgets/my_post_detail.dart';
import 'package:intl/intl.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  _MyPostScreenState createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen>
    with WidgetsBindingObserver {
  List<MyPost> allItems = []; // MyPost 객체의 리스트
  List<MyPost> displayedItems = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMyPosts();
    _controller.addListener(() {
      updateSearchQuery(_controller.text);
    });
  }

  Future<void> _loadMyPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      try {
        final posts = await PostService.getMyPosts('POS', 1);
        setState(() {
          allItems = posts;
          displayedItems = allItems;
        });
      } catch (e) {
        // 에러 처리
        print('Error fetching posts: $e');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 앱이 다시 활성화 될 때(_loadMyPosts를 호출해야 하는 상황) 콘텐츠를 새로고침합니다.
    if (state == AppLifecycleState.resumed) {
      _loadMyPosts();
    }
  }

  void updateSearchQuery(String newQuery) {
    if (mounted) {
      setState(() {
        displayedItems = newQuery.isNotEmpty
            ? allItems
                .where((post) => post.postName
                    .toLowerCase()
                    .contains(newQuery.toLowerCase()))
                .toList()
            : allItems;
      });
    }
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
        onRefresh: _loadMyPosts,
        child: ListView.builder(
          itemCount: displayedItems.length,
          itemBuilder: (context, index) {
            final item = displayedItems[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PostDetailScreen(postId: item.postId)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.postName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(item.createdAt),
                      style: const TextStyle(
                        fontSize: 14.0,
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

void main() => runApp(const MaterialApp(home: MyPostScreen()));
