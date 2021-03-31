import 'package:flutter/material.dart';
import 'package:mercado_na_nuvem/APIs/api.dart';
import 'ChangePassScreen.dart';
import 'ProfileDetailScreen.dart';

class EditAccountScreen extends StatefulWidget {
  final account;
  const EditAccountScreen({Key key, this.account});
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  var firstname;
  var lastname;
  var email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Informações da Conta',
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
                initialValue: widget.account.firstname,
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
                onChanged: (value) {
                  setState(() {
                    firstname = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: widget.account.lastname,
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
                onChanged: (value) {
                  setState(() {
                    lastname = value;
                  });
                },
              ),
              TextFormField(
                autofocus: false,
                initialValue: widget.account.email,
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
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangePassScreen(account: widget.account)));
                    },
                    child: Text(
                      'Alterar Senha',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
        child: RaisedButton(
          onPressed: () {
            editProfile(
                widget.account,
                email == null ? widget.account.email : email,
                lastname == null ? widget.account.lastname : lastname,
                firstname == null ? widget.account.firstname : firstname);
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfileDetailScreen()));
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
