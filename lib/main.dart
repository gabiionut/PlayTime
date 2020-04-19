import 'package:flutter/material.dart';
import 'package:are_we_there_yet/providers/movies_list.dart';
import 'package:are_we_there_yet/screens/home_page_screen.dart';
import 'package:are_we_there_yet/screens/movie_details_screen.dart';
import 'package:are_we_there_yet/screens/search_movie_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  await DotEnv().load('release.env');
  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MoviesList()),
      ],
      child: MaterialApp(
        title: 'PlayTime',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Color.fromRGBO(8, 28, 36, 1),
          accentColor: Color.fromRGBO(1, 210, 119, 1),
          brightness: Brightness.dark,
        ),
        home: HomePage(),
        routes: {
          MovieDetailsScreen.routePath: (context) => MovieDetailsScreen(),
          SearchMovieScreen.routePath: (context) => SearchMovieScreen(),
        },
      ),
    );
  }
}
