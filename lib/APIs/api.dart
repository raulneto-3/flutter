import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mercado_na_nuvem/APIs/ProdutcsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CartModel.dart';
import 'CategoriesModel.dart';
import 'EndOrderModel.dart';
import 'OrdersModel.dart';
import 'ProfileModel.dart';
import 'config.dart';

Future<Categories> fetchCategories() async {
  final String url = 'http://' +
      base_url +
      '/rest/default/V1/categories?searchCriteria=0&fields=children_data[id,name,product_count,children_data[id,product_count,name]]&searchCriteria[sortOrders][0][field]=name&searchCriteria[sortOrders][0][direction]=ASC';
  final response = await http.get(url, headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + '1bbiuz9u0u9ruroxl7dkn1z36qty4khx',
  });

  if (response.statusCode == 200) {
    return Categories.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Erro ao carregar as Categorias');
  }
}

Future<Products> fetchProducts(
    int page, int categorieId, int option, String search) async {
  var url;
  if (option == 0) {
    url = 'http://' +
        base_url +
        '/rest/V1/products?searchCriteria[filterGroups][0][filters][0][field]=category_id& searchCriteria[filterGroups][0][filters][0][value]=' +
        categorieId.toString() +
        '&searchCriteria[filterGroups][0][filters][0][conditionType]=eq&searchCriteria[sortOrders][0][field]=name&searchCriteria[sortOrders][0][direction]=ASC&fields=items[id,sku,name,price,status],total_count,search_criteria[page_size,current_page]&searchCriteria[pageSize]=15&searchCriteria[currentPage]=' +
        page.toString();
  } else if (option == 1) {
    url = 'http://' +
        base_url +
        '/rest/V1/products?fields=items[id,sku,name,price,status],total_count,search_criteria[page_size,current_page]&searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=%' +
        search +
        '%&searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=%' +
        search +
        '&searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=' +
        search +
        '%&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[pageSize]=15&searchCriteria[currentPage]=' +
        page.toString();
  }
  final response = await http.get(url, headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + '1bbiuz9u0u9ruroxl7dkn1z36qty4khx',
  });
  if (response.statusCode == 200) {
    return Products.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Erro ao carregar os Produtos');
  }
}

Future editProfile(account, email, lastname, firstname) async {
  final String url =
      'https://' + base_url + '/rest/V1/customers/' + account.id.toString();

  final response = await http.put(url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + "1bbiuz9u0u9ruroxl7dkn1z36qty4khx",
      },
      body: jsonEncode({
        "customer": {
          "id": account.id,
          "email": email,
          "firstname": firstname,
          "lastname": lastname,
        },
      }));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<Cart> getCart() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  final String url = 'https://' +
      base_url +
      '/rest/V1/carts/mine?fields=id,customer[id,email,firstname,lastname,addresses[id,region_id,region,city,country_id,street,telephone,postcode]],items[item_id,sku,qty,name,price]';
  final response = await http.get(url, headers: {
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "Bearer " + token,
  });

  if (response.statusCode == 200) {
    return Cart.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Erro ao carregar o Perfil');
  }
}

Future<Profile> fetchProfile() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  final String url = 'http://' +
      base_url +
      '/rest/V1/customers/me?fields=id,email,firstname,lastname,addresses[id,region,region_id,city,country_id,street,telephone,postcode]';
  final response = await http.get(url, headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token,
  });

  if (response.statusCode == 200) {
    return Profile.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Erro ao carregar o Perfil');
  }
}

Future updateItem(sku, qty, quoteId) async {
  final String url = 'https://' + base_url + '/rest/V1/mercadonanuvem/cart/qty';
  final response = await http.post(url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + "m10vj020hinr57gzoq3j376cgl9f0hfi",
      },
      body:
          jsonEncode({"sku": sku, "qty": qty, "quote_id": quoteId.toString()}));

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Erro ao Adicionar no Carrinha');
  }
}

Future<EndOrder> endOrder(String id) async {
  final String url = 'http://' +
      base_url +
      '/rest/V1/orders/' +
      id +
      '?fields=increment_id,status,shipping_amount,grand_total,shipping_description,items[created_at,name,price,qty_ordered],billing_address[city,region_code,street,base_shipping_amount],payment[additional_information]';
  final response = await http.get(url, headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + '1bbiuz9u0u9ruroxl7dkn1z36qty4khx',
  });

  if (response.statusCode == 200) {
    return EndOrder.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Erro ao carregar os Pedidos');
  }
}
