class Profile {
  int id;
  String email;
  String firstname;
  String lastname;
  List<Addresses> addresses;

  Profile({this.id, this.email, this.firstname, this.lastname, this.addresses});

  Profile.fromJson(Map<String, dynamic> json) {
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
  int region_id;
  String countryId;
  String city;
  List<String> street;
  String telephone;
  String postcode;

  Addresses(
      {this.id,
      this.region,
      this.region_id,
      this.countryId,
      this.city,
      this.street,
      this.telephone,
      this.postcode});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    region_id = json['region_id'];
    region =
        json['region'] != null ? new Region.fromJson(json['region']) : null;
    countryId = json['country_id'];
    city = json['city'];
    region_id = json['region_id'];
    street = json['street'].cast<String>();
    telephone = json['telephone'];
    postcode = json['postcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.region != null) {
      data['region'] = this.region.toJson();
    }
    data['id'] = this.id;
    data['region'] = this.region;
    data['region_id'] = this.region_id;
    data['country_id'] = this.countryId;
    data['city'] = this.city;
    data['street'] = this.street;
    data['telephone'] = this.telephone;
    data['postcode'] = this.postcode;
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
