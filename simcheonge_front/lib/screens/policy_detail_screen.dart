import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/models/policy_detail.dart';
import 'package:simcheonge_front/services/policy_service.dart';
import 'package:simcheonge_front/widgets/bookmark_widget.dart';
import 'package:simcheonge_front/widgets/comment_widget.dart';
import 'package:word_break_text/word_break_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simcheonge_front/services/bookmark_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// PolicyDetail 모델 import 필요, 경로는 실제 프로젝트 구조에 따라 달라짐
class PolicyDetailScreen extends StatefulWidget {
  final int policyId;

  const PolicyDetailScreen({
    super.key,
    required this.policyId,
  });

  @override
  State<PolicyDetailScreen> createState() => _PolicyDetailScreenState();
}

class _PolicyDetailScreenState extends State<PolicyDetailScreen> {
  PolicyDetail? policy;
  bool isLoading = true; // 로딩 상태를 관리하는 변수

  @override
  void initState() {
    super.initState();
    _loadPolicyDetail();
    _checkBookmarkStatus();
  }

  Future<void> _loadPolicyDetail() async {
    try {
      final fetchedPolicy =
          await PolicyService.fetchPolicyDetail(widget.policyId);
      setState(() {
        policy = fetchedPolicy;
        isLoading = false; // 데이터 로딩 완료
      });
    } catch (e) {
      setState(() {
        isLoading = false; // 에러 발생 시에도 로딩 상태 업데이트
        print('정책 정보를 불러오는데 실패했습니다: $e');
      });
    }
  }

