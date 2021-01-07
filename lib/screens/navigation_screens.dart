import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:guccigang/config/palette.dart';
import 'package:guccigang/screens/home_screen.dart';
import 'package:guccigang/screens/profile_screen.dart';
import 'package:guccigang/screens/create_trip.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  GlobalKey _bottomNavigationKey = GlobalKey();

  final HomeScreen _homePage = HomeScreen();
  final SearchScreen _searchPage = SearchScreen();
  final ProfileScreen _profilePage = ProfileScreen();

  Widget _showPage = new HomeScreen();
  int lastIndex = 0;
  Widget lastPage = HomeScreen();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _homePage;
        break;
      case 1:
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return _searchPage;
            },
            fullscreenDialog: true));
        return lastPage;
        break;
      case 2:
        return _profilePage;
        break;
      default:
        return new Container(
          child: Text("NO Page found"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: lastIndex,
            height: 50.0,
            items: <Widget>[
              Icon(Icons.home, size: 30),
              Icon(Icons.add_circle_outline, size: 30),
              Icon(Icons.account_circle_outlined, size: 30),
            ],
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            backgroundColor: Palette.navBar,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            onTap: (int tappedIndex) {
              _bottomNavigationKey = GlobalKey();
              if (tappedIndex == 1) {
                setState(() {
                  _showPage = _pageChooser(tappedIndex);
                });
              } else {
                setState(() {
                  _showPage = _pageChooser(tappedIndex);
                  lastIndex = tappedIndex;
                  lastPage = _showPage;
                });
              }
            }),
        body: Container(
          color: Colors.blueAccent,
          child: Center(
            child: _showPage,
          ),
        ));
  }
}
