import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'movie_card_widget.dart';

class MovieListWidget extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final Function(Movie) onMovieTap;
  final VoidCallback? onLoadMore;

  const MovieListWidget({
    super.key,
    required this.title,
    required this.movies,
    required this.onMovieTap,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length + (onLoadMore != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == movies.length) {
                // Load more button
                return Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: onLoadMore,
                      child: const Text('Load More'),
                    ),
                  ),
                );
              }

              final movie = movies[index];
              return MovieCardWidget(
                movie: movie,
                onTap: () => onMovieTap(movie),
              );
            },
          ),
        ),
      ],
    );
  }
}
