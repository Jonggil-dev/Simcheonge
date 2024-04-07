class NewsList {
  int? status;
  List<Data>? data;

  NewsList({this.status, this.data});

  NewsList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? title;
  String? description;
  String? publisher;
  String? link;

  Data({this.title, this.description, this.publisher, this.link});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    publisher = json['publisher'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['publisher'] = publisher;
    data['link'] = link;
    return data;
  }
}
