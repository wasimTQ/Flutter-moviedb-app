import 'package:demo_project/data/responses/api_service.dart';
import 'package:demo_project/logic/providers/series.dart';
import 'package:demo_project/presentation/utils/constants.dart';
import 'package:demo_project/presentation/widgets/genre.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TvWidget extends StatefulWidget {
  TvWidget({Key key}) : super(key: key);

  @override
  _TvWidgetState createState() => _TvWidgetState();
}

class _TvWidgetState extends State<TvWidget> {
   var selectedMovie = null;
  String basePosterUrl = 'http://image.tmdb.org/t/p/w185';
  @override
  Widget build(BuildContext context) {
    final tv_provider = Provider.of<Series>(context);
    final tv_data = tv_provider.movies;

    return Column(
      children: [
        GenreWidget(),
        tv_data.length == 0
            ? Expanded(
                child: Center(
                  child: tv_provider.isFirstLoad
                      ? CircularProgressIndicator()
                      : Text(
                          'Sorry nothing is found',
                          style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.center,
                        ),
                ),
              )
            : Expanded(
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: GridView.count(
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 15,
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        children: tv_data
                            .map((data) => GestureDetector(
                                  onTap: () async {
                                     setState(() {
                                      selectedMovie = data['id'];
                                    });
                                    final arguments = await ApiService()
                                        .getSingleMovieData(data['id'],
                                            dataOf: 'tv');
                                    setState(() {
                                      selectedMovie = null;
                                    });
                                    Navigator.pushNamed(
                                      context,
                                      '/single',
                                      arguments: arguments,
                                    );
                                  },
                                  child: IgnorePointer(
                                    ignoring: selectedMovie != null,
                                                                      child: Opacity(
                                      opacity: selectedMovie == data['id'] ? 0.4 : 1,
                                                                        child: Stack(
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
                                                  data['vote_average'].toString() +
                                                      ' %',
                                                  style: TextStyle(
                                                      fontSize: 10.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: color_primary_black),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList())),
              ),
      ],
    );
  }
}
