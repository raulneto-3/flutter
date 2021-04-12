import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'APIs/config.dart';
import 'SearchScreenProducts.dart';
import 'LoginPage.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  var email;
  var firstname;
  var lastname;
  var password;
  var passwordConfirm;
  bool _showPassword = false;
  bool _showPasswordConf = false;
  bool isSearching = false;
  var search;
  List countries = [];
  List filteredCountries = [];

  Future<void> _showMyDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: Text('Erro'),
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

  Future createCustomer(
      email, firstname, lastname, password, passwordConfirm) async {
    String url = 'https://' + base_url + '/rest/V1/customers';
    if (password == passwordConfirm) {
      try {
        http.Response response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "customer": {
                "email": email,
                "firstname": firstname,
                "lastname": lastname
              },
              "password": password
            }));
        if (response.statusCode == 200) {
          return Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else if (response.statusCode == 201) {
          return Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else if (response.statusCode == 401) {
          _showMyDialog("Senha Invalida!!");
        } else {
          _showMyDialog("Erro Sistema!!");
        }
      } catch (error) {
        _showMyDialog('Erro Sistema!!');
      }
    } else {
      _showMyDialog('Confirme corretamente a Senha');
    }
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
      body: Container(
        child: Center(
          child: ListView(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text('INFORMAÇÕES PESSOAIS'),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                autofocus: false,
                initialValue: '',
                decoration: InputDecoration(
                  hintText: 'Nome',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
                // ignore: missing_return
                onChanged: (value) {
                  setState(() {
                    firstname = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: '',
                decoration: InputDecoration(
                  hintText: 'Sobrenome',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
                // ignore: missing_return
                onChanged: (value) {
                  setState(() {
                    lastname = value;
                  });
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text('INFORMAÇÕES DE ACESSO'),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                autofocus: false,
                initialValue: '',
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
                // ignore: missing_return
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: '',
                obscureText: !this._showPassword,

                decoration: InputDecoration(
                  hintText: 'Senha',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: this._showPassword ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => this._showPassword = !this._showPassword);
                    },
                  ),
                ),
                // ignore: missing_return
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: '',
                obscureText: !this._showPasswordConf,

                decoration: InputDecoration(
                  hintText: 'Confirmar Senha',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: this._showPasswordConf ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() =>
                          this._showPasswordConf = !this._showPasswordConf);
                    },
                  ),
                ),
                // ignore: missing_return
                onChanged: (value) {
                  setState(() {
                    passwordConfirm = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
        child: RaisedButton(
          onPressed: () {
            createCustomer(
                email, firstname, lastname, password, passwordConfirm);
          },
          child: Text(
            'Criar Conta',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          elevation: 5,
        ),
      ),
    );
  }
}
