import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'APIs/config.dart';
import 'package:http/http.dart' as http;

import 'CadastroScreen.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  final String username;
  final String password;
  const LoginPage({Key key, this.username, this.password}) : super(key: key);
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var user = '';
  var _pass = '';
  var _fistClick = true;
  bool _showPassword = false;

// ignore: non_constant_identifier_names
  bool _remember_me;

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

  Future saveLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_remember_me) {
      preferences.setString('user', user);
      preferences.setString('pass', _pass);
    } else {
      preferences.setString('user', '');
      preferences.setString('pass', '');
    }
  }

  Future saveToken(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', token);
  }

  Widget build(BuildContext context) {
    if (user == '') {
      user = widget.username == "" ? user : widget.username;
      _remember_me = widget.username == "" ? false : true;
      _pass = widget.password == "" ? _pass : widget.password;
    }
    // ignore: unused_element
    Future mnnLoginAdmin(user, pass) async {
      String url =
          'https://' + base_url + '/rest/V1/integration/customer/token';
      try {
        http.Response response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"username": user, "password": pass}));
        _fistClick = true;
        if (response.statusCode == 200) {
          saveLogin();
          saveToken(response.body.replaceAll('"', ''));
          return Navigator.push(context,
              MaterialPageRoute(builder: (context) => BottomNavBar(page: 0)));
        } else if (response.statusCode == 201) {
          saveLogin();
          saveToken(response.body);
          return Navigator.push(context,
              MaterialPageRoute(builder: (context) => BottomNavBar(page: 0)));
        } else if (response.statusCode == 401) {
          _showMyDialog("Senha Invalida!!");
        } else {
          _showMyDialog("Erro Sistema!!");
        }
      } catch (error) {
        _fistClick = true;
        _showMyDialog('Erro Sistema!!');
      }

      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
      ));
    }

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,
        child: Image.asset('assets/logoadmin.png'),
      ),
    );

    final usuario = TextFormField(
      autofocus: false,
      initialValue: user,
      decoration: InputDecoration(
        hintText: 'E-mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
          user = value;
        });
      },
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: _pass,
      obscureText: !this._showPassword,
      decoration: InputDecoration(
        hintText: 'Senha',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
          _pass = value;
        });
      },
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (_fistClick) {
            _fistClick = false;
            mnnLoginAdmin(user, _pass);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => BottomNavBar(page: 0)));
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Entrar', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            usuario,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            Row(
              children: [
                Checkbox(
                  value: _remember_me,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      _remember_me = !_remember_me;
                    });
                  },
                ),
                Text('Lembrar Dados'),
              ],
            ),
            loginButton,
            SizedBox(
              height: 12.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastroScreen()));
                },
                padding: EdgeInsets.all(12),
                color: Colors.blue,
                child: Text('Cadastrar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
