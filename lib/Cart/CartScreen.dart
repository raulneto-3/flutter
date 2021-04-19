import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/CartModel.dart';
import 'package:mercado_na_nuvem/APIs/api.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:mercado_na_nuvem/Widgets/customIconButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'CartAddressScreen2.dart';

class CartScreen extends StatefulWidget {
  final userData;
  const CartScreen({Key key, this.userData});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<Cart> futureCart;
  Map<String, int> qtdProd = {};
  @override
  void initState() {
    super.initState();
    futureCart = getCart();
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

  void increment(sku) {
    setState(() {
      qtdProd[sku] = qtdProd[sku] + 1;
    });
  }

  void decrement(sku) {
    setState(() {
      if (qtdProd[sku] != 0) {
        qtdProd[sku] = qtdProd[sku] - 1;
      } else {
        deleteItem(sku);
      }
    });
  }

  Future deleteItem(id) async {
    _showLoading();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    final String url = 'https://' +
        base_url +
        '/rest/default/V1/carts/mine/items/' +
        id.toString();
    final response = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token,
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      _showMyDialog("Item Removido", "Ok");
    } else {
      Navigator.pop(context);
      _showMyDialog('Erro ao Remover item', "Erro");
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
      body: FutureBuilder<Cart>(
          future: futureCart,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.items != null) {
                var subTotal = 0.0;
                for (var item in snapshot.data.items) {
                  subTotal = subTotal + (item.price * item.qty).toDouble();
                }
                return Column(
                  children: <Widget>[
                    Flexible(
                      child: ListView.builder(
                          itemCount: snapshot.data.items == null
                              ? 0
                              : snapshot.data.items.length,
                          itemBuilder: (context, index) {
                            var sku = snapshot.data.items[index].sku;
                            qtdProd[sku] = qtdProd[sku] == null
                                ? snapshot.data.items[index].qty
                                : qtdProd[sku];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                height: 110,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Image.network(
                                        'https://mercadonanuvem.s3-sa-east-1.amazonaws.com/webp/' +
                                            snapshot.data.items[index].sku +
                                            '.webp',
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data.items[index].name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              snapshot.data.items[index].sku,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "R\$ " +
                                                  format
                                                      .format(snapshot.data
                                                          .items[index].price)
                                                      .replaceAll('.', '_')
                                                      .replaceAll(',', '.')
                                                      .replaceAll('_', ','),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Column(
                                        children: <Widget>[
                                          CustomIconButton(
                                            iconData: Icons.add,
                                            color:
                                                Theme.of(context).primaryColor,
                                            onTap: () {
                                              var newQty = snapshot
                                                      .data.items[index].qty +
                                                  1;
                                              increment(snapshot
                                                  .data.items[index].sku);
                                              updateItem(
                                                  snapshot
                                                      .data.items[index].sku,
                                                  newQty,
                                                  snapshot.data.id);
                                            },
                                          ),
                                          Text(
                                            qtdProd[snapshot
                                                    .data.items[index].sku]
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 26),
                                          ),
                                          CustomIconButton(
                                            iconData: Icons.remove,
                                            color:
                                                Theme.of(context).primaryColor,
                                            onTap: () {
                                              var newQty = qtdProd[snapshot
                                                      .data.items[index].sku] -
                                                  1;
                                              if (newQty == 0) {
                                                deleteItem(snapshot
                                                    .data.items[index].item_id);
                                                decrement(snapshot
                                                    .data.items[index].sku);
                                              } else {
                                                decrement(snapshot
                                                    .data.items[index].sku);
                                                updateItem(
                                                    snapshot
                                                        .data.items[index].sku,
                                                    newQty,
                                                    snapshot.data.id);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
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
                                      .format(subTotal)
                                      .replaceAll('.', '_')
                                      .replaceAll(',', '.')
                                      .replaceAll('_', ',') +
                                  " ")
                            ],
                          ),
                          Padding(
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CartAddressScreen(
                                                  // userData: widget.userData,
                                                  subTotal: subTotal)));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Carrinho Vazio!!!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ));
            }
            return Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
            ));
          }),
    );
  }
}
