// ignore_for_file: unused_local_variable, prefer_const_constructors

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
  final screens = [DataPage(), INOUT()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: screens[_currentIndex],
          // floatingActionButton: QrFLoating(),
          // floatingActionButtonLocation:
          // FloatingActionButtonLocation.endContained,
          bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            child: BottomNavigationBar(
                selectedLabelStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 10,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Colors.deepPurple,
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
                unselectedItemColor: Colors.white,
                iconSize: 25,
                onTap: _onItemTapped,
                showUnselectedLabels: false,
                elevation: 5,
                selectedIconTheme: IconThemeData(size: 30)),
          )),
    );
  }
}
