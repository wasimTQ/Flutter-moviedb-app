import 'package:demo_project/data/responses/api_service.dart';
import 'package:demo_project/logic/providers/movie.dart';
import 'package:demo_project/presentation/widgets/genre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  var selectedMovie = 0;
  String basePosterUrl = 'http://image.tmdb.org/t/p/w185';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenreWidget(),
        Consumer<Movies>(builder: (_, movieList, __) {
          final moviesList = movieList.movies;
          if (moviesList.length == 0) {
            return Expanded(
              child: Center(
                child: movieList.isFirstLoad
                    ? CircularProgressIndicator()
                    : Text(
                        'Sorry nothing is found',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3,
                      ),
              ),
            );
          }
          return Expanded(
            child: ListView.builder(
              itemCount: moviesList.length,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return IgnorePointer(
                  ignoring: selectedMovie != null && selectedMovie != 0,
                  child: Opacity(
                    opacity:
                        selectedMovie == moviesList[index]['id'] ? 0.4 : 1.0,
                    child: GestureDetector(
                      onTap: () async {
                        print(moviesList[index]);

                        setState(() {
                          selectedMovie = moviesList[index]['id'];
                        });

                        var arguments = await ApiService()
                            .getSingleMovieData(moviesList[index]['id']);
                        setState(() {
                          selectedMovie = null;
                        });
                        Navigator.pushNamed(
                          context,
                          '/single',
                          arguments: arguments,
                        );
                      },
                      child: Container(
                        height: 150,
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'image_trans' +
                                  moviesList[index]['id'].toString(),
                              child: Image.network(
                                basePosterUrl +
                                    moviesList[index]['poster_path'],
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        moviesList[index]['release_date']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 9.0,
                                            color: Colors.grey[700]),
                                      ),
                                      Text(
                                        moviesList[index]['original_title'],
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Rating: ' +
                                        moviesList[index]['vote_average']
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        })
      ],
    );
  }
}
