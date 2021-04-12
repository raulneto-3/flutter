import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mercado_na_nuvem/Profile/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'APIs/ProfileModel.dart';
import 'APIs/api.dart';
import 'Cart/CartScreen.dart';
import 'Categories/CategoriesScreen.dart';
import 'SearchScreenProducts.dart';
import 'Home/HomeScreen.dart';
import 'LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var user = preferences.getString('user');
  var pass = preferences.getString('pass');
  runApp(MaterialApp(
    home: LoginPage(
        username: user == null ? '' : user, password: pass == null ? '' : pass),
    debugShowCheckedModeBanner: false,
  ));
}

class BottomNavBar extends StatefulWidget {
  final page;
  const BottomNavBar({Key key, this.page});
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final titulo = ['Mercado na Nuvem', 'Categorias', 'Perfil', 'Carrinho'];
  List countries = [];
  List filteredCountries = [];
  bool isSearching = false;
  var search;
  int bottomSelectedIndex = 0;

  var appBarTitle = 'Mercado na Nuvem';

  Future saveId(customerId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('customerId', customerId);
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView(userData) {
    saveId(userData.id);

    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomePage(),
        CategoriesScreen(),
        ProfileScreen(userData: userData),
        CartScreen(userData: userData),
      ],
    );
  }

  Future<Profile> futureProfile;
  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
      appBarTitle = titulo[index];
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
        future: futureProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: !isSearching
                    ? Center(child: Text(appBarTitle))
                    : TextField(
                        onChanged: (value) {
                          search = value;
                        },
                        onSubmitted: (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Search(search: search)));
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
                                        builder: (context) =>
                                            Search(search: search)));
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
              bottomNavigationBar: CurvedNavigationBar(
                height: 50.0,
                items: <Widget>[
                  Icon(Icons.home, size: 30, color: Colors.white),
                  Icon(Icons.store, size: 30, color: Colors.white),
                  Icon(Icons.person, size: 30, color: Colors.white),
                  Icon(Icons.shopping_cart, size: 30, color: Colors.white),
                ],
                color: Colors.blue,
                buttonBackgroundColor: Colors.blue,
                backgroundColor: Colors.transparent,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 600),
                onTap: (index) {
                  bottomTapped(index);
                },
              ),
              body: buildPageView(snapshot.data),
            );
          }
          return Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
            )),
          );
        });
  }
}
