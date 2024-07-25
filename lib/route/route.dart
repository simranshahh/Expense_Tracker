// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import 'package:myfinance/view/auth/login/pages/loginpage.dart';
import 'package:myfinance/view/auth/register/pages/registerpage.dart';
import 'package:myfinance/view/pages/ViewCreatedAccount.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';
import 'package:myfinance/view/pages/cashinoutpage.dart';
import 'package:myfinance/view/pages/chart.dart';
import 'package:myfinance/view/pages/createaccount.dart';
import 'package:myfinance/view/pages/profilepage.dart';
import 'package:myfinance/view/pages/splashscreen.dart';
import 'package:myfinance/view/pages/yourprofile.dart';
import 'package:onboarding/onboarding.dart';

class MyRoutes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/loginpage':
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case '/registerpage':
        return MaterialPageRoute(builder: (context) => SignUp());
      case '/bottomnavbar':
        return MaterialPageRoute(builder: (context) => Bottomnavbar());

      case '/profilepage':
        return MaterialPageRoute(builder: (context) => ProfilePage());
      case '/yourprofilepage':
        return MaterialPageRoute(builder: (context) => YourProfile());
      case '/createaccount':
        return MaterialPageRoute(builder: (context) => CreateAccount());
      case '/viewcreatedaccount':
        return MaterialPageRoute(builder: (context) => ViewCreatedAccount());
      case '/splashscreen':
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case '/chart':
        return MaterialPageRoute(builder: (context) => Chart());
    }
    return null;
  }
}
