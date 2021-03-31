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
                              return Card(
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: InkWell(
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 12),
                                      child: Text(
                                        snapshot.data.childrenData[index].name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ));
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
