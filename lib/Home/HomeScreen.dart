import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:mercado_na_nuvem/APIs/ProdutcsModel.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:mercado_na_nuvem/Categories/ProductsDetailScreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Paginator.gridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 3 / 5,
          crossAxisSpacing: 5,
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 20,
        ),
        key: paginatorGlobalKey,
        pageLoadFuture: sendGetProductsRequest,
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

  Future<GetProducts> sendGetProductsRequest(int page) async {
    try {
      var url =
          'http://mercadonanuvem.com/rest/V1/products?searchCriteria[filterGroups][0][filters][0][field]=category_id& searchCriteria[filterGroups][0][filters][0][value]=2&searchCriteria[filterGroups][0][filters][0][conditionType]=eq&searchCriteria[sortOrders][0][field]=name&searchCriteria[sortOrders][0][direction]=ASC&fields=items[id,sku,name,price,status],total_count,search_criteria[page_size,current_page]&searchCriteria[pageSize]=10&searchCriteria[currentPage]=' +
              page.toString();
      http.Response response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + '1bbiuz9u0u9ruroxl7dkn1z36qty4khx',
      });
      return GetProducts.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return GetProducts.withError(
            'Por favor, verifique sua conexão à internet.');
      } else {
        return GetProducts.withError('Algo deu errado.');
      }
    }
  }

  List<dynamic> listItemsGetter(GetProducts getProducts) {
    List<Items> list = [];
    getProducts.products.items.forEach((value) {
      list.add(value);
    });
    return list;
  }

  Widget listItemBuilder(value, int index) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: value)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Image.network(
                  'https://mercadonanuvem.s3-sa-east-1.amazonaws.com/webp/' +
                      value.sku +
                      '.webp',
                  width: 130,
                  height: 130,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value.name,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                    "R\$ " +
                        format
                            .format(value.price)
                            .replaceAll('.', '_')
                            .replaceAll(',', '.')
                            .replaceAll('_', ','),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    )),
              ),
            ),
          ],
        ),
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

  Widget errorWidgetMaker(GetProducts getProducts, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(getProducts.errorMessage),
        ),
        FlatButton(
          onPressed: retryListener,
          child: Text('Retry'),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(GetProducts getProducts) {
    return Center(
      child: Text('Nenhum produto na lista'),
    );
  }

  int totalPagesGetter(GetProducts getProducts) {
    return getProducts.products.totalCount;
  }

  bool pageErrorChecker(GetProducts getProducts) {
    return getProducts.statusCode != 200;
  }
}
