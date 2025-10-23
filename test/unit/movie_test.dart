import 'package:flutter_test/flutter_test.dart';
import 'package:movie_discovery_app/features/home/domain/entities/movie.dart';

void main() {
  group('Movie Entity Tests', () {
    late Movie movie;

    setUp(() {
      movie = const Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test overview',
        posterPath: '/test-poster.jpg',
        backdropPath: '/test-backdrop.jpg',
        voteAverage: 8.5,
        voteCount: 1000,
        releaseDate: '2023-01-01',
        genreIds: [28, 12, 16],
        adult: false,
        originalLanguage: 'en',
        originalTitle: 'Test Movie',
        popularity: 100.0,
        video: false,
      );
    });

    test('should create a movie entity with correct properties', () {
      // Assert
      expect(movie.id, equals(1));
      expect(movie.title, equals('Test Movie'));
      expect(movie.overview, equals('Test overview'));
      expect(movie.posterPath, equals('/test-poster.jpg'));
      expect(movie.backdropPath, equals('/test-backdrop.jpg'));
      expect(movie.voteAverage, equals(8.5));
      expect(movie.voteCount, equals(1000));
      expect(movie.releaseDate, equals('2023-01-01'));
      expect(movie.genreIds, equals([28, 12, 16]));
      expect(movie.adult, equals(false));
      expect(movie.originalLanguage, equals('en'));
      expect(movie.originalTitle, equals('Test Movie'));
      expect(movie.popularity, equals(100.0));
      expect(movie.video, equals(false));
    });

    test('should support equality comparison', () {
      // Arrange
      final movie2 = const Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test overview',
        posterPath: '/test-poster.jpg',
        backdropPath: '/test-backdrop.jpg',
        voteAverage: 8.5,
        voteCount: 1000,
        releaseDate: '2023-01-01',
        genreIds: [28, 12, 16],
        adult: false,
        originalLanguage: 'en',
        originalTitle: 'Test Movie',
        popularity: 100.0,
        video: false,
      );

      // Assert
      expect(movie, equals(movie2));
    });

    test('should support copyWith method', () {
      // Act
      final updatedMovie = movie.copyWith(
        title: 'Updated Title',
        voteAverage: 9.0,
      );

      // Assert
      expect(updatedMovie.title, equals('Updated Title'));
      expect(updatedMovie.voteAverage, equals(9.0));
      expect(updatedMovie.id, equals(1)); // Should remain unchanged
      expect(updatedMovie.overview, equals('Test overview')); // Should remain unchanged
    });

    test('should include all properties in props list', () {
      // Act
      final props = movie.props;

      // Assert
      expect(props.length, equals(14)); // All 14 properties should be included
      expect(props.contains(1), isTrue); // id
      expect(props.contains('Test Movie'), isTrue); // title
      expect(props.contains('Test overview'), isTrue); // overview
    });
  });
}
