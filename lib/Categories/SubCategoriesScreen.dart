import 'package:flutter/material.dart';

import 'ProductListScroll.dart';

class SubCategoriesScreen extends StatefulWidget {
  final subCategories;
  const SubCategoriesScreen({Key key, this.subCategories});
  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text(widget.subCategories.name))
            : TextField(
                onChanged: (value) {
                  search = value;
                },
                onSubmitted: (value) {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Search(
                  //               page: 1,
                  //               categorieId: 0,
                  //               name: search,
                  //               search: search,
                  //               option: 1,
                  //             )));
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Search(
                        //               page: 1,
                        //               categorieId: 0,
                        //               name: search,
                        //               option: 1,
                        //             )));
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.subCategories.subChildrenData.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductListScroll(
                                            categorieId: widget.subCategories
                                                .subChildrenData[index].id,
                                            subCategories:
                                                widget.subCategories.name)));
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.subCategories
                                                .subChildrenData[index].name,
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            widget
                                                .subCategories
                                                .subChildrenData[index]
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
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
