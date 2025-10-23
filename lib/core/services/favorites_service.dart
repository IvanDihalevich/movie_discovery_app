import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../features/home/domain/entities/movie.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_movies';
  
  // Get all favorite movies
  static Future<List<Movie>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    
    return favoritesJson.map((json) {
      final Map<String, dynamic> movieMap = jsonDecode(json);
      return Movie.fromJson(movieMap);
    }).toList();
  }
  
  // Add movie to favorites
  static Future<bool> addToFavorites(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    // Check if already in favorites
    if (favorites.any((fav) => fav.id == movie.id)) {
      return false; // Already in favorites
    }
    
    favorites.add(movie);
    final favoritesJson = favorites.map((movie) => jsonEncode(movie.toJson())).toList();
    
    return await prefs.setStringList(_favoritesKey, favoritesJson);
  }
  
  // Remove movie from favorites
  static Future<bool> removeFromFavorites(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    favorites.removeWhere((movie) => movie.id == movieId);
    final favoritesJson = favorites.map((movie) => jsonEncode(movie.toJson())).toList();
    
    return await prefs.setStringList(_favoritesKey, favoritesJson);
  }
  
  // Check if movie is in favorites
  static Future<bool> isFavorite(int movieId) async {
    final favorites = await getFavorites();
    return favorites.any((movie) => movie.id == movieId);
  }
  
  // Toggle favorite status
  static Future<bool> toggleFavorite(Movie movie) async {
    final isCurrentlyFavorite = await isFavorite(movie.id);
    
    if (isCurrentlyFavorite) {
      return await removeFromFavorites(movie.id);
    } else {
      return await addToFavorites(movie);
    }
  }
}
