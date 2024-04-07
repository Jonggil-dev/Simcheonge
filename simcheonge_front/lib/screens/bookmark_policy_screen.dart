import 'package:flutter/material.dart';
import 'package:simcheonge_front/models/bookmark_detail.dart';
import 'package:simcheonge_front/screens/policy_detail_screen.dart';
import 'package:simcheonge_front/services/bookmark_service.dart';

class BookmarkPolicyScreen extends StatefulWidget {
  const BookmarkPolicyScreen({super.key});

  @override
  State<BookmarkPolicyScreen> createState() => _BookmarkPolicyScreenState();
}

class _BookmarkPolicyScreenState extends State<BookmarkPolicyScreen> {
  List<Bookmark> bookmarkedItems = [];
  bool _isLoading = true; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedItems();
  }

  Future<void> _fetchBookmarkedItems() async {
    try {
      setState(() {
        _isLoading = true; // 데이터 로딩 시작
      });
      final bookmarks = await BookmarkService().getBookmarks('POL');

      // 디버깅 코드: 가져온 북마크 목록의 내용을 콘솔에 출력
      print('북마크 목록:');
      print('북마크 ㅣ $bookmarks');
      for (var bookmark in bookmarks) {
        print(
            'BookmarkId: ${bookmark.bookmarkId}, Type: ${bookmark.bookmarkType}, '
            'ReferencedId: ${bookmark.referencedId}, PolicyName: ${bookmark.policyName}');
      }
      setState(() {
        bookmarkedItems = bookmarks;
        _isLoading = false; // 데이터 로딩 완료
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // 에러 발생 시 로딩 상태 해제
      });
      print('북마크를 가져오는 데 실패했습니다: $e');
    }
  }

  void _removeBookmark(int bookmarkId, int index) async {
    try {
      await BookmarkService().deleteBookmark(bookmarkId);
      setState(() {
        bookmarkedItems.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('북마크가 삭제되었습니다.'),
      ));
    } catch (e) {
      print('북마크 삭제 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('북마크 삭제에 실패했습니다.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 북마크'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchBookmarkedItems,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // 로딩 인디케이터 표시
            : ListView.builder(
                itemCount: bookmarkedItems.length,
                itemBuilder: (context, index) {
                  final bookmark = bookmarkedItems[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: ListTile(
                      title: Text(
                        bookmark.policyName ??
                            '정책 이름 없음', // Bookmark 모델에 policyName이 있다고 가정
                        softWrap: true,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        print(bookmark);
                        print('북북북 ${bookmark.referencedId}');
                        print('북구북 $bookmarkedItems');

                        // referencedId를 이용하여 PolicyDetailScreen으로 네비게이션
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PolicyDetailScreen(
                              policyId: bookmark.referencedId ??
                                  0, // 여기서 referencedId를 policyId 파라미터에 전달
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
