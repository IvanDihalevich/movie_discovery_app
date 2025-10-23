import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import '../../../../core/errors/exceptions.dart';


class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<List<Movie>> call(String query, {int page = 1}) async {
    if (query.trim().isEmpty) {
      throw ValidationException(message: 'Search query cannot be empty');
    }
    return await repository.searchMovies(query, page: page);
  }
}
