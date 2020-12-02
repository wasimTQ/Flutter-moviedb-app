import 'package:demoapp/utils/constants.dart';
import 'package:demoapp/utils/database_helper.dart';
import 'package:demoapp/widgets/favourites_widget.dart';
import 'package:demoapp/widgets/tv_widget.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/widgets/home_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentWidgetIndex = 0;
  List widgets = [HomeWidget(), TvWidget(), FavouritesWidget()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_primary_black,
        elevation: 0,
        brightness: Brightness.dark,
        title: Text('Movie App'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlue,
        backgroundColor: color_primary_black,
        showUnselectedLabels: false,
        currentIndex: _currentWidgetIndex,
        onTap: (index) {
          setState(() {
            _currentWidgetIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_rounded),
            label: 'TV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
        ],
      ),
      body: widgets[_currentWidgetIndex],
    );
  }
}
