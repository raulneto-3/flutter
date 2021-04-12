import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:mercado_na_nuvem/APIs/OrdersModel.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:mercado_na_nuvem/Widgets/SearchScreenProducts.dart';

import 'OrderDetailScreen.dart';

class OrderListScroll extends StatefulWidget {
  final userData;

  const OrderListScroll({Key key, this.userData}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _OrderListScrollState();
  }
}

class _OrderListScrollState extends State<OrderListScroll> {
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text('Meus Pedidos'))
            : TextField(
                onChanged: (value) {
                  search = value;
                },
                onSubmitted: (value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Search(
                                search: search,
                              )));
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Search(
                                      search: search,
                                    )));
                      },
                    ),
                    hintText: "Pesquisar",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      filteredCountries = countries;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                )
        ],
      ),
      body: Paginator.listView(
        key: paginatorGlobalKey,
        pageLoadFuture: sendGetOrderRequest,
        pageItemsGetter: listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: loadingWidgetMaker,
        errorWidgetBuilder: errorWidgetMaker,
        emptyListWidgetBuilder: emptyListWidgetMaker,
        totalItemsGetter: totalPagesGetter,
        pageErrorChecker: pageErrorChecker,
        scrollPhysics: BouncingScrollPhysics(),
      ),
    );
  }

  Future<GetOrder> sendGetOrderRequest(int page) async {
    try {
      final String url = 'http://' +
          base_url +
          '/rest/V1/orders?searchCriteria[filterGroups][0][filters][0][field]=customer_id&searchCriteria[filterGroups][0][filters][0][value]=' +
          widget.userData.id.toString() +
          '&searchCriteria[sortOrders][0][field]=entity_id&searchCriteria[sortOrders][0][direction]=DESC&searchCriteria[pageSize]=15&fields=items[payment[additional_information],shipping_description,base_shipping_amount,billing_address,items[name,price,sku,qty_ordered],status,increment_id,created_at,customer_firstname,customer_lastname,grand_total,entity_id],total_count,search_criteria[page_size,current_page]&searchCriteria[currentPage]=' +
          page.toString();
      http.Response response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + '1bbiuz9u0u9ruroxl7dkn1z36qty4khx',
      });
      return GetOrder.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return GetOrder.withError('Please check your internet connection.');
      } else {
        return GetOrder.withError('Something went wrong.');
      }
    }
  }

  List<dynamic> listItemsGetter(GetOrder getOrder) {
    List<Items> list = [];
    getOrder.products.items.forEach((value) {
      list.add(value);
    });
    return list;
  }

  Widget listItemBuilder(value, int index) {
    var statusPTB;
    if (value.status == 'aguardando_separacao') {
      statusPTB = 'Aguardando Separação';
    } else if (value.status == 'separacao') {
      statusPTB = 'Em Separação';
    } else if (value.status == 'aguardando_entrega') {
      statusPTB = 'Aguardando Entrega';
    } else if (value.status == 'pending') {
      statusPTB = 'Aguardando Aprovação';
    } else if (value.status == 'complete') {
      statusPTB = 'Pedido Entregue';
    }
    return Card(
      elevation: 5,
      shadowColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(3, 4, 3, 3),
            child: Text(
              value.incrementId,
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(" Data:"),
                Text(value.createdAt.toString())
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 10, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text(" Status: "), Text(statusPTB)],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 10, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'R\$ ' +
                      format
                          .format(value.grandTotal)
                          .replaceAll('.', '_')
                          .replaceAll(',', '.')
                          .replaceAll('_', ','),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                FlatButton(
                  disabledTextColor: Colors.black12,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailScreen(order: value)));
                  },
                  child: Text(
                    "Detalhes",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 160.0,
      child: CircularProgressIndicator(),
    );
  }

  Widget errorWidgetMaker(GetOrder getOrder, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(getOrder.errorMessage),
        ),
        FlatButton(
          onPressed: retryListener,
          child: Text('Retry'),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(GetOrder getOrder) {
    return Center(
      child: Text('No countries in the list'),
    );
  }

  int totalPagesGetter(GetOrder getOrder) {
    return getOrder.products.totalCount;
  }

  bool pageErrorChecker(GetOrder getOrder) {
    return getOrder.statusCode != 200;
  }
}
