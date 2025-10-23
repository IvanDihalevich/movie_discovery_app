import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'core/constants/app_constants.dart';

void main() {
  runApp(const MovieDiscoveryApp());
}

class MovieDiscoveryApp extends StatelessWidget {
  const MovieDiscoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: BlocProvider(
        create: (context) => HomeBloc(
          getPopularMovies: GetPopularMovies(null), // TODO: Inject repository
          getMovieDetails: GetMovieDetails(null), // TODO: Inject repository
        ),
        child: const HomePage(),
      ),
    );
  }
}

