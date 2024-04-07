import 'package:flutter/material.dart';
import 'package:simcheonge_front/services/changePass_api.dart';

Future<void> showChangePasswordDialog(BuildContext context) async {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? currentPasswordErrorMessage; // 현재 비밀번호 에러 메시지
  String? confirmPasswordErrorMessage; // 비밀번호 확인 에러 메시지

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("비밀번호 변경"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: currentPasswordController,
                    decoration: InputDecoration(
                      hintText: "현재 비밀번호",
                      errorText: currentPasswordErrorMessage,
                    ),
                    obscureText: true,
                  ),
                  TextField(
                    controller: newPasswordController,
                    decoration: const InputDecoration(hintText: "새 비밀번호"),
                    obscureText: true,
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: "비밀번호 확인",
                      errorText: confirmPasswordErrorMessage, // 여기에 에러 메시지를 표시
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        // 새 비밀번호와 확인이 일치하는지 확인하여 에러 메시지를 업데이트
                        confirmPasswordErrorMessage =
                            newPasswordController.text == value
                                ? null
                                : "비밀번호가 일치하지 않습니다.";
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                onPressed: newPasswordController.text ==
                            confirmPasswordController.text &&
                        newPasswordController.text.isNotEmpty
                    ? () async {
                        final success = await changePassword(
                          currentPasswordController.text,
                          newPasswordController.text,
                        );
                        if (success) {
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("비밀번호 변경이 완료되었습니다"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          setState(() {
                            // "비밀번호를 확인하세요." 메시지를 현재 비밀번호 필드 아래에 표시
                            currentPasswordErrorMessage = "비밀번호를 확인하세요.";
                          });
                        }
                      }
                    : null, // 비밀번호 불일치시 버튼 비활성화
                child: const Text('변경'),
              ),
            ],
            actionsAlignment:
                MainAxisAlignment.spaceBetween, // 액션 버튼을 양쪽 끝으로 정렬
          );
        },
      );
    },
  );
}
