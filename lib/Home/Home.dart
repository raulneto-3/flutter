import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/ProdutcsModel.dart';
import 'package:mercado_na_nuvem/APIs/api.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'package:mercado_na_nuvem/Categories/ProductsDetailScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Products> futureProducts;
  @override
  void initState() {
    super.initState();

    futureProducts = fetchProducts(1, 2, 0, "");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Products>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 5.5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: 10,
              itemBuilder: (BuildContext context, index) {
                return Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                  product: snapshot.data.items[index])));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Image.network(
                              'https://mercadonanuvem.s3-sa-east-1.amazonaws.com/webp/' +
                                  snapshot.data.items[index].sku +
                                  '.webp',
                              width: 130,
                              height: 130,
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data.items[index].name,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                                "R\$ " +
                                    format
                                        .format(
                                            snapshot.data.items[index].price)
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
              },
            );
          }
          return Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
          ));
        },
      ),
    );
  }
}
