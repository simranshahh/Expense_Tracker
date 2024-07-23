// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myfinance/view/pages/dashboard.dart';
import 'package:myfinance/view/pages/inout.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _currentIndex = 0;
  final List<Widget> screens = [DataPage(), INOUT()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: BottomNavigationBar(
            selectedLabelStyle: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: Colors.transparent,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.verified_user),
                label: 'Profile',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            iconSize: 28,
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            elevation: 0,
            selectedIconTheme: IconThemeData(size: 30),
          ),
        ),
      ),
    );
  }
}
