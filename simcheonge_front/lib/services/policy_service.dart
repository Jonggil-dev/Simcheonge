import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/models/policy_detail.dart';

class PolicyService {
  static const String _baseUrl = "도메인";

  static Future<PolicyDetail> fetchPolicyDetail(int policyId) async {
    final url = Uri.parse('$_baseUrl/$policyId');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json; charset=UTF-8",
    });
    print('fetchPolicyDetail Response: ${response.body}'); // 로깅 추가

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes); // UTF-8로 디코딩
      print("Server Response: $responseBody"); // 서버 응답 로그 출력

      final decodedJson = json.decode(responseBody);
      // 'data' 필드에서 필요한 정보를 추출합니다.
      final policyData = decodedJson['data'];
      return PolicyDetail.fromJson(policyData);
    } else {
      throw Exception('Failed to load policy detail');
    }
  }
}
