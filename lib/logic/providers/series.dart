import 'package:demo_project/data/responses/api_service.dart';
import 'package:flutter/foundation.dart';

class Series with ChangeNotifier {
  List movies = [];
  ApiService _apiService = ApiService();
  List selectedGenres = [];
  bool isFirstLoad = true;

  String dataOf = 'tv';

  void getData() async {
    movies = await _apiService.getAllMovie(dataOf: dataOf);
    isFirstLoad = false;
    notifyListeners();
  }

  void getDataFromGenre(allSelectedGenres) async {
    selectedGenres = allSelectedGenres;
    movies = await _apiService.getMovieDataBasedOnGenre(allSelectedGenres, dataOf: dataOf);
    notifyListeners();
  }

  void searchMovie(query) async {
    movies = await _apiService.searchMovie(query, selectedGenres,dataOf: dataOf);
    notifyListeners();
  }
}
