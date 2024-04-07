import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/bookmark_policy_screen.dart';
import 'package:simcheonge_front/screens/bookmark_post_screen.dart';
import 'package:simcheonge_front/screens/my_policy_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_comment_screen.dart';
import 'package:simcheonge_front/screens/my_post_screen.dart';
import 'package:simcheonge_front/auth/auth_service.dart';
import 'package:simcheonge_front/services/updateNick_api.dart';
import 'package:simcheonge_front/widgets/changePass.dart';

class SideAppBar extends StatefulWidget {
  final Function(int) changePage;
  const SideAppBar({super.key, required this.changePage});

  @override
  _SideAppBarState createState() => _SideAppBarState();
}

class _SideAppBarState extends State<SideAppBar> {
  bool isNicknameAvailable = false; // 중복 확인 후 변경 버튼 활성화를 위한 변수
  Future<String> _getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userNickname') ?? '사용자';
  }

  void loginSuccess() async {
    setState(() {
      // 상태 업데이트로 SideAppBar 포함한 화면 재빌드
    });
  }

  Future<void> _showChangeNicknameDialog() async {
    TextEditingController nicknameController = TextEditingController();
    bool isButtonDisabled = true;
    String? nicknameValidationMessage;
    Color? messageColor;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("닉네임 변경"),
              content: SingleChildScrollView(
                // 스크롤 가능하도록 감싸기
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: nicknameController,
                      decoration:
                          const InputDecoration(hintText: "새 닉네임을 입력하세요"),
                      onChanged: (value) async {
                        final isAvailable = await checkNickname(value);
                        setState(() {
                          isButtonDisabled = !isAvailable;
                          if (value.isNotEmpty) {
                            nicknameValidationMessage = isAvailable
                                ? "사용 가능한 닉네임 입니다."
                                : "사용할 수 없는 닉네임 입니다.";
                            messageColor =
                                isAvailable ? Colors.green : Colors.red;
                          } else {
                            nicknameValidationMessage = null;
                          }
                        });
                      },
                    ),
                    if (nicknameValidationMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          nicknameValidationMessage!,
                          style: TextStyle(color: messageColor),
                        ),
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // 버튼을 양 끝으로 배치
                  children: [
                    TextButton(
                      child: const Text('취소'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      onPressed: isButtonDisabled
                          ? null
                          : () async {
                              bool updateSuccess =
                                  await updateNickname(nicknameController.text);
                              if (updateSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "닉네임이 '${nicknameController.text}'(으)로 변경되었습니다.")),
                                );
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    'userNickname', nicknameController.text);
                                Navigator.of(context).pop(); // 상태 변경 전에 닫기
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("닉네임 변경에 실패했습니다. 다시 시도해주세요.")),
                                );
                              }
                            },
                      child: const Text('변경'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // 다이얼로그 닫힘 후 필요한 UI 갱신만 수행
      if (mounted) {
        // 위젯 트리에 아직 존재하는지 확인
        setState(() {
          // 여기서 필요한 UI 갱신 로직을 추가
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Theme(
        data: Theme.of(context).copyWith(
          // ExpansionTile의 divider 색상을 투명하게 설정
          dividerColor: Colors.transparent,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FutureBuilder<String>(
                      future: _getNickname(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                            child: UserAccountsDrawerHeader(
                              accountName: Text(
                                snapshot.data!, // Future에서 가져온 닉네임 사용
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w600),
                              ),
                              accountEmail: const Text(
                                '환영합니다',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w300),
                              ),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(107, 127, 212, 1),
                              ),
                            ),
                          );
                        } else {
                          // 데이터를 불러오는 동안 표시할 위젯
                          return const SizedBox(
                            height: 200.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                    ExpansionTile(
                      leading: Icon(
                        Icons.draw,
                        color: Colors.grey[850],
                      ),
                      title: const Text(
                        '내가 쓴 글',
                        style: TextStyle(fontSize: 20),
                      ),
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            print('게시글 클릭됨');
                            Navigator.pop(context);

                            widget.changePage(5);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('게시글', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('게시글 댓글 클릭됨');
                            Navigator.pop(context);
                            widget.changePage(6);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('게시글 댓글', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('정책 댓글 클릭됨');
                            Navigator.pop(context);
                            widget.changePage(7);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 70.0,
                                ),
                                Text(
                                  '정책 댓글',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(
                        Icons.bookmarks,
                        color: Colors.grey[850],
                      ),
                      title: const Text('책갈피', style: TextStyle(fontSize: 20)),
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            print('책갈피 항목 1 클릭됨');
                            Navigator.pop(context);
                            widget.changePage(8);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('정책', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('책갈피 항목 2 클릭됨');
                            Navigator.pop(context);
                            widget.changePage(9);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70.0),
                                Text('게시글', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: Icon(FontAwesomeIcons.userPen,
                          color: Colors.grey[850]),
                      title:
                          const Text('내 정보 관리', style: TextStyle(fontSize: 20)),
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _showChangeNicknameDialog();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 70,
                                ),
                                Text(
                                  '닉네임 변경',
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context); // 현재 열려있는 드로어나 다이얼로그를 닫습니다.
                            showChangePasswordDialog(
                                context); // 비밀번호 변경 다이얼로그를 표시하는 함수 호출
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Row(
                              children: <Widget>[
                                SizedBox(width: 70),
                                Text(
                                  '비밀번호 변경',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color.fromRGBO(107, 127, 212, 1),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  '로그아웃',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  // 로그아웃 기능 구현
                  logout(context);
                  print('로그아웃');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
