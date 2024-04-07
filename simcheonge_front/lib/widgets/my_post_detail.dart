class MyPost {
  final int userId;
  final int postId;
  final String postName;
  final String postContent;
  final String userNickname;
  final DateTime createdAt;
  final String categoryName;

  MyPost({
    required this.userId,
    required this.postId,
    required this.postName,
    required this.postContent,
    required this.userNickname,
    required this.createdAt,
    required this.categoryName,
  });

  // JSON에서 MyPost 객체로 변환하는 팩토리 생성자
  factory MyPost.fromJson(Map<String, dynamic> json) {
    return MyPost(
      userId: json['userId'],
      postId: json['postId'],
      postName: json['postName'],
      postContent: json['postContent'],
      userNickname: json['userNickname'],
      createdAt: DateTime.parse(json['createdAt']),
      categoryName: json['categoryName'],
    );
  }
}
