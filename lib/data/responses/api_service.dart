import 'package:demo_project/data/models/genre.dart';
import 'package:dio/dio.dart';

class ApiService {
  final String _apiKey = '51934a7ff8a90d25b567560fc5e6615b';
  final String baseUrl = 'https://api.themoviedb.org/3';

  void getAllMovieData() async {
    var genreData = await getAllGenre();
    var movieData = await getAllMovie();
    var tvData = await getAllSeries();

    print(genreData);
    print(movieData);
    print(tvData);
  }

  getGenreString(genre) {
    String genres = '';
    for (var i = 0; i < genre.length; i++) {
      var gen = genre[i];
      if (i == genre.length - 1) {
        genres = '${genres}${gen.id.toString()}';
      } else {
        genres = '${genres}${gen.id.toString()},';
      }
    }
    return genres;
  }

  Future<List> getAllGenre() async {
    Response response =
        await Dio().get('$baseUrl/genre/movie/list?api_key=$_apiKey');

    return [
      Genre(id: 1, name: 'All', isSelected: true),
      ...response.data['genres'].map((d) => Genre.fromJson(d)).toList()
    ];
  }

  Future<List> getAllMovie({String dataOf = 'movie'}) async {
    Response response = await Dio().get(
        '$baseUrl/discover/$dataOf?api_key=$_apiKey&language=en-US&year=2020');
    return response.data['results'];
  }

  Future<List> searchMovie(String query, List genre,
      {String dataOf = 'movie'}) async {
    Response response;
    if (genre.length > 0) {
      String genres = getGenreString(genre);
      print('get wtih genre $genres');
      response = await Dio().get(
          '$baseUrl/search/$dataOf?api_key=$_apiKey&language=en-US&query=$query&with_genres=$genres');
    } else {
      response = await Dio().get(
          '$baseUrl/search/$dataOf?api_key=$_apiKey&language=en-US&query=$query');
    }
    print(response.data);
    return response.data['results'];
  }

  Future<List> getMovieDataBasedOnGenre(List genre,
      {String dataOf = 'movie'}) async {
    String genres = getGenreString(genre);

    // print(
    //     'Getting : $baseUrl/discover/movie?api_key=$_apiKey&with_genres=$genres');
    print(genres);
    Response response = await Dio()
        .get('$baseUrl/discover/$dataOf?api_key=$_apiKey&with_genres=$genres');

    print(response.data['results']);
    print(response.data['results'].length);
    return response.data['results'];
  }

  getSingleMovieData(int id, {String dataOf = 'movie'}) async {
    Response response =
        await Dio().get('$baseUrl/$dataOf/$id?api_key=$_apiKey');

    var movieId = await response.data['id'];
    Response response2 =
        await Dio().get('$baseUrl/$dataOf/$movieId/credits?api_key=$_apiKey');

    return {
      'singleMovieData': response.data,
      'credits': response2.data,
      'dataFor': dataOf,
    };
  }

  Future<List> getAllSeries() async {
    Response response =
        await Dio().get('$baseUrl/discover/tv?api_key=$_apiKey&language=en-US');
    return response.data['results'];
  }
}
