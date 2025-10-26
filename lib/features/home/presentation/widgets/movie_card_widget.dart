import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/movie.dart';
import '../../../../core/constants/app_constants.dart';

class MovieCardWidget extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCardWidget({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: movie.posterPath != null
                      ? '${AppConstants.tmdbImageBaseUrl}${AppConstants.imageSizeMedium}${movie.posterPath}'
                      : '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    print('Error loading poster image: $error');
                    print('URL: $url');
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.movie,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Movie Title
            Expanded(
              flex: 1,
              child: Text(
                movie.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Rating
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            // Release Date
            Text(
              movie.releaseDate.isNotEmpty
                  ? DateTime.tryParse(movie.releaseDate)?.year.toString() ?? ''
                  : '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
