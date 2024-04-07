// title_bar.dart 파일
import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // 타이틀을 전달받습니다.
  final GlobalKey<ScaffoldState> scaffoldKey; // Scaffold의 키를 전달받습니다.

  const TitleBar({
    super.key,
    required this.title,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 0.0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // AppBar의 기본 높이를 반환합니다.
}
