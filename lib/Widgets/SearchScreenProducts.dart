import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:mercado_na_nuvem/APIs/ProdutcsModel.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:mercado_na_nuvem/Categories/ProductsDetailScreen.dart';

class Search extends StatefulWidget {
  final search;

  const Search({Key key, this.search}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<Search> {
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
            ? Center(child: Text(widget.search))
            : TextField(
                onChanged: (value) {
                  search = value;
                },
                onSubmitted: (value) {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Search(
                  //               page: 1,
                  //               categorieId: 0,
                  //               name: search,
                  //               search: search,
                  //               option: 1,
                  //             )));
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Search(
                        //               page: 1,
                        //               categorieId: 0,
                        //               name: search,
                        //               option: 1,
                        //             )));
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
      var url = 'http://' +
          base_url +
          '/rest/V1/products?fields=items[id,sku,name,price,status],total_count,search_criteria[page_size,current_page]&searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=%' +
          widget.search +
          '%&searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=%' +
          widget.search +
          '&searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=' +
          widget.search +
          '%&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[pageSize]=15&searchCriteria[currentPage]=' +
          page.toString();
      http.Response response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + '1bbiuz9u0u9ruroxl7dkn1z36qty4khx',
      });
      return GetProducts.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return GetProducts.withError('Please check your internet connection.');
      } else {
        return GetProducts.withError('Something went wrong.');
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
      child: Text('No countries in the list'),
    );
  }

  int totalPagesGetter(GetProducts getProducts) {
    return getProducts.products.totalCount;
  }

  bool pageErrorChecker(GetProducts getProducts) {
    return getProducts.statusCode != 200;
  }
}
