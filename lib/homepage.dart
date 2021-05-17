import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navigationScreens/home.dart';
import 'navigationScreens/signout.dart';
import 'navigationScreens/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 1);

  List<Widget> _NavScreens() {
    return [
      Profile(),
      Home(),
      Signout(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: new Icon(Icons.person),
        title: 'Profile',
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: new Icon(Icons.home),
        title: 'Home',
        activeColor: CupertinoColors.activeGreen,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.exit_to_app),
        title: 'Sign out',
        activeColor: CupertinoColors.systemRed,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FitbitApp"),
      ),
      body: Center(
        child: PersistentTabView(
          context,
          controller: _controller,
          screens: _NavScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          popAllScreensOnTapOfSelectedTab: true,
          navBarStyle: NavBarStyle.style9,
        ),
      ),
    );
  }
}
