import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  Future<Movie> call(int movieId) async {
    return await repository.getMovieDetails(movieId);
  }
}
