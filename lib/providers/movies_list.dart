import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:are_we_there_yet/models/genre.dart';
import 'package:are_we_there_yet/providers/movie_details_model.dart';
import 'package:are_we_there_yet/providers/movie_overview_model.dart';

class MoviesList with ChangeNotifier {
  List<MovieOverviewModel> _moviesList = [];
  MovieDetailsModel _currentMovie = MovieDetailsModel();
  List<MovieOverviewModel> _searchedMovies = [];

  final String apiKey = '1c4b19026060e9bc66fb5aabf4866e95';

  Future<void> fetchMovies(String category, [String country, String language]) {
    final url =
        'https://api.themoviedb.org/3/movie/$category?api_key=$apiKey&language=$language&page=1&region=$country';
    _moviesList = [];

    return http.get(url).then((res) {
      var response = json.decode(res.body)['results'] as List<dynamic>;
      response.forEach((movie) {
        _moviesList.add(MovieOverviewModel(
          id: movie['id'],
          title: movie['title'],
          posterUrl: movie['poster_path'],
          voteAverage: movie['vote_average'].toString(),
          overview: movie['overview'],
          releaseDate: DateTime.parse(movie['release_date']),
        ));
      });
      notifyListeners();
    });
  }

  Future<void> getMovieById(int id, String language) {
    final url =
        'https://api.themoviedb.org/3/movie/$id?api_key=$apiKey&language=$language';
    return http.get(url).then((res) {
      var response = json.decode(res.body) as Map<String, dynamic>;
      _currentMovie = MovieDetailsModel(
        id: response['id'],
        title: response['title'],
        posterPath: response['poster_path'],
        overview: response['overview'],
        releaseDate: DateTime.parse(response['release_date']),
        voteAverage: response['vote_average'].toString(),
        budget: response['budget'],
        status: response['status'],
        voteCount: response['vote_count'],
        originalLanguage: response['original_language'],
        runtime: response['runtime'],
        revenue: response['revenue'],
        genres: (response['genres'] as List<dynamic>)
            .map((genre) => Genre(genre['id'], genre['name'])).toList(),
      );
    });
  }

  Future<void> searchMovies(String language, String query) {
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=$language&query=$query&page=1&include_adult=false';
    _searchedMovies = [];
    return http.get(url).then((res) {
      var response = json.decode(res.body)['results'] as List<dynamic>;
      if (response == null) {
        return;
      }
      response.forEach((movie) {
        _searchedMovies.add(MovieOverviewModel(
          id: movie['id'],
          title: movie['title'],
          posterUrl: movie['poster_path'],
          voteAverage: movie['vote_average'].toString(),
          overview: movie['overview'],
          releaseDate: DateTime.tryParse(movie['release_date']),
        ));
      });
      notifyListeners();
    });
  }

  List<MovieOverviewModel> get moviesList {
    return [..._moviesList];
  }

  List<MovieOverviewModel> get searchedMovies {
    return [..._searchedMovies];
  }

  void clearSearch() {
    _searchedMovies = [];
    notifyListeners();
  }

  MovieDetailsModel get movie {
    return MovieDetailsModel(
      id: _currentMovie.id,
      title: _currentMovie.title,
      posterPath: _currentMovie.posterPath,
      overview: _currentMovie.overview,
      releaseDate: _currentMovie.releaseDate,
      voteAverage: _currentMovie.voteAverage,
      budget: _currentMovie.budget,
      status: _currentMovie.status,
      voteCount: _currentMovie.voteCount,
      originalLanguage: _currentMovie.originalLanguage,
      runtime: _currentMovie.runtime,
      revenue: _currentMovie.revenue,
      genres: _currentMovie.genres,
    );
  }
}
