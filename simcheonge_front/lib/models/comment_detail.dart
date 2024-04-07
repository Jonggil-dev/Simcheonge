// Comment 모델 정의
class Comment {
  final int commentId;
  final String commentType;
  final int referencedId;
  final String content;
  final String createdAt;

  Comment({
    required this.commentId,
    required this.commentType,
    required this.referencedId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'],
      commentType: json['commentType'],
      referencedId: json['referencedId'],
      content: json['content'],
      createdAt: json['createAt'],
    );
  }
}
