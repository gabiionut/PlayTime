import 'package:are_we_there_yet/providers/movie_cast_model.dart';

class MovieCreditsModel {
  final int id;
  final List<MovieCastModel> cast;

  MovieCreditsModel({
    this.id,
    this.cast,
  });
}
