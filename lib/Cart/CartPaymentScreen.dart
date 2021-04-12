import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import '../SearchScreenProducts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EndCartScreen.dart';

class CartPaymentScreen extends StatefulWidget {
  final taxaEntrega;
  final subTotal;
  const CartPaymentScreen({Key key, this.taxaEntrega, this.subTotal});
  @override
  _CartPaymentScreenState createState() => _CartPaymentScreenState();
}

class _CartPaymentScreenState extends State<CartPaymentScreen> {
  List<bool> _isChecked;
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];
  int selectedRadioTile;

  var payment = ['Pagar na Retirada'];
  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Future createOrder(method) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    final String url = 'https://' + base_url + '/rest/V1/carts/mine/order';
    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode({
          "paymentMethod": {"method": "checkmo"}
        }));

    if (response.statusCode == 200) {
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EndCartCreate(order: response.body.replaceAll('"', ''))));
    } else {
      throw Exception('Erro ao Adicionar no Carrinha');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text("Opção de Pagamento"))
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
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: payment.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.blue,
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RadioListTile(
                              activeColor: Colors.greenAccent,
                              title: Text(
                                payment[index],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                payment[index],
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 12,
                                ),
                              ),
                              value: 0,
                              groupValue: selectedRadioTile,
                              onChanged: (val) {
                                setState(() {
                                  setSelectedRadioTile(val);
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            elevation: 5,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(3, 4, 3, 3),
                  child: Text(
                    "Resumo do Pedido",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" Subtotal"),
                    Text("R\$ " +
                        format
                            .format(widget.subTotal)
                            .replaceAll('.', '_')
                            .replaceAll(',', '.')
                            .replaceAll('_', ',') +
                        " ")
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" Entrega"),
                    Text("R\$ " +
                        format
                            .format(widget.taxaEntrega)
                            .replaceAll('.', '_')
                            .replaceAll(',', '.')
                            .replaceAll('_', ',') +
                        " ")
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      " Total",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "R\$ " +
                          format
                              .format(widget.subTotal +
                                  widget.taxaEntrega.toDouble())
                              .replaceAll('.', '_')
                              .replaceAll(',', '.')
                              .replaceAll('_', ',') +
                          " ",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0),
                    )
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SizedBox(
                      height: 50,
                      child: RaisedButton(
                        child: Text(
                          "Finalizar Pedido",
                          style: TextStyle(fontSize: 20),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          createOrder("checkmo");
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
