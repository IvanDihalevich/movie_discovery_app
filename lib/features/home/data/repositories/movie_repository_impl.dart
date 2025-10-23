import 'package:dio/dio.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';
import '../datasources/movie_local_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      // Try to get from cache first
      final cachedMovies = await localDataSource.getCachedMovies('popular_movies_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }

      // If no cache, fetch from API
      final movies = await remoteDataSource.getPopularMovies(page: page);
      
      // Cache the results
      await localDataSource.cacheMovies('popular_movies_page_$page', movies);
      
      return movies;
    } catch (e) {
      // If API fails, try to return cached data
      final cachedMovies = await localDataSource.getCachedMovies('popular_movies_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final cachedMovies = await localDataSource.getCachedMovies('top_rated_movies_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }

      final movies = await remoteDataSource.getTopRatedMovies(page: page);
      await localDataSource.cacheMovies('top_rated_movies_page_$page', movies);
      
      return movies;
    } catch (e) {
      final cachedMovies = await localDataSource.getCachedMovies('top_rated_movies_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final cachedMovies = await localDataSource.getCachedMovies('now_playing_movies_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }

      final movies = await remoteDataSource.getNowPlayingMovies(page: page);
      await localDataSource.cacheMovies('now_playing_movies_page_$page', movies);
      
      return movies;
    } catch (e) {
      final cachedMovies = await localDataSource.getCachedMovies('now_playing_movies_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final cachedMovies = await localDataSource.getCachedMovies('upcoming_movies_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }

      final movies = await remoteDataSource.getUpcomingMovies(page: page);
      await localDataSource.cacheMovies('upcoming_movies_page_$page', movies);
      
      return movies;
    } catch (e) {
      final cachedMovies = await localDataSource.getCachedMovies('upcoming_movies_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }
      rethrow;
    }
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    try {
      // Try to get from cache first
      final cachedMovie = await localDataSource.getCachedMovieDetails(movieId);
      if (cachedMovie != null) {
        return cachedMovie;
      }

      // If no cache, fetch from API
      final movie = await remoteDataSource.getMovieDetails(movieId);
      
      // Cache the result
      await localDataSource.cacheMovieDetails(movie);
      
      return movie;
    } catch (e) {
      // If API fails, try to return cached data
      final cachedMovie = await localDataSource.getCachedMovieDetails(movieId);
      if (cachedMovie != null) {
        return cachedMovie;
      }
      rethrow;
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      // Search results are usually not cached as they are dynamic
      final movies = await remoteDataSource.searchMovies(query, page: page);
      return movies;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      final cachedMovies = await localDataSource.getCachedMovies('genre_${genreId}_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }

      final movies = await remoteDataSource.getMoviesByGenre(genreId, page: page);
      await localDataSource.cacheMovies('genre_${genreId}_page_$page', movies);
      
      return movies;
    } catch (e) {
      final cachedMovies = await localDataSource.getCachedMovies('genre_${genreId}_page_$page');
      if (cachedMovies.isNotEmpty) {
        return cachedMovies;
      }
      rethrow;
    }
  }
}
