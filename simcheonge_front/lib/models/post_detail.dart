class MyPostResponse {
  final int userId;
  final int postId;
  final String postName;
  final String postContent;
  final String userNickname;
  final DateTime createdAt;
  final String categoryName;

  MyPostResponse({
    required this.userId,
    required this.postId,
    required this.postName,
    required this.postContent,
    required this.userNickname,
    required this.createdAt,
    required this.categoryName,
  });

  factory MyPostResponse.fromJson(Map<String, dynamic> json) {
    return MyPostResponse(
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
