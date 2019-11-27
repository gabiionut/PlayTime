import 'dart:async';

import 'package:flutter/material.dart';
import 'package:are_we_there_yet/helpers/time_helper.dart';
import 'package:are_we_there_yet/providers/movie_details_model.dart';

class MovieTimeScreen extends StatefulWidget {
  final MovieDetailsModel movie;

  MovieTimeScreen(this.movie);

  @override
  _MovieTimeScreenState createState() => _MovieTimeScreenState();
}

class _MovieTimeScreenState extends State<MovieTimeScreen>
    with WidgetsBindingObserver {
  Timer _timer;
  int _start;
  DateTime pausedDateTime;

  void startTimer() {
    Duration oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start = widget.movie.runtime * 60;
    startTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    switch (state) {
      case AppLifecycleState.paused:
        pausedDateTime = DateTime.now();
        print('Paused time $pausedDateTime');
        print('Current time $_start');
        _timer.cancel();
        break;
      case AppLifecycleState.resumed:
        print('Resumed');
        var resumedTime = DateTime.now().difference(pausedDateTime).inSeconds;
        _start = _start - resumedTime;
        print('Resumed time $resumedTime');
        print('Current time $_start');
        startTimer();
        break;
      case AppLifecycleState.inactive:
        print('Inactive');
        break;
      case AppLifecycleState.suspending:
        print('Suspending');
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(8, 28, 36, 1),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.movie.title,
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Image.network(
              'http://image.tmdb.org/t/p/w185//${widget.movie.posterPath}',
            ),
            SizedBox(height: 40),
            Column(
              children: <Widget>[
                Text(
                  TimeHelper.timeFormatter(_start),
                  style: TextStyle(fontSize: 50),
                ),
                LinearProgressIndicator(
                    value: (widget.movie.runtime * 60 - _start) /
                        (widget.movie.runtime * 60)),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(TimeHelper.timeFormatter(
                        widget.movie.runtime * 60 - _start)),
                    Text(TimeHelper.timeFormatter(widget.movie.runtime * 60)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
