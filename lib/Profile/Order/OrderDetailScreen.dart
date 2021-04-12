import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:mercado_na_nuvem/Widgets/SearchScreenProducts.dart';

class OrderDetailScreen extends StatefulWidget {
  final order;
  const OrderDetailScreen({Key key, this.order});
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];

  @override
  Widget build(BuildContext context) {
    var statusPTB;
    if (widget.order.status == 'aguardando_separacao') {
      statusPTB = 'Aguardando Separação';
    } else if (widget.order.status == 'separacao') {
      statusPTB = 'Em Separação';
    } else if (widget.order.status == 'aguardando_entrega') {
      statusPTB = 'Aguardando Entrega';
    } else if (widget.order.status == 'pending') {
      statusPTB = 'Aguardando Aprovação';
    } else if (widget.order.status == 'complete') {
      statusPTB = 'Pedido Entregue';
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text(widget.order.incrementId))
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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.6,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.lightBlue[900]),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('            Produtos',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text('Qtde',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text(
                      'Valor',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  widget.order.items.length,
                  (index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected))
                        return Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08);
                      if (index % 2 == 0) return Colors.grey.withOpacity(0.3);
                      return null;
                    }),
                    cells: [
                      DataCell(Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Text(
                            widget.order.items[index].name,
                            textAlign: TextAlign.center,
                          ))),
                      DataCell(Center(
                          child: Text((widget.order.items[index].qtyOrdered)
                              .toString()))),
                      DataCell(Center(
                          child: Text(format
                              .format(widget.order.items[index].price)
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
                Text(widget.order.payment.additionalInformation[0]),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" " + widget.order.shippingDescription),
                    Text("R\$ " +
                        widget.order.baseShippingAmount.toString() +
                        " ")
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(widget.order.billingAddress.street[0] +
                    ", " +
                    widget.order.billingAddress.street[1] +
                    " - " +
                    widget.order.billingAddress.street[2] +
                    ", " +
                    widget.order.billingAddress.city +
                    " / " +
                    widget.order.billingAddress.regionCode),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      " Total",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "R\$ " + widget.order.grandTotal.toString() + " ",
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
      ),
    );
  }
}
