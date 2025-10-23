class AppConstants {
  // API Configuration
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String tmdbApiKey = '09f7b981df36791466730a0ee33d468e'; // Your TMDB API key
  
  // Image Sizes
  static const String imageSizeSmall = 'w185';
  static const String imageSizeMedium = 'w342';
  static const String imageSizeLarge = 'w500';
  static const String imageSizeOriginal = 'original';
  
  // Database
  static const String databaseName = 'movie_discovery.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String hiveBoxName = 'app_preferences';
  static const String secureStorageKey = 'user_token';
  static const String favoritesKey = 'favorites';
  static const String watchlistKey = 'watchlist';
  
  // App Info
  static const String appName = 'Movie Discovery';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 1000;
  
  // Cache Duration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const Duration shortCacheExpiration = Duration(minutes: 30);
}
