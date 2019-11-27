import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:are_we_there_yet/helpers/time_helper.dart';
import 'package:are_we_there_yet/providers/movie_details_model.dart';

class MovieDetails extends StatelessWidget {
  final MovieDetailsModel movie;
  MovieDetails(this.movie);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 180,
                  child: Container(
                    width: 120,
                    child: CachedNetworkImage(
                      imageUrl:
                          "http://image.tmdb.org/t/p/w185//${movie.posterPath}",
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
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            movie.voteAverage,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 40,
                            ),
                          ),
                          Text(
                            movie.voteCount.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(movie.releaseDate.year.toString()),
                          Text(TimeHelper.timeFormatter(movie.runtime != null ?  movie.runtime * 60 : 0)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: movie.genres
                    .take(4)
                    .map(
                      (genre) => Transform(
                        transform: new Matrix4.identity()..scale(0.8),
                        child: new Chip(
                          label: new Text(
                            genre.name,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Text(movie.overview),
          ],
        ),
      ),
    );
  }
}
