import 'package:demo_project/logic/providers/movie.dart';
import 'package:demo_project/logic/providers/series.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:demo_project/data/models/genre.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/logic/providers/genre.dart';
import 'package:provider/provider.dart';

class GenreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final genreProvider = Provider.of<Genres>(context);
    List genres = genreProvider.genres;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      height: 65.0,
      child: Center(
        child: ListView.builder(
          itemCount: genres.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemExtent: null,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 2.5),
                decoration: BoxDecoration(
                    color: genreProvider.genres[index].isSelected
                        ? Colors.amber[500]
                        : Colors.transparent,
                    borderRadius: genreProvider.genres[index].isSelected
                        ? BorderRadius.circular(25)
                        : BorderRadius.circular(0)),
                child: GestureDetector(
                  onTap: () {
                    genreProvider.toggleSelected(index);
                    if (genreProvider.genres[0].isSelected) {
                        Provider.of<Movies>(context, listen: false)
                            .getData();
                        Provider.of<Series>(context, listen: false)
                            .getData();
                      return;
                    }
                    var allSelectedGenres = genreProvider.genres
                        .where((element) => element.isSelected)
                        .toList();
                    EasyDebounce.debounce(
                      'my-debouncer',
                      Duration(milliseconds: 1500),
                      () {
                        Provider.of<Movies>(context, listen: false)
                            .getDataFromGenre(allSelectedGenres);
                        Provider.of<Series>(context, listen: false)
                            .getDataFromGenre(allSelectedGenres);
                      },
                    );
                  },
                  child: Text(
                    genres[index].name,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: genreProvider.genres[index].isSelected
                          ? Theme.of(context).backgroundColor
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
