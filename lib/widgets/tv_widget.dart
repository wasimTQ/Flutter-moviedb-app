import 'package:demoapp/utils/constants.dart';
import 'package:flutter/material.dart';

class TvWidget extends StatefulWidget {
  TvWidget({Key key}) : super(key: key);

  @override
  _TvWidgetState createState() => _TvWidgetState();
}

class _TvWidgetState extends State<TvWidget> {
  List tv_data;
  String basePosterUrl = 'http://image.tmdb.org/t/p/w185';
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;

    tv_data = data['tvList'];
    print(tv_data);

    return Container(
        margin: EdgeInsets.all(5.0),
        child: GridView.count(
            mainAxisSpacing: 30,
            crossAxisSpacing: 15,
            crossAxisCount: 2,
            childAspectRatio: 1,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: tv_data
                .map((data) => Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.topLeft,
                      overflow: Overflow.visible,
                      children: [
                        Image.network(
                          basePosterUrl + data['poster_path'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                        Positioned.fill(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.black.withOpacity(0.1)
                                ])),
                          ),
                        ),
                        Positioned(
                          bottom: 7.5,
                          left: 7.5,
                          child: Container(
                            width: 150.0,
                            child: Text(
                              data['original_name'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 7.5,
                            top: 7.5,
                            child: Container(
                              color: Colors.amber[400],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7.5, vertical: 5),
                              child: Text(
                                data['vote_average'].toString() + ' %',
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: color_primary_black),
                              ),
                            ))
                      ],
                    ))
                .toList()));
  }
}
