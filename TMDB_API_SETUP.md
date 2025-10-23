# 🔑 TMDB API Setup - Quick Guide

## 🎯 Get Your TMDB API Key

### Step 1: Create Account
1. Go to [TMDB API](https://www.themoviedb.org/documentation/api)
2. Click **"Sign Up"** 
3. Fill in your details and verify email

### Step 2: Request API Key
1. Go to [API Settings](https://www.themoviedb.org/settings/api)
2. Click **"Request an API Key"**
3. Fill out the form:
   - **Application Type**: Developer
   - **Application Name**: Movie Discovery App
   - **Application Summary**: Flutter app for discovering movies
   - **Application URL**: https://github.com/IvanDihalevich/movie_discovery_app
4. Accept terms and submit

### Step 3: Get Your Key
- Wait for approval (usually within 24 hours)
- Copy your **API Key (v3 auth)**

## 🔧 Update Your App

### Method 1: Update Constants File

Edit `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // Replace 'your_tmdb_api_key_here' with your actual API key
  static const String tmdbApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
  
  // ... rest of the constants
}
```

### Method 2: Test Your API Key

```bash
# Test with curl (replace YOUR_API_KEY)
curl "https://api.themoviedb.org/3/movie/popular?api_key=YOUR_API_KEY&page=1"
```

## 🚨 Important Notes

- **Keep your API key secure** - never commit it to public repositories
- **Rate limits**: 1000 requests per day (free tier)
- **API key is required** for all TMDB API calls

## ✅ Verification

After updating the API key, your app should be able to:
- ✅ Load popular movies
- ✅ Load top rated movies  
- ✅ Load now playing movies
- ✅ Load upcoming movies
- ✅ Search movies
- ✅ Get movie details

---

**Ready to start building your Movie Discovery App! 🎬✨**
