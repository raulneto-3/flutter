import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/CartModel.dart';
import 'package:mercado_na_nuvem/APIs/api.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:mercado_na_nuvem/Profile/ProfileDetailScreen/CreateAddresseScreen.dart';
import 'package:mercado_na_nuvem/Profile/ProfileDetailScreen/EditAddressesScreen.dart';
import 'package:mercado_na_nuvem/Widgets/SearchScreenProducts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CartPaymentScreen.dart';

class CartAddressScreen extends StatefulWidget {
  final subTotal;
  const CartAddressScreen({Key key, this.subTotal});
  @override
  _CartAddressScreenState createState() => _CartAddressScreenState();
}

class _CartAddressScreenState extends State<CartAddressScreen> {
  var taxaEntrega = 0.0;
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];
  int selectedRadioTile;
  Widget addresses;

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Future<void> _showLoading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 5,
            content: SingleChildScrollView(
                child: Center(
                    child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
            ))));
      },
    );
  }

  Future configAddress(address, option, config) async {
    _showLoading();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    final String url =
        'https://' + base_url + '/rest/V1/carts/mine/shipping-information';
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode({
          "addressInformation": {
            "shipping_address": {
              "region": address.region.region,
              "region_id": "499",
              "region_code": address.region.regionCode,
              "country_id": "BR",
              "street": [
                address.street[0],
                address.street[1],
                address.street[2]
              ],
              "postcode": address.postcode,
              "city": address.city,
              "firstname": config.firstname,
              "lastname": config.lastname,
              "customer_id": config.id,
              "email": config.email,
              "telephone": address.telephone
            },
            "billingAddress": {
              "region": address.region.region,
              "region_id": "499",
              "region_code": address.region.regionCode,
              "country_id": "BR",
              "street": [
                address.street[0],
                address.street[1],
                address.street[2]
              ],
              "postcode": address.postcode,
              "city": address.city,
              "firstname": config.firstname,
              "lastname": config.lastname,
              "customer_id": config.id,
              "email": config.email,
              "telephone": address.telephone
            },
            "shipping_carrier_code": option,
            "shipping_method_code": option
          }
        }));

    if (response.statusCode == 200) {
      Navigator.pop(context);
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CartPaymentScreen(
                  subTotal: widget.subTotal, taxaEntrega: taxaEntrega)));
    } else {
      Navigator.pop(context);
      throw Exception('Erro ao Adicionar no Carrinha');
    }
  }

  Future<Cart> futureCart;
  @override
  void initState() {
    super.initState();
    futureCart = getCart();
    selectedRadioTile = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text("Endereço"))
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
      body: FutureBuilder<Cart>(
        future: futureCart,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.customer.addresses != null) {
              addresses = Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(4),
                  itemCount: snapshot.data.customer.addresses.length,
                  itemBuilder: (_, index) {
                    return Container(
                      width: 200,
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
                                snapshot.data.customer.firstname +
                                    " " +
                                    snapshot.data.customer.lastname,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                snapshot
                                    .data.customer.addresses[index].telephone,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 14,
                                ),
                              ),
                              value: index + 1,
                              onChanged: (val) {
                                setState(() {
                                  taxaEntrega = 5;
                                  setSelectedRadioTile(val);
                                });
                              },
                              groupValue: selectedRadioTile,
                            ),
                            Text(
                              snapshot.data.customer.addresses[index]
                                      .street[0] +
                                  ", " +
                                  snapshot.data.customer.addresses[index]
                                      .street[1] +
                                  " - " +
                                  snapshot.data.customer.addresses[index].city +
                                  " / " +
                                  snapshot.data.customer.addresses[index].region
                                      .regionCode,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              snapshot.data.customer.addresses[index].postcode,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            ButtonTheme.bar(
                              child: ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    child: const Text('Editar',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditAdrressesScreen(
                                                      address: snapshot
                                                          .data
                                                          .customer
                                                          .addresses[index])));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              addresses = Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 150),
                child: SizedBox(
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateAdrresseScreen(
                                    userData: snapshot.data.customer,
                                    callback: "cart",
                                  )));
                    },
                    child: Text(
                      'Criar Novo Endereço',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.blue,
                    elevation: 5,
                  ),
                ),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.blue,
                      elevation: 10,
                      child: RadioListTile(
                          groupValue: selectedRadioTile,
                          activeColor: Colors.greenAccent,
                          title: Text(
                            "Retirar na Loja",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            'R\$ 0,00 ',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 15,
                            ),
                          ),
                          value: 0,
                          onChanged: (val) {
                            setState(() {
                              taxaEntrega = 0;
                              setSelectedRadioTile(val);
                            });
                          }),
                    ),
                  ),
                ),
                addresses,
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
                                  .format(taxaEntrega)
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
                                        taxaEntrega.toDouble())
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
                                if (selectedRadioTile != 0) {
                                  configAddress(
                                      snapshot.data.customer
                                          .addresses[selectedRadioTile - 1],
                                      "freeshipping",
                                      snapshot.data.customer);
                                } else {
                                  configAddress(
                                      snapshot.data.customer
                                          .addresses[selectedRadioTile],
                                      "flatrate",
                                      snapshot.data.customer);
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          return Container(
            color: Colors.transparent,
            child: Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
            )),
          );
        },
      ),
    );
  }
}
