import 'dart:convert';
import 'package:http/http.dart' as http;

class Order {
  List<Items> items;
  SearchCriteria searchCriteria;
  int totalCount;

  Order({this.items, this.searchCriteria, this.totalCount});

  Order.fromJson(Map<String, dynamic> json) {
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
  String createdAt;
  String customerFirstname;
  String customerLastname;
  int entityId;
  var grandTotal;
  String incrementId;
  String shippingDescription;
  var baseShippingAmount;
  String status;
  List<ProductsOrder> items;
  BillingAddress billingAddress;
  Payment payment;
  Items(
      {this.createdAt,
      this.customerFirstname,
      this.customerLastname,
      this.entityId,
      this.grandTotal,
      this.incrementId,
      this.shippingDescription,
      this.baseShippingAmount,
      this.status,
      this.items,
      this.billingAddress,
      this.payment});

  Items.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    customerFirstname = json['customer_firstname'];
    customerLastname = json['customer_lastname'];
    entityId = json['entity_id'];
    grandTotal = json['grand_total'];
    incrementId = json['increment_id'];
    shippingDescription = json['shipping_description'];
    baseShippingAmount = json['base_shipping_amount'];
    status = json['status'];
    if (json['items'] != null) {
      items = new List<ProductsOrder>();
      json['items'].forEach((v) {
        items.add(new ProductsOrder.fromJson(v));
      });
    }
    billingAddress = json['billing_address'] != null
        ? new BillingAddress.fromJson(json['billing_address'])
        : null;
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['customer_firstname'] = this.customerFirstname;
    data['customer_lastname'] = this.customerLastname;
    data['entity_id'] = this.entityId;
    data['grand_total'] = this.grandTotal;
    data['increment_id'] = this.incrementId;
    data['shipping_description'] = this.shippingDescription;
    data['base_shipping_amount'] = this.baseShippingAmount;
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    return data;
  }
}

class ProductsOrder {
  String name;
  var price;
  int qtyOrdered;
  String sku;

  ProductsOrder({this.name, this.price, this.qtyOrdered, this.sku});

  ProductsOrder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    qtyOrdered = json['qty_ordered'];
    sku = json['sku'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['qty_ordered'] = this.qtyOrdered;
    data['sku'] = this.sku;
    return data;
  }
}

class BillingAddress {
  String addressType;
  String city;
  String company;
  String countryId;
  int customerAddressId;
  String email;
  int entityId;
  String firstname;
  String lastname;
  int parentId;
  String postcode;
  String region;
  String regionCode;
  int regionId;
  List<String> street;
  String telephone;

  BillingAddress(
      {this.addressType,
      this.city,
      this.company,
      this.countryId,
      this.customerAddressId,
      this.email,
      this.entityId,
      this.firstname,
      this.lastname,
      this.parentId,
      this.postcode,
      this.region,
      this.regionCode,
      this.regionId,
      this.street,
      this.telephone});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    addressType = json['address_type'];
    city = json['city'];
    company = json['company'];
    countryId = json['country_id'];
    customerAddressId = json['customer_address_id'];
    email = json['email'];
    entityId = json['entity_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    parentId = json['parent_id'];
    postcode = json['postcode'];
    region = json['region'];
    regionCode = json['region_code'];
    regionId = json['region_id'];
    street = json['street'].cast<String>();
    telephone = json['telephone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_type'] = this.addressType;
    data['city'] = this.city;
    data['company'] = this.company;
    data['country_id'] = this.countryId;
    data['customer_address_id'] = this.customerAddressId;
    data['email'] = this.email;
    data['entity_id'] = this.entityId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['parent_id'] = this.parentId;
    data['postcode'] = this.postcode;
    data['region'] = this.region;
    data['region_code'] = this.regionCode;
    data['region_id'] = this.regionId;
    data['street'] = this.street;
    data['telephone'] = this.telephone;
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

class Payment {
  List<String> additionalInformation;

  Payment({this.additionalInformation});

  Payment.fromJson(Map<String, dynamic> json) {
    additionalInformation = json['additional_information'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['additional_information'] = this.additionalInformation;
    return data;
  }
}

class GetOrder {
  Order products;
  int statusCode;
  String errorMessage;

  GetOrder.fromResponse(http.Response response) {
    this.statusCode = response.statusCode;
    products = Order.fromJson(jsonDecode(response.body));
  }

  GetOrder.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
