class NewsDetail {
  int? status;
  Data? data;

  NewsDetail({this.status, this.data});

  NewsDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    data?.reporter = json['data']['reporter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? title;
  String? originalContent;
  String? summarizedContent;
  String? time;
  String? reporter;

  Data(
      {this.title,
      this.originalContent,
      this.summarizedContent,
      this.time,
      this.reporter});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    originalContent = json['originalContent'];
    summarizedContent = json['summarizedContent'];
    time = json['time'];
    reporter = json['reporter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['originalContent'] = originalContent;
    data['summarizedContent'] = summarizedContent;
    data['time'] = time;
    data['reporter'] = reporter;
    return data;
  }
}
