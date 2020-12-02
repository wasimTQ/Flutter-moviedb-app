import 'package:demoapp/utils/database_helper.dart';
import 'package:flutter/material.dart';

class FavouritesWidget extends StatefulWidget {
  @override
  _FavouritesWidgetState createState() => _FavouritesWidgetState();
}

class _FavouritesWidgetState extends State<FavouritesWidget> {
  Future<List<Map<String, dynamic>>> favourites;

  Future<List<Map<String, dynamic>>> getAllFavourites() async {
    return await DatabaseHelper.instance.queryAll();
  }

  @override
  void initState() {
    super.initState();
    favourites = getAllFavourites();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              'Favourites',
              style: TextStyle(fontSize: 25.0, color: Colors.grey[400]),
            ),
            SizedBox(height: 10.0),
            Container(
              height: size.height / 1.40,
              child: FutureBuilder(
                future: favourites,
                builder: (context, snapshot) {
                  print('length ${snapshot.data.length}');
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index]['name'],
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(snapshot.data[index]['overview']
                                              .substring(0, 65) +
                                          ' ....')
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await DatabaseHelper.instance
                                          .removeFavourite(
                                              snapshot.data[index]['movieId']);
                                      setState(() {
                                        favourites = getAllFavourites();
                                      });
                                    }),
                              ],
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ],
        ));
  }
}
