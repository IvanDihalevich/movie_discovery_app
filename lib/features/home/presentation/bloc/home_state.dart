import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> upcomingMovies;
  final bool hasReachedMaxPopular;
  final bool hasReachedMaxTopRated;
  final bool hasReachedMaxNowPlaying;
  final bool hasReachedMaxUpcoming;

  const HomeLoaded({
    required this.popularMovies,
    required this.topRatedMovies,
    required this.nowPlayingMovies,
    required this.upcomingMovies,
    this.hasReachedMaxPopular = false,
    this.hasReachedMaxTopRated = false,
    this.hasReachedMaxNowPlaying = false,
    this.hasReachedMaxUpcoming = false,
  });

  @override
  List<Object?> get props => [
        popularMovies,
        topRatedMovies,
        nowPlayingMovies,
        upcomingMovies,
        hasReachedMaxPopular,
        hasReachedMaxTopRated,
        hasReachedMaxNowPlaying,
        hasReachedMaxUpcoming,
      ];

  HomeLoaded copyWith({
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? nowPlayingMovies,
    List<Movie>? upcomingMovies,
    bool? hasReachedMaxPopular,
    bool? hasReachedMaxTopRated,
    bool? hasReachedMaxNowPlaying,
    bool? hasReachedMaxUpcoming,
  }) {
    return HomeLoaded(
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      hasReachedMaxPopular: hasReachedMaxPopular ?? this.hasReachedMaxPopular,
      hasReachedMaxTopRated: hasReachedMaxTopRated ?? this.hasReachedMaxTopRated,
      hasReachedMaxNowPlaying: hasReachedMaxNowPlaying ?? this.hasReachedMaxNowPlaying,
      hasReachedMaxUpcoming: hasReachedMaxUpcoming ?? this.hasReachedMaxUpcoming,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
