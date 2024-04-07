import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/main.dart';
import 'package:simcheonge_front/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(bool)? updateLoginStatus; // nullable 타입으로 변경

  const LoginScreen(
      {super.key, this.updateLoginStatus}); // required를 제거하고 기본값을 null로 설정

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  Future<void> login() async {
    // 입력 필드가 비어 있는지 확인
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID 혹은 비밀번호를 입력해주세요')),
      );
      return; // 함수 종료
    }

    final url = Uri.parse("도메인"); // 주소 수정
    final requestData = jsonEncode({
      'userLoginId': _idController.text,
      'userPassword': _passwordController.text,
      'userNickname': _nicknameController.text,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestData,
    );

    if (response.statusCode == 200) {
      // 로그인 성공 처리
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      print(data);
      await _saveToken(data['data']['accessToken'],
          data['data']['refreshToken'], data['data']['userNickname']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인에 성공했습니다.'),
          duration: Duration(seconds: 1),
        ),
      );
      print(data['data']['accessToken']);
      widget.updateLoginStatus?.call(true);
      // 로그인 성공 시 홈 화면으로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      // 응답 본문이 JSON 형식인지 확인 후, 적절한 에러 메시지 표시
      try {
        final decodedBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(decodedBody);
        final errorMessage = responseData['message'] ?? '로그인에 실패했습니다.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        print(e);
        // JSON 형식이 아닌 경우 기본 에러 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID 혹은 비밀번호가 잘못되었습니다.'),
            duration: Duration(milliseconds: 500), // 지속 시간을 800밀리초(0.8초)로 설정
          ),
        );
      }
    }
  }

  Future<void> _saveToken(
      String accessToken, String refreshToken, String userNickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
    await prefs.setString('userNickname', userNickname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID',
                hintText: '아이디를 입력하세요',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'PW',
                hintText: '비밀번호를 입력하세요',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('로그인'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
