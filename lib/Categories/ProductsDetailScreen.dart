import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductListScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  final product;
  const ProductDetailScreen({Key key, this.product}) : super(key: key);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var qty;
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];

  Future addItem(sku, qty) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var customerId = preferences.getInt('customerId').toString();
    final String url =
        'https://' + base_url + '/rest/V1/mercadonanuvem/cart/add';
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + "1bbiuz9u0u9ruroxl7dkn1z36qty4khx",
        },
        body: jsonEncode({"sku": sku, "qty": qty, "customer_id": customerId}));

    if (response.statusCode == 200) {
      _showMyDialog("Item Adicionado", "Ok");
    } else if (response.statusCode == 400) {
      _showMyDialog("Fora de Estoque", "Erro");
    } else {
      throw Exception('Erro ao Adicionar no Carrinho');
    }
  }

  Future<void> _showMyDialog(String msg, status) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: Text(status),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text("Mercado na Nuvem"))
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
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            SizedBox(
              height: 12.0,
            ),
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Divider(),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                height: 300,
                child: Card(
                  child: Image.network(
                    'https://mercadonanuvem.s3-sa-east-1.amazonaws.com/webp/' +
                        widget.product.sku +
                        '.webp',
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              "R\$ " +
                  format
                      .format(widget.product.price)
                      .replaceAll('.', '_')
                      .replaceAll(',', '.')
                      .replaceAll('_', ','),
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 50,
                right: 50,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: TextField(
                    decoration: new InputDecoration(labelText: "Quantidade:"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        qty = value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
        child: RaisedButton(
          onPressed: () {
            addItem(widget.product.sku, qty);
          },
          child: Text('Add Carrinho'),
          color: Colors.blue,
          elevation: 5,
        ),
      ),
    );
  }
}
