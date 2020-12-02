import 'package:demoapp/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool showGenre = true;
  Map data = {};

  List genreData = [];

  var selectedGenre, selectedMovie = 0;

  String baseUrl, apiKey;

  List moviesList = [];

  String basePosterUrl = 'http://image.tmdb.org/t/p/w185';

  void getMovieDataBasedOnGenre(int genre) async {
    print(
        'Getting : $baseUrl/discover/movie?api_key=$apiKey&with_genres=$genre');
    Response response = await Dio()
        .get('$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genre');

    print(response.data);
  }

  void getSingleMovieData(int id) async {
    Response response = await Dio().get('$baseUrl/movie/$id?api_key=$apiKey');

    var movieId = await response.data['id'];
    Response response2 =
        await Dio().get('$baseUrl/movie/$movieId/credits?api_key=$apiKey');

    var fav = await DatabaseHelper.instance.isFavourite(movieId);

    setState(() {
      selectedMovie = 0;
    });

    Navigator.pushNamed(context, '/single', arguments: {
      'singleMovieData': response.data,
      'credits': response2.data,
    });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    genreData = data['genres'];
    moviesList = data['moviesList'];
    baseUrl = data['baseUrl'];
    apiKey = data['api'];

    print(moviesList[1]['runtime']);
    return Column(
      children: [
        if (showGenre)
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            height: 65.0,
            child: Center(
              child: ListView.builder(
                  itemCount: genreData.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemExtent: null,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.5, vertical: 2.5),
                        decoration: BoxDecoration(
                            color: selectedGenre == genreData[index]['id']
                                ? Colors.red[300]
                                : Colors.transparent,
                            borderRadius:
                                selectedGenre == genreData[index]['id']
                                    ? BorderRadius.circular(25)
                                    : BorderRadius.circular(0)),
                        child: GestureDetector(
                          onTap: () {
                            print(genreData[index]['id']);
                            setState(() {
                              selectedGenre = genreData[index]['id'];
                            });
                            getMovieDataBasedOnGenre(genreData[index]['id']);
                          },
                          child: Text(
                            genreData[index]['name'],
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        Container(
          height: MediaQuery.of(context).size.height / 1.40,
          child: ListView.builder(
              itemCount: moviesList.length,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print(moviesList[index]);
                    setState(() {
                      selectedMovie = moviesList[index]['id'];
                    });
                    getSingleMovieData(moviesList[index]['id']);
                  },
                  child: Opacity(
                    opacity:
                        selectedMovie == moviesList[index]['id'] ? 0.4 : 1.0,
                    child: Container(
                      height: 150,
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
                              basePosterUrl + moviesList[index]['poster_path'],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      fontSize: 13, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
