import 'package:demo_project/data/responses/api_service.dart';
import 'package:flutter/foundation.dart';

class Movies with ChangeNotifier {
  List movies = [];
  ApiService _apiService = ApiService();
  List selectedGenres = [];
  bool isFirstLoad = true;

  void getData() async {
    movies = await _apiService.getAllMovie();
    isFirstLoad = false;
    notifyListeners();
  }

  void getDataFromGenre(allSelectedGenres) async {
    selectedGenres = allSelectedGenres;
    movies = await _apiService.getMovieDataBasedOnGenre(allSelectedGenres);
    notifyListeners();
  }

  void searchMovie(query) async {
    movies = await _apiService.searchMovie(query, selectedGenres);
    notifyListeners();
  }
}
