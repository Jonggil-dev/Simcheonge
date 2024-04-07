import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/models/e_word_model.dart';

class EWordAPI {
  Future<EWord?> fetchEconomicWord() async {
    final url = Uri.parse("도메인");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // UTF-8 인코딩을 사용하여 디코드합니다.
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(responseBody);
      // 여기서 EWord 객체를 생성하여 반환합니다.
      return EWord.fromJson(jsonResponse);
    } else {
      print('Failed to load economic word');
      return null;
    }
  }
}
