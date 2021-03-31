import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/ProdutcsModel.dart';
import 'package:mercado_na_nuvem/APIs/api.dart';
import 'package:intl/intl.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';

import 'ProductsDetailScreen.dart';

class ProductListScreen extends StatefulWidget {
  final page;
  final categorieId;
  final name;
  final option;
  final search;
  const ProductListScreen(
      {Key key,
      this.page,
      this.categorieId,
      this.name,
      this.option,
      this.search})
      : super(key: key);
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Future<Products> futureProducts;
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];

  @override
  void initState() {
    super.initState();

    futureProducts = fetchProducts(
        widget.page, widget.categorieId, widget.option, widget.search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text(widget.name))
            : TextField(
                onChanged: (value) {
                  search = value;
                },
                onSubmitted: (value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListScreen(
                                page: 1,
                                categorieId: 0,
                                name: search,
                                search: search,
                                option: 1,
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
                                builder: (context) => ProductListScreen(
                                      page: 1,
                                      categorieId: 0,
                                      name: search,
                                      option: 1,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
              child: FutureBuilder<Products>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.items != null) {
                  return Scaffold(
                      body: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.items.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Container(
                                      height: 110,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailScreen(
                                                          product: snapshot.data
                                                              .items[index])));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 80,
                                                child: Image.network(
                                                  'https://mercadonanuvem.s3-sa-east-1.amazonaws.com/webp/' +
                                                      snapshot.data.items[index]
                                                          .sku +
                                                      '.webp',
                                                  width: 80,
                                                  height: 80,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      snapshot.data.items[index]
                                                          .name,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Divider(),
                                                    Text(
                                                      "R\$ " +
                                                          format
                                                              .format(snapshot
                                                                  .data
                                                                  .items[index]
                                                                  .price)
                                                              .replaceAll(
                                                                  '.', '_')
                                                              .replaceAll(
                                                                  ',', '.')
                                                              .replaceAll(
                                                                  '_', ','),
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                      floatingActionButton: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                              backgroundColor: Colors.blue,
                              heroTag: 'bt1',
                              onPressed: () {
                                if (widget.page != 1) {
                                  var nextPage = widget.page - 1;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductListScreen(
                                                  page: nextPage,
                                                  categorieId:
                                                      widget.categorieId,
                                                  name: widget.name,
                                                  option: widget.option)));
                                }
                              },
                              child: Icon(Icons.arrow_back),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.8,
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.blue,
                              heroTag: 'bt2',
                              onPressed: () {
                                var itens =
                                    snapshot.data.searchCriteria.currentPage *
                                        snapshot.data.searchCriteria.pageSize;
                                if (itens >= snapshot.data.totalCount) {
                                } else {
                                  var nextPage = widget.page + 1;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductListScreen(
                                                  page: nextPage,
                                                  categorieId:
                                                      widget.categorieId,
                                                  name: widget.name,
                                                  option: widget.option)));
                                }
                              },
                              child: Icon(Icons.arrow_forward),
                            )
                          ],
                        ),
                      ));
                } else {
                  return Text('erro');
                }
              }
              return Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
              ));
            },
          )),
        ],
      ),
    );
  }
}
