import 'package:flutter/material.dart';

import 'package:demoapp/screens/single.dart';
import 'package:demoapp/screens/home.dart';
import 'package:demoapp/screens/loading.dart';
import 'package:demoapp/utils/constants.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    color: Colors.white,
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: color_primary_black,
      primarySwatch: Colors.amber,
      backgroundColor: color_primary_black,
      scaffoldBackgroundColor: color_secondary,
      fontFamily: 'Mark Pro',
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/single': (context) => SingleDetail(),
    },
  ));
}
