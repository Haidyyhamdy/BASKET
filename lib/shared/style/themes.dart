import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
    cardColor: Colors.white,
    primarySwatch: Colors.pink,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cardo',
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        )),
    textTheme: TextTheme(
        headline6: TextStyle(
            fontFamily: 'Cardo',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        headline4: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cardo',
        ),
        bodyText2: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontFamily: 'Cardo',
        ),
        bodyText1: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        )));

ThemeData darkTheme = ThemeData(
  cardColor: HexColor('22303c'),
  primarySwatch: Colors.pink,
  scaffoldBackgroundColor: HexColor('22303c'),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cardo',
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('22303c'),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    backgroundColor: HexColor('22303c'),
    elevation: 0.0,
  ),
  textTheme: TextTheme(
    headline4: TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cardo',
    ),
    bodyText2: TextStyle(
      fontSize: 15,
      color: Colors.white,
      fontFamily: 'Cardo',
    ),
    bodyText1: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
    ),

    /// NAME       SIZE   WEIGHT   SPACING  2018 NAME
    /// display4   112.0  thin     0.0      headline1
    /// display3   56.0   normal   0.0      headline2
    /// display2   45.0   normal   0.0      headline3
    /// display1   34.0   normal   0.0      headline4
    /// headline   24.0   normal   0.0      headline5
    /// title      20.0   medium   0.0      headline6
    /// subhead    16.0   normal   0.0      subtitle1
    /// body2      14.0   medium   0.0      body1 (bodyText1)
    /// body1      14.0   normal   0.0      body2 (bodyText2)
    /// caption    12.0   normal   0.0      caption
    /// button     14.0   medium   0.0      button
    /// subtitle   14.0   medium   0.0      subtitle2
    /// overline   10.0   normal   0.0      overline
  ),
);
