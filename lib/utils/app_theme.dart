// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:myfinance/utils/colorconstant.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
        displayLarge: TextStyle(
          color: ColorConstant.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 32,
        ),
        displayMedium: TextStyle(
          color: ColorConstant.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        displaySmall: TextStyle(
          color: ColorConstant.bluesub,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        headlineLarge: TextStyle(
          color: ColorConstant.black,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        headlineMedium: TextStyle(
          color: ColorConstant.bluesub,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        headlineSmall: TextStyle(
          color: ColorConstant.bluesub,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(
          color: ColorConstant.bluesub,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 10,
        )),
    inputDecorationTheme: InputDecorationTheme(
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColorConstant.bluesub),
        borderRadius: BorderRadius.circular(30),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColorConstant.bluesub),
        borderRadius: BorderRadius.circular(30),
      ),
      errorStyle: TextStyle(
        color: ColorConstant.white,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColorConstant.bluesub),
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorConstant.bluesub),
        borderRadius: BorderRadius.circular(30),
      ),
      filled: true,
      hintStyle: TextStyle(
          color: ColorConstant.land,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(const Size(328, 48)),
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
          backgroundColor: ColorConstant.land,
          color: ColorConstant.land,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        )),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xff243C5A)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: ColorConstant.primarydark,
        contentTextStyle: TextStyle(
          color: ColorConstant.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        )),
    datePickerTheme:
        DatePickerThemeData(yearStyle: TextStyle(color: ColorConstant.black)),

    // dialogBackgroundColor: ColorConstant.grey
  );
}
