import 'package:demo_project/logic/providers/genre.dart';
import 'package:demo_project/logic/providers/movie.dart';
import 'package:demo_project/logic/providers/series.dart';
import 'package:flutter/material.dart';

import 'package:demo_project/presentation/screens/single.dart';
import 'package:demo_project/presentation/screens/home.dart';
import 'package:demo_project/presentation/screens/loading.dart';
import 'package:demo_project/presentation/utils/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Genres()..getData()),
      ChangeNotifierProvider(create: (_) => Movies()..getData()),
      ChangeNotifierProvider(create: (_) => Series()..getData()),
    ],
    child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  );
  }
}