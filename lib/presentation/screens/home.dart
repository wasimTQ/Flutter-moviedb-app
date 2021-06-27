import 'package:demo_project/logic/providers/movie.dart';
import 'package:demo_project/logic/providers/series.dart';
import 'package:demo_project/presentation/utils/constants.dart';
import 'package:demo_project/presentation/widgets/favourites_widget.dart';
import 'package:demo_project/presentation/widgets/tv_widget.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/presentation/widgets/home_widget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearch = false;
  int _currentWidgetIndex = 0;
  List widgets = [HomeWidget(), TvWidget(), FavouritesWidget()];
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: color_primary_black,
        elevation: 0,
        brightness: Brightness.dark,
        title: isSearch
            ? TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_textEditingController.text.length > 3) {
                        Provider.of<Movies>(context, listen: false)
                            .searchMovie(_textEditingController.text);
                        Provider.of<Series>(context, listen: false)
                            .searchMovie(_textEditingController.text);
                      }
                    },
                  ),
                ),
              )
            : Text('Movie App'),
        actions: [
          IconButton(
            icon: Icon(isSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });
            },
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