  Future<void> _checkBookmarkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final url = Uri.parse("도메인");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      });
      if (response.statusCode == 200) {
        List<dynamic> bookmarks = json.decode(response.body);
        final exists = bookmarks.any((bookmark) =>
            bookmark['bookmarkType'] == 'POL' &&
            bookmark['referencedId'] == widget.policyId);
        setState(() {
          policy!.isBookmarked = exists;
        });
      }
    } catch (e) {
      print('Error checking bookmark status: $e');
    }
  }

  Future<void> _toggleBookmark() async {
    if (policy == null) return;

    // 즐겨찾기 추가만 처리
    if (!policy!.isBookmarked) {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      };

      print('isbookmarked : ${policy!.isBookmarked}');
      final url = Uri.parse("도메인");
      final body = json.encode({
        "bookmarkType": "POL",
        "policyId": widget.policyId,
      });

      try {
        final response = await http.post(
          url,
          headers: headers,
          body: body,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            policy!.isBookmarked = true; // 즐겨찾기 상태를 추가됨으로 변경
          });
        } else if (response.statusCode == 400) {
          // 서버로부터의 응답이 이미 즐겨찾기에 추가된 경우
          final responseBody = json.decode(utf8.decode(response.bodyBytes));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("이미 등록된 북마크입니다.")),
          );
          setState(() {
            policy!.isBookmarked = true; // UI를 즉시 반영하기 위해 상태 업데이트
          });
        } else {
          print('Server error: ${response.body}');
        }
      } catch (e) {
        print('Failed to add bookmark: $e');
      }
    }
  }

  Future<void> _deleteBookmarkForPolicy(int policyId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    // 먼저, 북마크 조회
    final getUrl =
        Uri.parse("도메인");
    try {
      final getResponse = await http.get(getUrl, headers: headers);
      if (getResponse.statusCode == 200) {
        final List<dynamic> bookmarks = json.decode(getResponse.body);
        // 북마크 목록에서 해당 policyId를 찾습니다.
        for (var bookmark in bookmarks) {
          if (bookmark['referencedId'] == policyId &&
              bookmark['bookmarkType'] == 'POL') {
            // 북마크 삭제
            final deleteUrl = Uri.parse(
                "도메인");
            final deleteResponse =
                await http.delete(deleteUrl, headers: headers);
            if (deleteResponse.statusCode == 200) {
              print('Bookmark deleted successfully.');
              setState(() {
                policy!.isBookmarked = false;
              });
              return; // 북마크를 성공적으로 삭제한 후 루프를 종료합니다.
            } else {
              print('Failed to delete bookmark: ${deleteResponse.body}');
            }
          }
        }
      } else {
        print('Failed to fetch bookmarks: ${getResponse.body}');
      }
    } catch (e) {
      print('Exception when calling API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading
            ? const Text('Loading...')
            : Text(policy?.policyName ?? 'No Title', // 로딩 완료 후 제목 표시
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          if (!isLoading)
            IconButton(
              icon: Icon(
                policy?.isBookmarked ?? false ? Icons.star : Icons.star_border,
                color: Colors.blue,
              ),
              onPressed: _toggleBookmark,
            ),
        ],
      ),
      body: FutureBuilder<PolicyDetail>(
        future: PolicyService.fetchPolicyDetail(widget.policyId),
        builder: (context, snapshot) {
          // 로딩 중 상태
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 데이터 로드 완료
          if (snapshot.connectionState == ConnectionState.done) {
            // 에러가 발생한 경우
            if (snapshot.hasError) {
              return const Center(child: Text('정책 정보를 불러오는데 실패했습니다.'));
            }

            // 데이터가 있는 경우
            if (snapshot.hasData) {
              final policy = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(policy.policyIntro,
                          style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 16),
                      buildSection('지원 규모', policy.policySupportScale),
                      buildSection(
                          '지원 기간',
                          policy.policyPeriodTypeCode == '상시'
                              ? '상시'
                              : '${_formatDate(policy.policyStartDate)} ~ ${_formatDate(policy.policyEndDate)}'),
                      buildSection('지원 지역', policy.policyArea),
                      buildSection('주관 기관', policy.policyMainOrganization),
                      buildSection('운영 기관', policy.policyOperationOrganization),
                      buildSection('대상 연령', policy.policyAgeInfo),
                      buildSection('학력 요건', policy.policyEducationRequirements),
                      buildSection('전공 요건', policy.policyMajorRequirements),
                      buildSection('고용 상태', policy.policyEmploymentStatus),
                      buildSection('지원 내용', policy.policySupportContent),
                      buildSection('신청 절차', policy.policyApplicationProcedure),
                      buildSection('신청 제한', policy.policyEntryLimit),
                      buildSection('참고 사항', policy.policyEtc),
                      buildWebsiteSection('참고 웹사이트', policy.policySiteAddress),
                      CommentWidget(
                        policyId: widget.policyId,
                        commentType: 'POL',
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('정책 정보를 불러오는데 실패했습니다.'));
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) {
      return '';
    }
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Widget buildSection(String title, String content) {
    if (content.isEmpty) {
      return Container();
    }

    final bracketContents = <String>[];
    var modifiedContent =
        content.replaceAllMapped(RegExp(r'\([^\)]+\)'), (match) {
      bracketContents.add(match.group(0)!);
      return '⌜${bracketContents.length - 1}⌝';
    });

    if (title == '지원 내용' || title == '신청 제한' || title == '참고 사항') {
      modifiedContent =
          modifiedContent.replaceAll(RegExp(r'(\d+)\. '), '\n\$1. ');
      modifiedContent =
          modifiedContent.replaceAll(RegExp(r'[-○●■□◆★☆※❖•] '), '\n- ');
      modifiedContent =
          modifiedContent.replaceAll(RegExp(r'[\u2460-\u2473]'), '\n\$0');
    }
    final splitPattern = RegExp(r'(?<=\n)');
    TextStyle defaultTextStyle =
        TextStyle(color: Colors.grey.shade800, fontSize: 16);
    TextAlign textAlign = TextAlign.start;

    bool isRightAligned = [
      '지원 규모',
      '지원 기간',
      '지원 지역',
      '주관 기관',
      '운영 기관',
      '대상 연령',
      '학력 요건',
      '전공 요건',
      '고용 상태',
      '참고 웹사이트'
    ].contains(title);

    EdgeInsets padding = isRightAligned
        ? const EdgeInsets.only(bottom: 16.0, right: 20.0)
        : const EdgeInsets.only(bottom: 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 4),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 0),
        if (title == '지원 기간' && modifiedContent == '상시') // '지원 기간'이 '상시'인 경우
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '상시',
                style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                textAlign: TextAlign.start,
              ),
            ),
          )
        else // 그 외의 경우
          ...modifiedContent
              .split(splitPattern)
              .where((item) => item.isNotEmpty)
              .map((item) {
            String restoredItem = item.replaceAllMapped(RegExp(r'⌜(\d+)⌝'),
                (match) => bracketContents[int.parse(match.group(1)!)]);
            return Padding(
              padding: isRightAligned
                  ? const EdgeInsets.only(right: 20.0)
                  : EdgeInsets.zero,
              child: Align(
                alignment: isRightAligned
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  restoredItem,
                  style: defaultTextStyle,
                  textAlign: textAlign,
                ),
              ),
            );
          }),
        const SizedBox(height: 5),
        const Divider(),
      ],
    );
  }

  Widget buildWebsiteSection(String title, String url) {
    if (url.isEmpty) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        _launchURL(url.trim());
      },
      child: const Align(
        alignment: Alignment.centerRight,
        child: Text(
          '신청 홈페이지 바로가기',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('주소를 열 수 없습니다: $url');
      }
    } catch (e) {
      print('주소를 열 수 없습니다: $url');
    }
  }
}
