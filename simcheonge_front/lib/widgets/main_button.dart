import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String name;
  final String imagePath;
  final bool isInverted;
  final double imageWidth; // 이미지 가로 크기를 위한 변수
  final double imageHeight; // 이미지 세로 크기를 위한 변수
  final _blackColor = const Color(0xFF1F2123);
  final VoidCallback? onPressed;

  const MainButton({
    super.key,
    required this.name,
    required this.imagePath,
    required this.isInverted,
    this.imageWidth = 80.0, // 기본값을 80으로 설정
    this.imageHeight = 80.0, // 기본값을 80으로 설정
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isInverted
              ? const Color.fromARGB(255, 247, 247, 247)
              : _blackColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset(
                imagePath,
                width: imageWidth, // 이미지 가로 크기 조정
                height: imageHeight, // 이미지 세로 크기 조정
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isInverted ? _blackColor : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
