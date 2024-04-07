import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simcheonge_front/models/filter_model.dart';

class FilterApi {
  static Future<FilterModel> fetchFilters() async {
    final response = await http.get(
        Uri.parse("도메인"),
        headers: {'Accept-Charset': 'utf-8'});

    if (response.statusCode == 200) {
      // JSON 문자열을 Map<String, dynamic>으로 디코딩
      final Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      // 디코딩된 데이터를 FilterModel.fromJson() 메서드에 전달
      return FilterModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load filter options');
    }
  }
}
