import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/models/bookmark_detail.dart';
import 'package:simcheonge_front/services/bookmark_service.dart';

class BookmarkWidget extends StatefulWidget {
  final String bookmarkType; // "POL" 또는 "POS"
  final int? policyId;
  final int? postId;

  const BookmarkWidget({
    super.key,
    required this.bookmarkType,
    this.policyId,
    this.postId,
  });

  @override
  State<BookmarkWidget> createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  bool _isBookmarked = false;
  int? _bookmarkId;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginAndBookmarkStatus();
  }

  Future<void> _checkLoginAndBookmarkStatus() async {
    final isLoggedIn = await _checkLoginStatus();
    if (!isLoggedIn) {
      setState(() => _isLoggedIn = false);
      return;
    }
    setState(() => _isLoggedIn = true);

    await _checkBookmarkStatus(); // 로그인 되어 있을 경우, 북마크 상태 확인
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') != null;
  }

  Future<void> _checkBookmarkStatus() async {
    try {
      final bookmarks =
          await BookmarkService().getBookmarks(widget.bookmarkType);
      for (var bookmark in bookmarks) {
        if ((widget.bookmarkType == 'POL' &&
                bookmark.referencedId == widget.policyId) ||
            (widget.bookmarkType == 'POS' &&
                bookmark.referencedId == widget.postId)) {
          setState(() {
            _isBookmarked = true;
            _bookmarkId = bookmark.bookmarkId;
          });
          return;
        }
      }
      // If loop completes without finding a match, it means not bookmarked
      setState(() {
        _isBookmarked = false;
        _bookmarkId = null;
      });
    } catch (e) {
      setState(() {
        _isBookmarked = false;
        _bookmarkId = null;
      });
    }
  }

  Future<void> _updateBookmarkStatus() async {
    final isLoggedIn = await _checkLoginStatus();
    if (!isLoggedIn) return;

    final bookmarks = await BookmarkService().getBookmarks(widget.bookmarkType);
    final currentUserId =
        await _getUserIdFromPreferences(); // Assuming you store userId in SharedPreferences

    // Search for a bookmark matching the current screen's policy or post ID
    Bookmark? foundBookmark = bookmarks.firstWhere(
      (bookmark) =>
          bookmark.referencedId ==
              (widget.bookmarkType == 'POL'
                  ? widget.policyId
                  : widget.postId) &&
          bookmark.userId == currentUserId,
    );

    setState(() {
      _isBookmarked = foundBookmark != null;
      _bookmarkId = foundBookmark.bookmarkId;
    });
  }

  Future<int?> _getUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    // 'userId'는 SharedPreferences에 저장된 사용자 ID 키를 가정합니다.
    return prefs.getInt('userId');
  }

  void _toggleBookmark() async {
    if (!_isLoggedIn) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('로그인이 필요합니다.')));
      return;
    }

    try {
      if (_isBookmarked) {
        await BookmarkService().deleteBookmark(_bookmarkId!);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('북마크가 삭제되었습니다.')));
      } else {
        final newBookmarkId = await BookmarkService().createBookmark(
            widget.bookmarkType,
            policyId: widget.policyId,
            postId: widget.postId);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('북마크에 추가되었습니다.')));
        if (newBookmarkId != null) _bookmarkId = newBookmarkId;
      }
      await _checkLoginAndBookmarkStatus();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('작업 중 오류가 발생했습니다: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로그인 되어 있지 않으면 아무것도 표시하지 않음
    if (!_isLoggedIn) return const SizedBox.shrink();

    return IconButton(
      icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      color: _isBookmarked ? Colors.yellow : null,
      onPressed: _toggleBookmark,
    );
  }
}
