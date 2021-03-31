class EndOrder {
  int grandTotal;
  String incrementId;
  String shippingDescription;
  int shippingAmount;
  String status;
  List<Items> items;
  BillingAddress billingAddress;
  Payment payment;

  EndOrder(
      {this.grandTotal,
      this.incrementId,
      this.shippingDescription,
      this.shippingAmount,
      this.status,
      this.items,
      this.billingAddress,
      this.payment});

  EndOrder.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grand_total'];
    incrementId = json['increment_id'];
    shippingAmount = json['shipping_amount'];
    shippingDescription = json['shipping_description'];
    status = json['status'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
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
    data['grand_total'] = this.grandTotal;
    data['increment_id'] = this.incrementId;
    data['shipping_amount'] = this.shippingAmount;
    data['shipping_description'] = this.shippingDescription;
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

class Items {
  String createdAt;
  String name;
  int price;
  int qtyOrdered;

  Items({this.createdAt, this.name, this.price, this.qtyOrdered});

  Items.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    name = json['name'];
    price = json['price'];
    qtyOrdered = json['qty_ordered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['name'] = this.name;
    data['price'] = this.price;
    data['qty_ordered'] = this.qtyOrdered;
    return data;
  }
}

class BillingAddress {
  String city;
  String regionCode;
  List<String> street;

  BillingAddress({this.city, this.regionCode, this.street});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    regionCode = json['region_code'];
    street = json['street'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['region_code'] = this.regionCode;
    data['street'] = this.street;
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
