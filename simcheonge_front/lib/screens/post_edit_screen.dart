import 'package:flutter/material.dart';

class PostEditScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostEditScreen({super.key, required this.post});

  @override
  _PostEditScreenState createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _postNameController;
  late TextEditingController _postContentController;
  String? _selectedCategoryNumber;
  final List<Map<String, dynamic>> _categoryOptions = [
    {'name': '정책 추천', 'number': 2},
    {'name': '공모전', 'number': 3},
    {'name': '생활 꿀팁', 'number': 4},
    {'name': '기타', 'number': 5},
  ];

  @override
  void initState() {
    super.initState();
    _postNameController = TextEditingController(text: widget.post['postName']);
    _postContentController =
        TextEditingController(text: widget.post['postContent']);
    _selectedCategoryNumber = _categoryOptions
        .firstWhere(
          (option) => option['number'] == widget.post['categoryNumber'],
          orElse: () => _categoryOptions[0],
        )['number']
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글 수정'),
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
                  items: _categoryOptions.map<DropdownMenuItem<String>>(
                    (Map<String, dynamic> option) {
                      return DropdownMenuItem<String>(
                        value: option['number'].toString(),
                        child: Text(option['name']),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _postNameController,
                  decoration: InputDecoration(
                    labelText:
                        _postNameController.text.isEmpty ? '제목을 입력하세요.' : '',
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
                  controller: _postContentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText:
                        _postContentController.text.isEmpty ? '내용을 입력하세요.' : '',
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
                          final updatedPost = {
                            'postName': _postNameController.text,
                            'postContent': _postContentController.text,
                            'categoryNumber':
                                int.parse(_selectedCategoryNumber!),
                          };
                          Navigator.pop(context, updatedPost);
                        }
                      },
                      child: const Text('수정 완료'),
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
