import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:simcheonge_front/services/chatbot_api.dart'; // ChatbotAPI 경로 확인 필요

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _messages.insert(0, {
      'text': '안녕하세요.\n정책 검색 AI 심청이 입니다.\n원하시는 서비스의 내용을\n입력해보세요!',
      'sender': 'bot',
      'loading': false,
    });
  }

  void _resetMessages() {
    setState(() {
      _messages.clear(); // 모든 메시지를 지우고
      // 초기 메시지를 다시 삽입합니다.
      _messages.insert(0, {
        'text': '안녕하세요.\n정책 검색 AI 심청이 입니다.\n원하시는 서비스의 내용을\n입력해보세요!',
        'sender': 'bot',
        'loading': false,
      });
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (String status) => print('onStatus: $status'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
            if (val.finalResult) {
              _handleUserInput(val.recognizedWords);
              _isListening = false; // Listening을 끝냅니다.
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _handleUserInput(String text) async {
    setState(() {
      _messages.insert(0, {
        'text': text,
        'sender': 'user',
        'loading': false,
      });
      _messages.insert(0, {
        'text': '잠시만 기다려 주세요...',
        'sender': 'bot',
        'loading': true,
      });
      _controller.clear();
    });

    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );

    try {
      final chatbotResponse = await ChatbotAPI.postUserInput(text);
      if (chatbotResponse != null) {
        setState(() {
          _messages[0] = {
            'text': chatbotResponse.data?.result ?? '응답을 받아오지 못했습니다.',
            'sender': 'bot',
            'loading': false,
          };
        });
      } else {
        setState(() {
          _messages[0] = {
            'text': '인터넷 연결을 확인하세요.',
            'sender': 'bot',
            'loading': false,
          };
        });
      }
    } catch (e) {
      setState(() {
        _messages[0] = {
          'text': '에러가 발생했습니다: $e',
          'sender': 'bot',
          'loading': false,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton(
            onPressed: _resetMessages,
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            ),
            child: const Text('대화 삭제'),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final bool isUserMessage = message['sender'] == 'user';
                      final bool isLoadingMessage = message['loading'] ?? false;
                      final BorderRadius messageBorderRadius = isUserMessage
                          ? BorderRadius.circular(20.0)
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(0),
                            );

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: isUserMessage
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isUserMessage)
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0, top: 5.0),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/bot_image.png'), // 아이콘 이미지 경로 확인 필요
                                  radius: 25,
                                ),
                              ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                                decoration: BoxDecoration(
                                  color: isUserMessage
                                      ? Colors.blue[200]
                                      : Colors.grey[200],
                                  borderRadius: messageBorderRadius,
                                ),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          message['text'] ?? '',
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      if (isLoadingMessage)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          ),
                                        ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 16.0, right: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: '메시지를 입력하세요...',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              border: InputBorder.none,
                              prefixIcon: GestureDetector(
                                onTap: _listen,
                                child: Icon(
                                  _isListening ? Icons.mic : Icons.mic_none,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            onSubmitted: (text) => _handleUserInput(text),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (_controller.text.isNotEmpty) {
                            _handleUserInput(_controller.text);
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(11),
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
