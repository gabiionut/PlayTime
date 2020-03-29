import 'package:flutter/material.dart';
import 'package:are_we_there_yet/helpers/list_no_ripple.dart';
import 'package:are_we_there_yet/providers/movies_list.dart';
import 'package:are_we_there_yet/screens/search_movie_screen.dart';
import 'package:are_we_there_yet/widgets/movie_overview.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> currentFuture;
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final country = ui.window.locale.countryCode;
    final language = ui.window.locale.languageCode;
    return Scaffold(
      backgroundColor: Color.fromRGBO(8, 28, 36, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 4.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('PlayTimeLogo.png', fit: BoxFit.cover, height: 70,),
            Text(
              'PlayTime',
              style: TextStyle(fontFamily: 'Righteous'),
            ),
          ],
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchMovieScreen.routePath);
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: currentFuture != null
              ? currentFuture
              : Provider.of<MoviesList>(context, listen: false)
                  .fetchMovies('now_playing', country, language),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (dataSnapshot.error != null) {
              return Center(child: Text('An error occured'));
            }
            return Consumer<MoviesList>(
              builder: (ctx, movieData, child) => ScrollConfiguration(
                behavior: NoRipple(),
                child: ListView.builder(
                  itemCount: movieData.moviesList.length,
                  itemBuilder: (context, i) {
                    return MovieOverview(movieData.moviesList[i]);
                  },
                ),
              ),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(8, 28, 36, 1),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.theaters),
            title: Text('Now Playing'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            title: Text('Popular'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Top Rated'),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (selectedIndex) {
          setState(() {
            currentIndex = selectedIndex;
          });
          if (selectedIndex == 0) {
            currentFuture = Provider.of<MoviesList>(context, listen: false)
                .fetchMovies('now_playing', country, language);
          }
          if (selectedIndex == 1) {
            currentFuture = Provider.of<MoviesList>(context, listen: false)
                .fetchMovies('popular', country, language);
          }
          if (selectedIndex == 2) {
            currentFuture = Provider.of<MoviesList>(context, listen: false)
                .fetchMovies('top_rated', country, language);
          }
        },
      ),
    );
  }
}
