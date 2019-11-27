import 'dart:async';

import 'package:flutter/material.dart';
import 'package:are_we_there_yet/providers/movies_list.dart';
import 'package:are_we_there_yet/widgets/movie_overview.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class SearchMovieScreen extends StatefulWidget {
  static const routePath = '/search';

  @override
  _SearchMovieScreenState createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<MoviesList>(context).searchMovies('en', _searchQuery.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchResults = Provider.of<MoviesList>(context).searchedMovies;
    final language = ui.window.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchQuery,
          autofocus: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Star Wars, The Godfather...',
              contentPadding: const EdgeInsets.all(10)),
          onChanged: (text) {
            Provider.of<MoviesList>(context).searchMovies(language, text);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Provider.of<MoviesList>(context).clearSearch();
              _searchQuery.clear();
            },
          )
        ],
      ),
      body: Container(
        color: Color.fromRGBO(8, 28, 36, 1),
        child: ListView(
          children: searchResults.map((movie) => MovieOverview(movie)).toList(),
        ),
      ),
    );
  }
}
