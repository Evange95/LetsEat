import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/home/dinner_screen.dart';
import 'package:flutter_complete_guide/screens/home/home_screen.dart';
import 'package:flutter_complete_guide/screens/home/personal_screen.dart';
import 'package:flutter_complete_guide/services/dinners.dart';
import 'package:flutter_complete_guide/services/recipes.dart';
import 'package:flutter_complete_guide/services/user.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTab = 0;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      final uid = Provider.of<FirebaseUser>(context).uid;
      Provider.of<User>(context).getUserData(uid);
      var userfav = Provider.of<User>(context).favourites;
      var userdone = Provider.of<User>(context).done;

      var userlat = Provider.of<User>(context).lat;
      var userlon = Provider.of<User>(context).lon;
      Provider.of<Recipes>(context).setUid(uid);
      Provider.of<Recipes>(context)
          .fetchAndSetRecipes(userfav, userdone)
          .then((_) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });

      Provider.of<Dinners>(context).setUid(uid);
      Provider.of<Dinners>(context)
          .fetchAndSetDinners(userlat, userlon)
          .then((_) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget homescreen(int tab) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (tab == 0) return HomeScreen();
      if (tab == 1) return (DinnerScreen());
      if (tab == 2) return PersonalScreen();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: homescreen(_currentTab),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentTab,
          onTap: (int value) {
            setState(() {
              _currentTab = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 25.0,
                ),
                title: SizedBox.shrink()),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                  size: 25.0,
                ),
                title: SizedBox.shrink()),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 25.0,
                ),
                title: SizedBox.shrink()),
          ],
        ));
  }
}
