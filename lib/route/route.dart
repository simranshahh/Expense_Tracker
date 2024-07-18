// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myfinance/view/auth/login/pages/loginpage.dart';

class MyRoutes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/loginpage':
        return MaterialPageRoute(builder: (context) => LoginScreen());
      // case '/registerpage':
      //   return MaterialPageRoute(builder: (context) => RegisterPage());
    }
    return null;
  }
}
