import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'CompanyModel.dart';
import 'ProfileDetailScreen.dart';

class CreateAdrresseScreen extends StatefulWidget {
  final userData;
  const CreateAdrresseScreen({Key key, this.userData});
  @override
  _CreateAdrresseScreenState createState() => _CreateAdrresseScreenState();
}

class _CreateAdrresseScreenState extends State<CreateAdrresseScreen> {
  List<Company> _companies = Company.getListState();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedState;
  var telephone;
  var postcode;
  var street = ["", "", ""];
  var city;

  @override
  void initState() {
    _dropdownMenuItems =
        buildDropdownMenuItems(_companies).cast<DropdownMenuItem<Company>>();
    _selectedState = _dropdownMenuItems[0].value;

    super.initState();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(DropdownMenuItem(value: company, child: Text(company.name)));
    }
    return items;
  }

  onchangeDropdownItem(Company selectedState) {
    setState(() {
      _selectedState = selectedState;
    });
  }

  Future<void> _showMyDialog(String msg, title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: Text(title),
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

  Future createAddress(telephone, postcode, street, city) async {
    _showLoading();
    final String url = 'https://' +
        base_url +
        '/rest/V1/customers/' +
        widget.userData.id.toString();

    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + "1bbiuz9u0u9ruroxl7dkn1z36qty4khx",
        },
        body: jsonEncode({
          "customer": {
            "id": widget.userData.id,
            "email": widget.userData.email,
            "firstname": widget.userData.firstname,
            "lastname": widget.userData.lastname,
            "addresses": [
              {
                "firstname": widget.userData.firstname,
                "lastname": widget.userData.lastname,
                "street": [street[0], street[1], street[2]],
                "city": city,
                "region_id": _selectedState.id,
                "postcode": postcode,
                "country_id": "BR",
                "telephone": telephone
              },
              {
                "firstname": widget.userData.firstname,
                "lastname": widget.userData.lastname,
                "street": [street[0], street[1], street[2]],
                "city": city,
                "region_id": _selectedState.id,
                "postcode": postcode,
                "country_id": "BR",
                "telephone": telephone
              }
            ]
          },
        }));

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ProfileDetailScreen()));
    } else {
      Navigator.pop(context);
      _showMyDialog('Erro ao Salvar!', 'Erro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Endereço',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton(
                    value: _selectedState,
                    items: _dropdownMenuItems,
                    onChanged: onchangeDropdownItem,
                  )),
              TextFormField(
                autofocus: false,
                initialValue: "",
                decoration: InputDecoration(
                  hintText: 'Cidade',
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
                onChanged: (value) {
                  setState(() {
                    city = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: "",
                decoration: InputDecoration(
                  hintText: 'Bairro',
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
                onChanged: (value) {
                  setState(() {
                    street[2] = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: "",
                decoration: InputDecoration(
                  hintText: 'Enderço',
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
                onChanged: (value) {
                  setState(() {
                    street[0] = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: "",
                decoration: InputDecoration(
                  hintText: 'Numero',
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
                onChanged: (value) {
                  setState(() {
                    street[1] = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: "",
                decoration: InputDecoration(
                  hintText: 'CEP',
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
                onChanged: (value) {
                  setState(() {
                    postcode = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: "",
                decoration: InputDecoration(
                  hintText: 'Telefone',
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
                onChanged: (value) {
                  setState(() {
                    telephone = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
        child: SizedBox(
          height: 50,
          child: RaisedButton(
            onPressed: () {
              createAddress(telephone, postcode, street, city);
            },
            child: Text(
              'Salvar Dados',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.blue,
            elevation: 5,
          ),
        ),
      ),
    );
  }
}
