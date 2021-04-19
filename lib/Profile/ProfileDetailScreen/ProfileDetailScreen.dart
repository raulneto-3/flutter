import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/ProfileModel.dart';
import 'package:mercado_na_nuvem/APIs/api.dart';
import 'package:mercado_na_nuvem/Widgets/SearchScreenProducts.dart';
import 'CreateAddresseScreen.dart';
import 'EditAccountScreen.dart';
import 'EditAddressesScreen.dart';

class ProfileDetailScreen extends StatefulWidget {
  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  var userData;
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];
  Future<Profile> futureProfile;
  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Center(child: Text("Cadastro"))
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
      body: FutureBuilder<Profile>(
          future: futureProfile,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              userData = snapshot.data;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Informaçõse da Conta',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: [
                      Card(
                        elevation: 5,
                        shadowColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 12.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.firstname +
                                        " " +
                                        snapshot.data.lastname,
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.email,
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditAccountScreen(
                                            account: snapshot.data)));
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Editar & Alterar Senha",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Endereçoes',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.addresses == null
                            ? 0
                            : snapshot.data.addresses.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                elevation: 5,
                                shadowColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.addresses[index]
                                                    .city +
                                                " - " +
                                                snapshot.data.addresses[index]
                                                    .region.region +
                                                " - " +
                                                snapshot.data.addresses[index]
                                                    .countryId,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            snapshot
                                                .data.addresses[index].postcode,
                                            style: TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.addresses[index]
                                                    .street[0] +
                                                " - " +
                                                snapshot.data.addresses[index]
                                                    .street[1] +
                                                " - " +
                                                snapshot.data.addresses[index]
                                                    .street[2],
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            snapshot.data.addresses[index]
                                                .telephone,
                                            style: TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                    ButtonTheme.bar(
                                      child: ButtonBar(
                                        children: [
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditAdrressesScreen(
                                                              userData:
                                                                  snapshot.data,
                                                              address: snapshot
                                                                      .data
                                                                      .addresses[
                                                                  index])));
                                            },
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "Editar",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              );
            }
            return Container(
              color: Colors.white,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
              )),
            );
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
        child: SizedBox(
          height: 50,
          child: RaisedButton(
            disabledColor: Colors.grey,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateAdrresseScreen(
                            userData: userData,
                            callback: "profile",
                          )));
            },
            child: Text(
              'Criar Endereço',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            color: Colors.blue,
            elevation: 5,
          ),
        ),
      ),
    );
  }
}
