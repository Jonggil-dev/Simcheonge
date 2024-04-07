import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavItem {
  IconData iconData;
  IconData activeIconData;
  String label;

  BottomNavItem({
    required this.iconData,
    required this.activeIconData,
    required this.label,
  });
}

final List<BottomNavItem> bottomNavItems = [
  BottomNavItem(
      iconData: Icons.home_outlined, activeIconData: Icons.home, label: '홈'),
  BottomNavItem(
      iconData: Icons.search_outlined,
      activeIconData: Icons.search,
      label: '검색'),
  BottomNavItem(
      iconData: CupertinoIcons.chat_bubble,
      activeIconData: CupertinoIcons.chat_bubble_fill,
      label: '챗봇'),
  BottomNavItem(
      iconData: Icons.newspaper_outlined,
      activeIconData: Icons.newspaper,
      label: '뉴스'),
  BottomNavItem(
      iconData: Icons.people_outline,
      activeIconData: Icons.people,
      label: '게시판'),
];
