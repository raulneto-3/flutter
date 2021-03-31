import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Order/OrderListScreen.dart';
import 'ProfileDetailScreen/ProfileDetailScreen.dart';

class ProfileScreen extends StatefulWidget {
  final userData;
  const ProfileScreen({Key key, this.userData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileDetailScreen()));
              },
              child: Align(
                child: Text(
                  'Detalhes do Perfil',
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.centerLeft,
              ),
              color: Colors.white,
              elevation: 5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderListScreen(
                            page: 1, userData: widget.userData)));
              },
              child: Align(
                child: Text(
                  'Lista de Pedidos',
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.centerLeft,
              ),
              color: Colors.white,
              elevation: 5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: RaisedButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.pop(context);
              },
              child: Align(
                child: Text(
                  'Sair',
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.centerLeft,
              ),
              color: Colors.white,
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }
}
