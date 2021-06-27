import 'package:demo_project/presentation/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SingleDetail extends StatefulWidget {
  @override
  _SingleDetailState createState() => _SingleDetailState();
}

class _SingleDetailState extends State<SingleDetail> {
  Map data = {};
  List genres, productionCompanies;
  String basePosterUrl = 'http://image.tmdb.org/t/p/w500';
  String baseLogoPathUrl = 'http://image.tmdb.org/t/p/w92';
  String baseProfilePathUrl = 'http://image.tmdb.org/t/p/w185';
  var fav = ValueNotifier<bool>(false);
  var credits;
  void getFavourite(id) async {
    bool isFav = await DatabaseHelper.instance.isFavourite(id);
    print(isFav);
    fav.value = isFav;
    // setState(() {
    //   fav = isFav;
    // });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    String dataFor = data['dataFor'];
    credits = data['credits']['cast'];
    data = data['singleMovieData'];
    genres = data['genres'];
    productionCompanies = data['production_companies'];
    print(data['id']);
    print(data['name']);
    getFavourite(data['id']);
    return Scaffold(
      body: CustomScrollView(
        physics: PageScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height / 1.95,
            flexibleSpace: Stack(
              children: [
                Hero(
                  tag: 'image_trans' + data['id'].toString(),
                  child: Image.network(
                    basePosterUrl + data['poster_path'],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Positioned(
                  top: 20.0,
                  right: 20.0,
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: () async {
                        // print('Data: $data');
                        print('favourite $fav');
                        // setState(() {
                        //   fav = !fav;
                        // });

                        if (fav.value) {
                          int i = await DatabaseHelper.instance
                              .removeFavourite(data['id']);
                          print(i);
                          fav.value = false;
                          print('changed $fav');
                        } else {
                          int i = await DatabaseHelper.instance.insert({
                            DatabaseHelper.movieId: data['id'],
                            DatabaseHelper.movieName: dataFor == 'movie'
                                ? data['original_title']
                                : data['name'],
                            DatabaseHelper.overview: data['overview']
                          });
                          print(i);
                          fav.value = true;
                          print('changed $fav');
                        }
                      },
                      child: ValueListenableBuilder(
                        valueListenable: fav,
                        builder: (context, value, child) {
                          return Icon(
                            Icons.favorite,
                            size: 25.0,
                            color: value ? Colors.red[300] : Colors.grey[100],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dataFor == 'movie')
                        Text(
                          ((data['runtime'] / 60).floor()).toString() +
                              ' hr ' +
                              (data['runtime'] % 60).toString() +
                              ' min',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              dataFor == 'movie'
                                  ? data['original_title']
                                  : data['name'],
                              style: TextStyle(
                                  fontSize: 27.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (dataFor == 'movie')
                            Text(
                              '\$' +
                                  (data['budget'] / 1000000).toString() +
                                  'M',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.green[900]),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: genres
                              .map(
                                (genre) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.red[400],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 7.0),
                                  margin: EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    genre['name'],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        data['overview'],
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 100.0,
                        child: ListView.builder(
                            itemCount: productionCompanies.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    productionCompanies[index]['logo_path'] ==
                                            null
                                        ? Icon(
                                            Icons.broken_image,
                                            size: 50.0,
                                            color: Colors.grey[300],
                                          )
                                        : Image.network(
                                            baseLogoPathUrl +
                                                productionCompanies[index]
                                                        ['logo_path']
                                                    .toString(),
                                            height: 50.0,
                                            width: 50.0,
                                          ),
                                    Text(productionCompanies[index]['name']),
                                  ],
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Cast & Crew',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 300.0,
                        child: ListView.builder(
                            itemCount: credits.length,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(10.0),
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    credits[index]['profile_path'] == null
                                        ? Icon(
                                            Icons.broken_image,
                                            size: 150.0,
                                            color: Colors.grey[300],
                                          )
                                        : Image.network(
                                            baseProfilePathUrl +
                                                credits[index]['profile_path']
                                                    .toString(),
                                            height: 150.0,
                                            width: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      credits[index]['name'],
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      credits[index]['character'],
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              'Book Now',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: 25.0),
                            ),
                            minWidth: double.infinity,
                            height: 50.0,
                            color: Colors.amber,
                            padding: EdgeInsets.symmetric(horizontal: 10.0)),
                      )
                    ],
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
