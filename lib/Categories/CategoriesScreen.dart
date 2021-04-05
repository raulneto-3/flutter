import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/api.dart';
import 'package:mercado_na_nuvem/APIs/CategoriesModel.dart';
import 'package:mercado_na_nuvem/Categories/SubCategoriesScreen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // ignore: non_constant_identifier_names
  var num_pedidos;

  Future<Categories> futureCategories;
  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
                child: FutureBuilder<Categories>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.childrenData != null) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.childrenData.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubCategoriesScreen(
                                                      subCategories: snapshot
                                                              .data
                                                              .childrenData[
                                                          index])));
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    'https://mercadonanuvem.s3-sa-east-1.amazonaws.com/categorias/' +
                                                        snapshot
                                                            .data
                                                            .childrenData[index]
                                                            .id
                                                            .toString() +
                                                        '.webp',
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Container(
                                          height: 80,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.7,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data
                                                    .childrenData[index].name,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                              Text(
                                                snapshot
                                                    .data
                                                    .childrenData[index]
                                                    .productCount
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blueAccent),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.arrow_forward_ios,
                                              color: Colors.blueAccent),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey[300],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('erro');
                  }
                }
                return Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
                ));
              },
            )),
          ],
        ),
      ),
    );
  }
}
