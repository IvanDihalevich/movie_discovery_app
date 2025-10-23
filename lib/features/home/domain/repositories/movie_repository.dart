import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopularMovies({int page = 1});
  Future<List<Movie>> getTopRatedMovies({int page = 1});
  Future<List<Movie>> getNowPlayingMovies({int page = 1});
  Future<List<Movie>> getUpcomingMovies({int page = 1});
  Future<Movie> getMovieDetails(int movieId);
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1});
}
