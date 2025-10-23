import 'package:hive/hive.dart';
import '../../domain/entities/movie.dart';

abstract class MovieLocalDataSource {
  Future<List<Movie>> getCachedMovies(String cacheKey);
  Future<void> cacheMovies(String cacheKey, List<Movie> movies);
  Future<Movie?> getCachedMovieDetails(int movieId);
  Future<void> cacheMovieDetails(Movie movie);
  Future<void> clearCache();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final HiveInterface hive;
  static const String moviesBoxName = 'movies_cache';
  static const String movieDetailsBoxName = 'movie_details_cache';

  MovieLocalDataSourceImpl({required this.hive});

  @override
  Future<List<Movie>> getCachedMovies(String cacheKey) async {
    try {
      final box = await hive.openBox<Map>(moviesBoxName);
      final cachedData = box.get(cacheKey);
      
      if (cachedData != null) {
        final List<dynamic> moviesJson = cachedData['movies'];
        final timestamp = cachedData['timestamp'] as int;
        final now = DateTime.now().millisecondsSinceEpoch;
        
        // Check if cache is still valid (24 hours)
        if (now - timestamp < 24 * 60 * 60 * 1000) {
          return moviesJson.map((json) => Movie.fromJson(json)).toList();
        } else {
          // Cache expired, remove it
          await box.delete(cacheKey);
        }
      }
      
      return [];
    } catch (e) {
      throw CacheException(message: 'Failed to get cached movies: $e');
    }
  }

  @override
  Future<void> cacheMovies(String cacheKey, List<Movie> movies) async {
    try {
      final box = await hive.openBox<Map>(moviesBoxName);
      final moviesJson = movies.map((movie) => movie.toJson()).toList();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      await box.put(cacheKey, {
        'movies': moviesJson,
        'timestamp': timestamp,
      });
    } catch (e) {
      throw CacheException(message: 'Failed to cache movies: $e');
    }
  }

  @override
  Future<Movie?> getCachedMovieDetails(int movieId) async {
    try {
      final box = await hive.openBox<Map>(movieDetailsBoxName);
      final cachedData = box.get('movie_$movieId');
      
      if (cachedData != null) {
        final timestamp = cachedData['timestamp'] as int;
        final now = DateTime.now().millisecondsSinceEpoch;
        
        // Check if cache is still valid (7 days for movie details)
        if (now - timestamp < 7 * 24 * 60 * 60 * 1000) {
          return Movie.fromJson(cachedData['movie']);
        } else {
          // Cache expired, remove it
          await box.delete('movie_$movieId');
        }
      }
      
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached movie details: $e');
    }
  }

  @override
  Future<void> cacheMovieDetails(Movie movie) async {
    try {
      final box = await hive.openBox<Map>(movieDetailsBoxName);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      await box.put('movie_${movie.id}', {
        'movie': movie.toJson(),
        'timestamp': timestamp,
      });
    } catch (e) {
      throw CacheException(message: 'Failed to cache movie details: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final moviesBox = await hive.openBox<Map>(moviesBoxName);
      final detailsBox = await hive.openBox<Map>(movieDetailsBoxName);
      
      await moviesBox.clear();
      await detailsBox.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }
}
