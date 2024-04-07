class EWord {
  int? status;
  Data? data;

  EWord({this.status, this.data});

  EWord.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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
  int? economicWordId;
  String? word;
  String? description;

  Data({this.economicWordId, this.word, this.description});

  Data.fromJson(Map<String, dynamic> json) {
    economicWordId = json['economicWordId'];
    word = json['word'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['economicWordId'] = economicWordId;
    data['word'] = word;
    data['description'] = description;
    return data;
  }
}
