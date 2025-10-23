import 'package:dio/dio.dart';
import '../../domain/entities/movie.dart';
import '../../../../core/errors/exceptions.dart';


abstract class MovieRemoteDataSource {
  Future<List<Movie>> getPopularMovies({int page = 1});
  Future<List<Movie>> getTopRatedMovies({int page = 1});
  Future<List<Movie>> getNowPlayingMovies({int page = 1});
  Future<List<Movie>> getUpcomingMovies({int page = 1});
  Future<Movie> getMovieDetails(int movieId);
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1});
  Future<List<Map<String, dynamic>>> getMovieVideos(int movieId);
  Future<List<Map<String, dynamic>>> getMovieReviews(int movieId, {int page = 1});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await dio.get('/movie/popular', queryParameters: {
        'page': page,
      });

      if (response.statusCode == 200) {
        final List<dynamic> moviesJson = response.data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load popular movies');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await dio.get('/movie/top_rated', queryParameters: {
        'page': page,
      });

      if (response.statusCode == 200) {
        final List<dynamic> moviesJson = response.data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load top rated movies');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await dio.get('/movie/now_playing', queryParameters: {
        'page': page,
      });

      if (response.statusCode == 200) {
        final List<dynamic> moviesJson = response.data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load now playing movies');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await dio.get('/movie/upcoming', queryParameters: {
        'page': page,
      });

      if (response.statusCode == 200) {
        final List<dynamic> moviesJson = response.data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load upcoming movies');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get('/movie/$movieId');

      if (response.statusCode == 200) {
        return Movie.fromJson(response.data);
      } else {
        throw ServerException(message: 'Failed to load movie details');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await dio.get('/search/movie', queryParameters: {
        'query': query,
        'page': page,
      });

      if (response.statusCode == 200) {
        final List<dynamic> moviesJson = response.data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to search movies');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await dio.get('/discover/movie', queryParameters: {
        'with_genres': genreId,
        'page': page,
      });

      if (response.statusCode == 200) {
        final List<dynamic> moviesJson = response.data['results'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load movies by genre');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMovieVideos(int movieId) async {
    try {
      final response = await dio.get('/movie/$movieId/videos');

      if (response.statusCode == 200) {
        final List<dynamic> videosJson = response.data['results'];
        return videosJson.cast<Map<String, dynamic>>();
      } else {
        throw ServerException(message: 'Failed to load movie videos');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMovieReviews(int movieId, {int page = 1}) async {
    try {
      final response = await dio.get('/movie/$movieId/reviews', queryParameters: {
        'page': page,
      });

      if (response.statusCode == 200) {
        final List<dynamic> reviewsJson = response.data['results'];
        return reviewsJson.cast<Map<String, dynamic>>();
      } else {
        throw ServerException(message: 'Failed to load movie reviews');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: 'Request timeout. Please check your internet connection.');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection. Please check your network.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return AuthenticationException(message: 'Invalid API key. Please check your TMDB API key.');
        } else if (statusCode == 404) {
          return NotFoundException(message: 'Resource not found.');
        } else if (statusCode == 429) {
          return ServerException(message: 'Rate limit exceeded. Please try again later.');
        } else {
          return ServerException(message: 'Server error: ${e.response?.statusMessage}');
        }
      default:
        return ServerException(message: 'An unexpected error occurred: ${e.message}');
    }
  }
}
