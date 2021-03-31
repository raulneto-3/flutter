import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/OrdersModel.dart';
import 'package:mercado_na_nuvem/APIs/api.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:mercado_na_nuvem/Categories/ProductListScreen.dart';

import 'OrderDetailScreen.dart';

class OrderListScreen extends StatefulWidget {
  final page;
  final userData;
  const OrderListScreen({Key key, this.page, this.userData});
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  Future<Order> futureOrder;
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];

  @override
  void initState() {
    super.initState();
    futureOrder = fetchOrders(widget.page, widget.userData.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text("Meus Pedidos"))
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
              child: FutureBuilder<Order>(
            future: futureOrder,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                    body: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.items.length,
                            itemBuilder: (context, index) {
                              var statusPTB;
                              if (snapshot.data.items[index].status ==
                                  'aguardando_separacao') {
                                statusPTB = 'Aguardando Separação';
                              } else if (snapshot.data.items[index].status ==
                                  'separacao') {
                                statusPTB = 'Em Separação';
                              } else if (snapshot.data.items[index].status ==
                                  'aguardando_entrega') {
                                statusPTB = 'Aguardando Entrega';
                              } else if (snapshot.data.items[index].status ==
                                  'pending') {
                                statusPTB = 'Aguardando Aprovação';
                              } else if (snapshot.data.items[index].status ==
                                  'complete') {
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
                                        snapshot.data.items[index].incrementId,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(" Data:"),
                                          Text(snapshot
                                              .data.items[index].createdAt
                                              .toString())
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(" Status: "),
                                          Text(statusPTB)
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'R\$ ' +
                                                format
                                                    .format(snapshot
                                                        .data
                                                        .items[index]
                                                        .grandTotal)
                                                    .replaceAll('.', '_')
                                                    .replaceAll(',', '.')
                                                    .replaceAll('_', ','),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          FlatButton(
                                            disabledTextColor: Colors.black12,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetailScreen(
                                                              order: snapshot
                                                                      .data
                                                                      .items[
                                                                  index])));
                                            },
                                            child: Text(
                                              "Detalhes",
                                              style:
                                                  TextStyle(color: Colors.blue),
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
                                            OrderListScreen(page: nextPage)));
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
                                        builder: (context) => OrderListScreen(
                                              page: nextPage,
                                            )));
                              }
                            },
                            child: Icon(Icons.arrow_forward),
                          )
                        ],
                      ),
                    ));
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
