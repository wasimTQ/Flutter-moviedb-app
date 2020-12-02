import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final String _apiKey = '51934a7ff8a90d25b567560fc5e6615b';
  final String baseUrl = 'https://api.themoviedb.org/3';

  void getMovieData() async {
    Response response =
        await Dio().get('$baseUrl/genre/movie/list?api_key=$_apiKey');
    Response movie_response = await Dio().get(
        '$baseUrl/discover/movie?api_key=$_apiKey&language=en-US&year=2020');
    Response tv_response =
        await Dio().get('$baseUrl/discover/tv?api_key=$_apiKey&language=en-US');

    var genreData = await response.data['genres'];
    var movieData = await movie_response.data['results'];
    var tvData = await tv_response.data['results'];

    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {
        'genres': genreData,
        'tvList': tvData,
        'moviesList': movieData,
        'api': _apiKey,
        'baseUrl': baseUrl
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getMovieData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.purple[600],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Movie App',
                    style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Loading ....',
                    style: TextStyle(
                        fontSize: 31.0,
                        color: Colors.purple[100],
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'powered by',
                    style: TextStyle(
                        fontSize: 23.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    'assets/images/themoviedb.png',
                    height: 100,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
