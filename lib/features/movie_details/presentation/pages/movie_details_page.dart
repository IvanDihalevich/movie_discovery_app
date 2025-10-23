import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../home/domain/entities/movie.dart';
import '../../../home/data/datasources/movie_remote_data_source.dart';
import '../../domain/entities/movie_video.dart';
import '../../domain/entities/movie_review.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/dependency_injection/injection.dart';
import '../../../../core/services/favorites_service.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  List<MovieVideo> trailers = [];
  List<MovieReview> reviews = [];
  bool isLoadingVideos = false;
  bool isLoadingReviews = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadTrailers();
    _loadReviews();
    _logImageUrls();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await FavoritesService.isFavorite(widget.movie.id);
    setState(() {
      isFavorite = isFav;
    });
  }

  void _logImageUrls() {
    print('Movie: ${widget.movie.title}');
    print('Poster path: ${widget.movie.posterPath}');
    print('Backdrop path: ${widget.movie.backdropPath}');
    if (widget.movie.posterPath != null) {
      print('Poster URL: ${AppConstants.tmdbImageBaseUrl}${AppConstants.imageSizeMedium}${widget.movie.posterPath}');
    }
    if (widget.movie.backdropPath != null) {
      print('Backdrop URL: ${AppConstants.tmdbImageBaseUrl}${AppConstants.imageSizeLarge}${widget.movie.backdropPath}');
    }
  }

  Future<void> _loadTrailers() async {
    setState(() {
      isLoadingVideos = true;
    });

    try {
      print('Loading trailers for movie ID: ${widget.movie.id}');
      final remoteDataSource = getIt<MovieRemoteDataSourceImpl>();
      final videosData = await remoteDataSource.getMovieVideos(widget.movie.id);
      
      print('Received videos data: $videosData');
      
      setState(() {
        trailers = videosData
            .where((video) => video['site'] == 'YouTube' && video['type'] == 'Trailer')
            .map((video) => MovieVideo.fromJson(video))
            .toList();
        isLoadingVideos = false;
      });
      
      print('Filtered trailers count: ${trailers.length}');
    } catch (e) {
      print('Error loading trailers: $e');
      setState(() {
        isLoadingVideos = false;
      });
    }
  }

  Future<void> _loadReviews() async {
    setState(() {
      isLoadingReviews = true;
    });

    try {
      print('Loading reviews for movie ID: ${widget.movie.id}');
      final remoteDataSource = getIt<MovieRemoteDataSourceImpl>();
      final reviewsData = await remoteDataSource.getMovieReviews(widget.movie.id);
      
      print('Received reviews data: $reviewsData');
      
      setState(() {
        reviews = reviewsData
            .map((review) => MovieReview.fromJson(review))
            .toList();
        isLoadingReviews = false;
      });
      
      print('Reviews count: ${reviews.length}');
    } catch (e) {
      print('Error loading reviews: $e');
      setState(() {
        isLoadingReviews = false;
      });
    }
  }

  Future<void> _launchTrailer(MovieVideo video) async {
    final url = video.youtubeUrl;
    if (url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with backdrop image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () async {
                  final success = await FavoritesService.toggleFavorite(widget.movie);
                  if (success) {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite 
                            ? 'Added to favorites!' 
                            : 'Removed from favorites!'
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: widget.movie.backdropPath != null
                  ? CachedNetworkImage(
                      imageUrl:
                          '${AppConstants.tmdbImageBaseUrl}${AppConstants.imageSizeLarge}${widget.movie.backdropPath}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        print('Error loading backdrop image: $error');
                        print('URL: $url');
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.movie,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          
          // Movie content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie title and rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: widget.movie.posterPath != null
                              ? '${AppConstants.tmdbImageBaseUrl}${AppConstants.imageSizeMedium}${widget.movie.posterPath}'
                              : '',
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 120,
                            height: 180,
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            print('Error loading poster image: $error');
                            print('URL: $url');
                            return Container(
                              width: 120,
                              height: 180,
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
                      
                      const SizedBox(width: 16),
                      
                      // Title and info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Rating
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 20,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${widget.movie.voteCount} votes)',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Release date
                            Text(
                              'Release Date: ${widget.movie.releaseDate.isNotEmpty ? DateTime.tryParse(widget.movie.releaseDate)?.year.toString() ?? widget.movie.releaseDate : 'N/A'}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Language
                            Text(
                              'Language: ${widget.movie.originalLanguage.toUpperCase()}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Overview
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    widget.movie.overview.isNotEmpty ? widget.movie.overview : 'No overview available.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Trailers Section
                  Text(
                    'Trailers & Videos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  if (isLoadingVideos)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (trailers.isEmpty)
                    const Text('No trailers available.')
                  else
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: trailers.length,
                        itemBuilder: (context, index) {
                          final trailer = trailers[index];
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () => _launchTrailer(trailer),
                              child: Card(
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Thumbnail
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(8),
                                          ),
                                          color: Colors.grey[300],
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Video info
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trailer.name,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            trailer.type,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.grey[600],
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Reviews Section
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  if (isLoadingReviews)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (reviews.isEmpty)
                    const Text('No reviews available.')
                  else
                    Column(
                      children: reviews.take(3).map((review) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        review.author,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    if (review.rating > 0)
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            review.rating.toStringAsFixed(1),
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  review.content.length > 200
                                      ? '${review.content.substring(0, 200)}...'
                                      : review.content,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                if (review.content.length > 200)
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Show full review
                                    },
                                    child: const Text('Read more'),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Additional info
                  Text(
                    'Additional Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  _buildInfoRow(context, 'Original Title', widget.movie.originalTitle),
                  _buildInfoRow(context, 'Popularity', widget.movie.popularity.toStringAsFixed(1)),
                  _buildInfoRow(context, 'Adult Content', widget.movie.adult ? 'Yes' : 'No'),
                  _buildInfoRow(context, 'Video Available', widget.movie.video ? 'Yes' : 'No'),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
