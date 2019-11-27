import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:are_we_there_yet/providers/movie_overview_model.dart';
import 'package:are_we_there_yet/screens/movie_details_screen.dart';

class MovieOverview extends StatelessWidget {
  final MovieOverviewModel _movie;
  MovieOverview(this._movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 180,
      child: InkWell(
        child: Row(
          children: <Widget>[
            Container(
              width: 120,
              child: CachedNetworkImage(
                imageUrl: "http://image.tmdb.org/t/p/w185//${_movie.posterUrl}",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _movie.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      _movie.overview,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_movie.releaseDate != null
                            ? _movie.releaseDate.year.toString()
                            : ''),
                        Text(
                          _movie.voteAverage,
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(MovieDetailsScreen.routePath, arguments: _movie.id);
        },
      ),
    );
  }
}
