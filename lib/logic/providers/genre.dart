import 'package:demo_project/data/models/genre.dart';
import 'package:demo_project/data/responses/api_service.dart';

import 'package:flutter/foundation.dart';

class Genres with ChangeNotifier {
  List genres = [];
  ApiService _apiService = ApiService();

  void getData() async {
    genres = await _apiService.getAllGenre();
    notifyListeners();
  }

  void toggleSelected(int index) async {
    if (index > 0) {
      genres[0].isSelected = false;
      genres[index].isSelected = !genres[index].isSelected;
    } else {
      genres = genres
          .map((e) => Genre(
                id: e.id,
                name: e.name,
                isSelected: false,
              ))
          .toList();
          genres[0].isSelected = true;
    }
    notifyListeners();
  }
}
