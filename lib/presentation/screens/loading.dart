
import 'package:demo_project/presentation/widgets/genre.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        '/home',
      );
    });
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.purple[600],
        body: Center(
          // child: GenreWidget(),
          // child: Text(
          //   genres.genres.toString()
          // ),
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
