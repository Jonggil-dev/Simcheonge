class Bookmark {
  final int bookmarkId;
  final String bookmarkType;
  final int userId;
  final int? referencedId;
  final String? policyName;
  final String? postName;

  Bookmark({
    required this.bookmarkId,
    required this.bookmarkType,
    required this.userId,
    this.referencedId,
    this.policyName,
    this.postName,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    print('Bookmark.fromJson: $json'); // 로깅 추가
    return Bookmark(
      bookmarkId: json['bookmarkId'] as int,
      bookmarkType: json['bookmarkType'] as String,
      userId: json['userId'] as int,
      referencedId: json['referencedId'] as int?,
      policyName: json['policyName'] as String?,
      postName: json['postName'] as String?,
    );
  }
}
