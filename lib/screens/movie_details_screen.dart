import 'package:are_we_there_yet/providers/movie_credits_model.dart';
import 'package:flutter/material.dart';
import 'package:are_we_there_yet/providers/movie_details_model.dart';
import 'package:are_we_there_yet/providers/movies_list.dart';
import 'package:are_we_there_yet/screens/current_movie_time_screen.dart';
import 'package:are_we_there_yet/widgets/movie_details.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class MovieDetailsScreen extends StatefulWidget {
  static const routePath = '/details';

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool hasMovie = false;
  bool hasCredits = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hasMovie && hasCredits) {
      return;
    }
    final int movieId = ModalRoute.of(context).settings.arguments as int;
    final language = ui.window.locale.languageCode;
    Provider.of<MoviesList>(context, listen: false)
        .getMovieById(movieId, language)
        .then((_) {
      setState(() {
        hasMovie = true;
      });
    });

    Provider.of<MoviesList>(context, listen: false)
        .getMovieCredits(movieId)
        .then((_) {
      setState(() {
        hasCredits = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final MovieDetailsModel movie = Provider.of<MoviesList>(context).movie;
    final MovieCreditsModel movieCredits = Provider.of<MoviesList>(context).movieCredits;

    return Scaffold(
      backgroundColor: Color.fromRGBO(8, 28, 36, 1),
      appBar: AppBar(
        elevation: 0,
        title:
            hasMovie ? Text(movie.title != null ? movie.title : '') : Text(''),
      ),
      body: hasMovie && hasCredits
          ? MovieDetails(movie, movieCredits)
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext ctx) {
              return MovieTimeScreen(movie);
            },
            isScrollControlled: true,
          );
        },
      ),
    );
  }
}
