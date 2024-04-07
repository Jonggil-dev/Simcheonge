class FilterModel {
  int? status;
  List<Data>? data;

  FilterModel({this.status, this.data});

  FilterModel.fromJson(Map<String, dynamic> json) {
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
  String? tag;
  List<CategoryList>? categoryList;

  Data({this.tag, this.categoryList});

  Data.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    if (json['categoryList'] != null) {
      categoryList = <CategoryList>[];
      json['categoryList'].forEach((v) {
        categoryList!.add(CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag'] = tag;
    if (categoryList != null) {
      data['categoryList'] = categoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  String? code;
  String? name;
  String? number; // number 필드 추가

  CategoryList({this.code, this.name, this.number});

  CategoryList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    number = json['number']; // JSON 생성자 수정
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['number'] = number; // toJson 수정
    return data;
  }
}
