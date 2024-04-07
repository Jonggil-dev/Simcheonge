import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/post_screen.dart';

typedef PostCreatedCallback = void Function();

class PostCreateScreen extends StatefulWidget {
  final PostCreatedCallback? onPostCreated;

  const PostCreateScreen({super.key, this.onPostCreated});

  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategoryNumber;
  final List<Map<String, dynamic>> _categoryOptions = [
    {'name': '정책 추천', 'number': 2},
    {'name': '공모전', 'number': 3},
    {'name': '생활 꿀팁', 'number': 4},
    {'name': '기타', 'number': 5},
  ];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _userNickname;

  @override
  void initState() {
    super.initState();
    _loadUserNickname();
  }

  Future<void> _loadUserNickname() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userNickname = prefs.getString('userNickname');
    });
  }

  Future<void> _createPost() async {
    if (_selectedCategoryNumber == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('카테고리를 선택해주세요.')));
      return;
    }
    final prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('accessToken');

    final url = Uri.parse("도메인");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': "application/json; charset=UTF-8",
        'Authorization': "Bearer $accessToken",
      },
      body: jsonEncode({
        'postName': _titleController.text,
        'postContent': _contentController.text,
        'categoryCode': 'POS',
        'categoryNumber': int.parse(_selectedCategoryNumber!),
        'userNickname': _userNickname,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('게시글 작성에 성공했습니다.'),
        duration: Duration(milliseconds: 500),
      ));
      Navigator.pop(context, true); // 현재 화면을 닫습니다
      widget.onPostCreated?.call(); // 콜백 함수 호출하여 PostScreen에게 알립니다
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('게시글 작성에 실패했습니다.'),
        duration: Duration(milliseconds: 500),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글 작성'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryNumber,
                  hint: const Text('게시판 선택'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategoryNumber = newValue!;
                    });
                  },
                  items:
                      _categoryOptions.map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option['number'].toString(),
                      child: Text(option['name']),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText:
                        _titleController.text.isEmpty ? '제목을 입력하세요.' : '',
                    hintText: '제목',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력해주세요.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                  minLines: 1,
                  maxLines: 5,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText:
                        _contentController.text.isEmpty ? '내용을 입력하세요.' : '',
                    hintText: '내용',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '내용을 입력해주세요.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                  minLines: 10,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // 모든 validator를 통과하면 _createPost 함수 호출
                          _createPost();
                        }
                      },
                      child: const Text('작성 완료'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
