// 가정: MyComment 모델
class MyComment {
  final int commentId;
  final String commentType;
  final int referencedId;
  final String content;
  final String createdAt;

  MyComment({
    required this.commentId,
    required this.commentType,
    required this.referencedId,
    required this.content,
    required this.createdAt,
  });

  factory MyComment.fromJson(Map<String, dynamic> json) {
    return MyComment(
      commentId: json['commentId'],
      commentType: json['commentType'],
      referencedId: json['referencedId'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }
}
