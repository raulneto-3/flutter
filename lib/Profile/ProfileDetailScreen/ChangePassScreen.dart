import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/config.dart';
import 'ProfileDetailScreen.dart';

class ChangePassScreen extends StatefulWidget {
  final account;
  const ChangePassScreen({Key key, this.account});
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<ChangePassScreen> {
  bool _showPassword = false;
  bool _showCurrentPassword = false;
  var password;
  var currentPassword;

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

  Future editPass(currentPassword, newPassword) async {
    _showLoading();
    final String url = 'https://' +
        base_url +
        '/rest/V1/customers/me/password?customerId=' +
        widget.account.id.toString();
    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + "1bbiuz9u0u9ruroxl7dkn1z36qty4khx",
        },
        body: jsonEncode(
            {"currentPassword": currentPassword, "newPassword": newPassword}));

    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ProfileDetailScreen()));
    } else {
      Navigator.pop(context);
      _showMyDialog(response.body.toString(), response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Senha',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                autofocus: false,
                initialValue: '',
                obscureText: !this._showPassword,
                decoration: InputDecoration(
                  hintText: 'Nova Senha',
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
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: '',
                obscureText: !this._showCurrentPassword,
                decoration: InputDecoration(
                  hintText: 'Senha Atual',
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
                      color:
                          this._showCurrentPassword ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => this._showCurrentPassword =
                          !this._showCurrentPassword);
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    currentPassword = value;
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
            editPass(currentPassword, password);
          },
          child: Text(
            'Salvar Dados',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          elevation: 5,
        ),
      ),
    );
  }
}
