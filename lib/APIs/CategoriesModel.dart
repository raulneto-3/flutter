class Categories {
  List<ChildrenData> childrenData;

  Categories({this.childrenData});

  Categories.fromJson(Map<String, dynamic> json) {
    if (json['children_data'] != null) {
      childrenData = new List<ChildrenData>();
      json['children_data'].forEach((v) {
        childrenData.add(new ChildrenData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.childrenData != null) {
      data['children_data'] = this.childrenData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildrenData {
  int id;
  String name;
  List<SubChildrenData> subChildrenData;

  ChildrenData({this.id, this.name, this.subChildrenData});

  ChildrenData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['children_data'] != null) {
      subChildrenData = new List<SubChildrenData>();
      json['children_data'].forEach((v) {
        subChildrenData.add(new SubChildrenData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.subChildrenData != null) {
      data['children_data'] =
          this.subChildrenData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubChildrenData {
  int id;
  String name;

  SubChildrenData({this.id, this.name});

  SubChildrenData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
