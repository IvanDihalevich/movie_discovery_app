import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../home/domain/entities/movie.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../movie_details/presentation/pages/movie_details_page.dart';
import '../../../../core/dependency_injection/injection.dart';
import '../../../home/data/datasources/movie_remote_data_source.dart';

class AdvancedSearchPage extends StatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  State<AdvancedSearchPage> createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  
  List<Movie> searchResults = [];
  List<String> selectedGenres = [];
  bool isLoading = false;
  String? errorMessage;
  
  // Popular genres
  final Map<String, int> genres = {
    'Action': 28,
    'Adventure': 12,
    'Animation': 16,
    'Comedy': 35,
    'Crime': 80,
    'Documentary': 99,
    'Drama': 18,
    'Family': 10751,
    'Fantasy': 14,
    'History': 36,
    'Horror': 27,
    'Music': 10402,
    'Mystery': 9648,
    'Romance': 10749,
    'Science Fiction': 878,
    'TV Movie': 10770,
    'Thriller': 53,
    'War': 10752,
    'Western': 37,
  };

  @override
  void dispose() {
    _searchController.dispose();
    _yearController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    // Allow search even with empty query for genre-only searches
    final query = _searchController.text.trim().isNotEmpty 
        ? _searchController.text.trim() 
        : 'movie'; // Default query for genre-only searches

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final remoteDataSource = getIt<MovieRemoteDataSourceImpl>();
      final results = await remoteDataSource.searchMovies(
        query,
        year: _yearController.text.trim().isNotEmpty ? int.tryParse(_yearController.text.trim()) : null,
        rating: _ratingController.text.trim().isNotEmpty ? double.tryParse(_ratingController.text.trim()) : null,
        genres: selectedGenres.isNotEmpty ? selectedGenres.map((g) => genres[g]!).toList() : null,
      );
      
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Search failed: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _navigateToMovieDetails(Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Search'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Search filters
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title search
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Enter movie title... (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    helperText: 'Leave empty to search by filters only',
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Year and rating
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _yearController,
                        decoration: const InputDecoration(
                          hintText: 'Year (optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                          helperText: 'e.g., 2023',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _ratingController,
                        decoration: const InputDecoration(
                          hintText: 'Min rating (optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.star),
                          helperText: '1-10',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Genres
                Text(
                  'Genres (optional):',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: genres.keys.map((genre) {
                    final isSelected = selectedGenres.contains(genre);
                    return FilterChip(
                      label: Text(genre),
                      selected: isSelected,
                      onSelected: (_) => _toggleGenre(genre),
                      selectedColor: Colors.blue[100],
                      checkmarkColor: Colors.blue[800],
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Search button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _performSearch,
                    icon: isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label: Text(isLoading ? 'Searching...' : 'Search Movies'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No movies found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Advanced Search',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Use filters to find your perfect movie',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final movie = searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: movie.posterPath != null
                    ? '${AppConstants.tmdbImageBaseUrl}${AppConstants.imageSizeSmall}${movie.posterPath}'
                    : '',
                httpHeaders: const {
                  'User-Agent': 'MovieDiscoveryApp/1.0',
                },
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue[200]!,
                        Colors.purple[200]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.movie,
                      color: Colors.white,
                    ),
                  ),
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
            onTap: () => _navigateToMovieDetails(movie),
          ),
        );
      },
    );
  }
}
