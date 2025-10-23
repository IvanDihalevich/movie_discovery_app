import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../home/domain/entities/movie.dart';
import '../../../../core/services/favorites_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../movie_details/presentation/pages/movie_details_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Movie> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      isLoading = true;
    });

    try {
      final favs = await FavoritesService.getFavorites();
      setState(() {
        favorites = favs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(Movie movie) async {
    final success = await FavoritesService.removeFromFavorites(movie.id);
    if (success) {
      setState(() {
        favorites.removeWhere((m) => m.id == movie.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${movie.title} removed from favorites')),
      );
    }
  }

  void _navigateToMovieDetails(Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add movies to your favorites to see them here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final movie = favorites[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterPath != null
                                  ? '${AppConstants.tmdbImageBaseUrl}${AppConstants.imageSizeSmall}${movie.posterPath}'
                                  : '',
                              width: 60,
                              height: 90,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 60,
                                height: 90,
                                color: Colors.grey[300],
                                child: const Icon(Icons.movie),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 60,
                                height: 90,
                                color: Colors.grey[300],
                                child: const Icon(Icons.movie),
                              ),
                            ),
                          ),
                          title: Text(
                            movie.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.overview.length > 100
                                    ? '${movie.overview.substring(0, 100)}...'
                                    : movie.overview,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text('${movie.voteAverage.toStringAsFixed(1)}/10'),
                                  const SizedBox(width: 16),
                                  Text('${movie.releaseDate.isNotEmpty ? DateTime.tryParse(movie.releaseDate)?.year.toString() ?? movie.releaseDate : 'N/A'}'),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () => _removeFavorite(movie),
                          ),
                          onTap: () => _navigateToMovieDetails(movie),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
