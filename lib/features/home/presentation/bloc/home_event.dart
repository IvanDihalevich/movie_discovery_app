import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadPopularMovies extends HomeEvent {
  final int page;

  const LoadPopularMovies({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class LoadTopRatedMovies extends HomeEvent {
  final int page;

  const LoadTopRatedMovies({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class LoadNowPlayingMovies extends HomeEvent {
  final int page;

  const LoadNowPlayingMovies({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class LoadUpcomingMovies extends HomeEvent {
  final int page;

  const LoadUpcomingMovies({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class RefreshMovies extends HomeEvent {}

class LoadMoreMovies extends HomeEvent {
  final String category;

  const LoadMoreMovies({required this.category});

  @override
  List<Object?> get props => [category];
}
