import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:movie_discovery_app/features/home/domain/usecases/get_popular_movies.dart';
import 'package:movie_discovery_app/features/home/domain/usecases/get_movie_details.dart';
import 'package:movie_discovery_app/main.dart';

void main() {
  group('Movie Discovery App Tests', () {
    testWidgets('App starts and shows home page', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MovieDiscoveryApp());

      // Verify that the app title is displayed
      expect(find.text('Movie Discovery'), findsOneWidget);
      
      // Verify that the home page is loaded
      expect(find.text('Popular Movies'), findsOneWidget);
    });

    testWidgets('Home page shows loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MovieDiscoveryApp());

      // The app should show loading state initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Search button is present in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(const MovieDiscoveryApp());

      // Verify search button is present
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('Home Bloc Tests', () {
    late HomeBloc homeBloc;
    late GetPopularMovies getPopularMovies;
    late GetMovieDetails getMovieDetails;

    setUp(() {
      getPopularMovies = GetPopularMovies(null); // Mock repository
      getMovieDetails = GetMovieDetails(null); // Mock repository
      homeBloc = HomeBloc(
        getPopularMovies: getPopularMovies,
        getMovieDetails: getMovieDetails,
      );
    });

    tearDown(() {
      homeBloc.close();
    });

    test('initial state is HomeInitial', () {
      expect(homeBloc.state, isA<HomeInitial>());
    });

    test('emits HomeLoading when LoadPopularMovies is added', () {
      // Arrange
      const event = LoadPopularMovies(page: 1);

      // Act & Assert
      expectLater(
        homeBloc.stream,
        emitsInOrder([
          isA<HomeLoading>(),
          isA<HomeError>(), // Will emit error due to null repository
        ]),
      );

      homeBloc.add(event);
    });
  });
}
