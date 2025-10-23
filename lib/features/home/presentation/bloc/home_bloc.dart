import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/entities/movie.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPopularMovies getPopularMovies;
  final GetMovieDetails getMovieDetails;

  HomeBloc({
    required this.getPopularMovies,
    required this.getMovieDetails,
  }) : super(HomeInitial()) {
    on<LoadPopularMovies>(_onLoadPopularMovies);
    on<LoadTopRatedMovies>(_onLoadTopRatedMovies);
    on<LoadNowPlayingMovies>(_onLoadNowPlayingMovies);
    on<LoadUpcomingMovies>(_onLoadUpcomingMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
  }

  Future<void> _onLoadPopularMovies(
    LoadPopularMovies event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeInitial) {
        emit(HomeLoading());
      }

      final movies = await getPopularMovies(page: event.page);
      
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        final updatedMovies = event.page == 1 
            ? movies 
            : [...currentState.popularMovies, ...movies];
        
        emit(currentState.copyWith(
          popularMovies: updatedMovies,
          hasReachedMaxPopular: movies.length < 20,
        ));
      } else {
        emit(HomeLoaded(
          popularMovies: movies,
          topRatedMovies: [],
          nowPlayingMovies: [],
          upcomingMovies: [],
          hasReachedMaxPopular: movies.length < 20,
        ));
      }
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onLoadTopRatedMovies(
    LoadTopRatedMovies event,
    Emitter<HomeState> emit,
  ) async {
    // Similar implementation for top rated movies
    // This would use GetTopRatedMovies use case
  }

  Future<void> _onLoadNowPlayingMovies(
    LoadNowPlayingMovies event,
    Emitter<HomeState> emit,
  ) async {
    // Similar implementation for now playing movies
    // This would use GetNowPlayingMovies use case
  }

  Future<void> _onLoadUpcomingMovies(
    LoadUpcomingMovies event,
    Emitter<HomeState> emit,
  ) async {
    // Similar implementation for upcoming movies
    // This would use GetUpcomingMovies use case
  }

  Future<void> _onRefreshMovies(
    RefreshMovies event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    add(const LoadPopularMovies(page: 1));
    // Load other categories as well
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      int nextPage = 1;
      
      switch (event.category) {
        case 'popular':
          nextPage = (currentState.popularMovies.length ~/ 20) + 1;
          add(LoadPopularMovies(page: nextPage));
          break;
        case 'top_rated':
          nextPage = (currentState.topRatedMovies.length ~/ 20) + 1;
          add(LoadTopRatedMovies(page: nextPage));
          break;
        case 'now_playing':
          nextPage = (currentState.nowPlayingMovies.length ~/ 20) + 1;
          add(LoadNowPlayingMovies(page: nextPage));
          break;
        case 'upcoming':
          nextPage = (currentState.upcomingMovies.length ~/ 20) + 1;
          add(LoadUpcomingMovies(page: nextPage));
          break;
      }
    }
  }
}
