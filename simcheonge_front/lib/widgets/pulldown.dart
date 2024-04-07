import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// 재사용 가능한 새로고침 위젯
class RefreshableWidget extends StatelessWidget {
  final Widget child;
  final RefreshController controller;
  final VoidCallback onRefresh;
  final VoidCallback onLoading;

  const RefreshableWidget({
    super.key,
    required this.child,
    required this.controller,
    required this.onRefresh,
    required this.onLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: controller,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
