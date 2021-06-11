import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persona/screens/result/result_screen.dart';
import '../size_config.dart';
import '../constants.dart';
import 'home/home_screen.dart';
import 'mypage/mypage_screen.dart';

class BottomNavBar extends StatefulWidget {
  final User user;
  BottomNavBar(this.user);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> _navitems = [
    {"icon": "assets/icons/home.svg", "title": " "},
    {"icon": "assets/icons/result.svg", "title": " "},
    {"icon": "assets/icons/mypage.svg", "title": " "},
  ];

  List<Widget> _screens;
  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(widget.user),
      ResultScreen(widget.user),
      MypageScreen(widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        unselectedItemColor: kTextColor,
        selectedItemColor: kActiveColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 12,
        items: List.generate(
          _navitems.length,
          (index) => BottomNavigationBarItem(
            icon: buildSvgIcon(
                src: _navitems[index]['icon'],
                isActive: _selectedIndex == index,
                color: kTextColor),
            activeIcon: buildSvgIcon(
                src: _navitems[index]['icon'],
                isActive: _selectedIndex == index,
                color: kActiveColor),
            label: _navitems[index]["title"],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: Image.asset(
        "assets/icons/logo.png",
        width: 100,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  SvgPicture buildSvgIcon(
      {@required String src, bool isActive = false, Color color}) {
    return SvgPicture.asset(
      src,
      height: 20,
      width: 20,
      color: color,
    );
  }
}
