class Cart {
  int id;
  List<Items> items;
  Customer customer;

  Cart({this.id, this.items, this.customer});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Items {
  int item_id;
  String sku;
  int qty;
  String name;
  var price;

  Items({this.sku, this.qty, this.name, this.price});

  Items.fromJson(Map<String, dynamic> json) {
    item_id = json['item_id'];
    sku = json['sku'];
    qty = json['qty'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.item_id;
    data['sku'] = this.sku;
    data['qty'] = this.qty;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class Customer {
  int id;
  String email;
  String firstname;
  String lastname;
  List<Addresses> addresses;

  Customer(
      {this.id, this.email, this.firstname, this.lastname, this.addresses});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    if (json['addresses'] != null) {
      addresses = new List<Addresses>();
      json['addresses'].forEach((v) {
        addresses.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    if (this.addresses != null) {
      data['addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  int id;
  Region region;
  int regionId;
  String countryId;
  List<String> street;
  String telephone;
  String postcode;
  String city;

  Addresses(
      {this.id,
      this.region,
      this.regionId,
      this.countryId,
      this.street,
      this.telephone,
      this.postcode,
      this.city});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    region =
        json['region'] != null ? new Region.fromJson(json['region']) : null;
    regionId = json['region_id'];
    countryId = json['country_id'];
    street = json['street'].cast<String>();
    telephone = json['telephone'];
    postcode = json['postcode'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.region != null) {
      data['region'] = this.region.toJson();
    }
    data['region_id'] = this.regionId;
    data['country_id'] = this.countryId;
    data['street'] = this.street;
    data['telephone'] = this.telephone;
    data['postcode'] = this.postcode;
    data['city'] = this.city;
    return data;
  }
}

class Region {
  String regionCode;
  String region;
  int regionId;

  Region({this.regionCode, this.region, this.regionId});

  Region.fromJson(Map<String, dynamic> json) {
    regionCode = json['region_code'];
    region = json['region'];
    regionId = json['region_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['region_code'] = this.regionCode;
    data['region'] = this.region;
    data['region_id'] = this.regionId;
    return data;
  }
}
