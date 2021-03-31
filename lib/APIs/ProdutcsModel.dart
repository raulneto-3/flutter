class Products {
  List<Items> items;
  SearchCriteria searchCriteria;

  int totalCount;

  Products({this.items, this.searchCriteria, this.totalCount});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    searchCriteria = json['search_criteria'] != null
        ? new SearchCriteria.fromJson(json['search_criteria'])
        : null;
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.searchCriteria != null) {
      data['search_criteria'] = this.searchCriteria.toJson();
    }
    data['total_count'] = this.totalCount;

    return data;
  }
}

class Items {
  int id;
  String sku;
  String name;
  var price;
  int status;

  Items({this.id, this.sku, this.name, this.price, this.status});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sku'] = this.sku;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    return data;
  }
}

class SearchCriteria {
  int pageSize;
  int currentPage;

  SearchCriteria({this.pageSize, this.currentPage});

  SearchCriteria.fromJson(Map<String, dynamic> json) {
    pageSize = json['page_size'];
    currentPage = json['current_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_size'] = this.pageSize;
    data['current_page'] = this.currentPage;
    return data;
  }
}
