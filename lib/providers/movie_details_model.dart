import 'package:are_we_there_yet/models/genre.dart';

class MovieDetailsModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final int budget;
  final DateTime releaseDate;
  final int revenue;
  final int runtime;
  // TO DO => Use enum: Allowed Values: Rumored, Planned, In Production, Post Production, Released, Canceled
  final String status;
  final String voteAverage;
  final int voteCount;
  final String originalLanguage;
  final List<Genre> genres;

  MovieDetailsModel({
    this.id,
    this.title,
    this.overview,
    this.posterPath,
    this.budget,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.status,
    this.voteAverage,
    this.voteCount,
    this.originalLanguage,
    this.genres,
  });
}
