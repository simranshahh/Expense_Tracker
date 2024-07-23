// ignore_for_file: prefer_const_constructors

import 'package:easy_splash_screen/easy_splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:myfinance/utils/colorconstant.dart';
import 'package:myfinance/view/auth/login/pages/loginpage.dart';
import 'package:myfinance/view/pages/onboarding.dart';
import 'package:onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      backgroundColor: Colors.deepPurple,
      durationInSeconds: 2,
      logo: Image.network(
          'https://cdn-icons-png.flaticon.com/128/9359/9359415.png'),
      title: Text(
        'MyFinance',
        style: TextStyle(
            color: ColorConstant.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 32),
      ),
      navigator: OnBoard(),
      showLoader: true,
      loaderColor: ColorConstant.white,
    );
  }
}
