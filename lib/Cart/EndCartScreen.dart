import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/EndOrderModel.dart';
import 'package:mercado_na_nuvem/APIs/api.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:mercado_na_nuvem/Widgets/SearchScreenProducts.dart';

import '../main.dart';

class EndCartCreate extends StatefulWidget {
  final order;
  const EndCartCreate({Key key, this.order});
  @override
  _EndCartCreateState createState() => _EndCartCreateState();
}

class _EndCartCreateState extends State<EndCartCreate> {
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];
  Future<EndOrder> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder = endOrder(widget.order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text("Carrinho"))
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
      body: FutureBuilder<EndOrder>(
          future: futureOrder,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var statusPTB;
              if (snapshot.data.status == 'aguardando_separacao') {
                statusPTB = 'Aguardando Separação';
              } else if (snapshot.data.status == 'separacao') {
                statusPTB = 'Em Separação';
              } else if (snapshot.data.status == 'aguardando_entrega') {
                statusPTB = 'Aguardando Entrega';
              } else if (snapshot.data.status == 'pending') {
                statusPTB = 'Aguardando Aprovação';
              } else if (snapshot.data.status == 'complete') {
                statusPTB = 'Pedido Entregue';
              }
              return Container(
                  child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Pedido Confirmado",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.lightBlue[900]),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('            Produtos',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text('Qtde',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          DataColumn(
                            label: Text(
                              'Valor',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          snapshot.data.items.length,
                          (index) => DataRow(
                            color: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected))
                                return Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08);
                              if (index % 2 == 0)
                                return Colors.grey.withOpacity(0.3);
                              return null;
                            }),
                            cells: [
                              DataCell(Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    snapshot.data.items[index].name,
                                    textAlign: TextAlign.center,
                                  ))),
                              DataCell(Center(
                                  child: Text(
                                      (snapshot.data.items[index].qtyOrdered)
                                          .toString()))),
                              DataCell(Center(
                                  child: Text(format
                                      .format(snapshot.data.items[index].price)
                                      .replaceAll('.', '_')
                                      .replaceAll(',', '.')
                                      .replaceAll('_', ',')))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(3, 4, 3, 3),
                          child: Text(
                            statusPTB,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Divider(),
                        Text(snapshot.data.payment.additionalInformation[0]),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(" " + snapshot.data.shippingDescription),
                            Text("R\$ " +
                                format
                                    .format(snapshot.data.shippingAmount)
                                    .replaceAll('.', '_')
                                    .replaceAll(',', '.')
                                    .replaceAll('_', ',') +
                                " ")
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(snapshot.data.billingAddress.street[0] +
                            ", " +
                            snapshot.data.billingAddress.street[1] +
                            " - " +
                            snapshot.data.billingAddress.street[2] +
                            ", " +
                            snapshot.data.billingAddress.city +
                            " / " +
                            snapshot.data.billingAddress.regionCode),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              " Total",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "R\$ " +
                                  snapshot.data.grandTotal.toString() +
                                  " ",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ));
            }
            return Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
            ));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          heroTag: 'bt1',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BottomNavBar(page: 0)));
          },
          child: Icon(Icons.home),
        ),
      ),
    );
  }
}
