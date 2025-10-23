# 🔑 TMDB API Setup Guide

## 📋 Getting Your TMDB API Key

### Step 1: Create TMDB Account

1. Go to [The Movie Database (TMDB)](https://www.themoviedb.org/)
2. Click **"Sign Up"** in the top right corner
3. Fill in your details:
   - Username
   - Email
   - Password
4. Verify your email address

### Step 2: Request API Key

1. After logging in, go to [TMDB API Settings](https://www.themoviedb.org/settings/api)
2. Click **"Request an API Key"**
3. Fill out the application form:
   - **Application Type**: Select "Developer"
   - **Application Name**: Enter "Movie Discovery App" (or your preferred name)
   - **Application Summary**: Describe your app briefly
   - **Application URL**: Enter your website or GitHub repository URL
4. Accept the terms and conditions
5. Click **"Submit"**

### Step 3: Get Your API Key

1. Once approved (usually within 24 hours), go back to [API Settings](https://www.themoviedb.org/settings/api)
2. You'll see your **API Key (v3 auth)**
3. Copy this key - you'll need it for the app

## 🔧 Adding API Key to Your App

### Method 1: Update Constants File

Edit `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // Replace 'your_tmdb_api_key_here' with your actual API key
  static const String tmdbApiKey = 'your_actual_api_key_here';
  
  // ... rest of the constants
}
```

### Method 2: Environment Variables (Recommended for Production)

1. Create a `.env` file in your project root:
```env
TMDB_API_KEY=your_actual_api_key_here
```

2. Update `lib/core/constants/app_constants.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get tmdbApiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  
  // ... rest of the constants
}
```

3. Load the environment variables in `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MovieDiscoveryApp());
}
```

## 🔒 Security Best Practices

### For Development:
- ✅ Use your personal API key
- ✅ Keep it in constants file for easy testing

### For Production:
- ❌ Never commit API keys to version control
- ✅ Use environment variables
- ✅ Use secure storage for sensitive data
- ✅ Consider using a backend proxy for API calls

## 📚 API Usage Limits

### Free Tier Limits:
- **Requests per day**: 1,000 requests
- **Requests per second**: 40 requests per 10 seconds

### Paid Tier Limits:
- **Requests per day**: 10,000+ requests
- **Requests per second**: 100+ requests per 10 seconds

## 🧪 Testing Your API Key

### Test API Connection:

```dart
import 'package:dio/dio.dart';

Future<void> testApiKey() async {
  final dio = Dio();
  
  try {
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/popular',
      queryParameters: {
        'api_key': 'YOUR_API_KEY_HERE',
        'page': 1,
      },
    );
    
    if (response.statusCode == 200) {
      print('✅ API key is working!');
      print('Response: ${response.data}');
    } else {
      print('❌ API key test failed');
    }
  } catch (e) {
    print('❌ Error testing API key: $e');
  }
}
```

## 🚨 Common Issues

### Issue 1: "Invalid API key"
- **Cause**: Wrong API key or key not set
- **Solution**: Double-check your API key in the constants file

### Issue 2: "API key not found"
- **Cause**: API key is empty or null
- **Solution**: Make sure the API key is properly set

### Issue 3: "Rate limit exceeded"
- **Cause**: Too many requests in a short time
- **Solution**: Implement request throttling or caching

### Issue 4: "Account not approved"
- **Cause**: API key request not yet approved
- **Solution**: Wait for approval or contact TMDB support

## 📖 API Documentation

- [TMDB API Documentation](https://developers.themoviedb.org/3/getting-started/introduction)
- [API Endpoints](https://developers.themoviedb.org/3/getting-started/endpoints)
- [Authentication](https://developers.themoviedb.org/3/authentication)
- [Rate Limiting](https://developers.themoviedb.org/3/getting-started/request-rate-limiting)

## 🆘 Getting Help

If you encounter issues:

1. Check the [TMDB API Status](https://status.themoviedb.org/)
2. Visit [TMDB API Forums](https://www.themoviedb.org/talk/category/5047951f760ee3318900009d)
3. Contact TMDB Support
4. Check your API key status in [API Settings](https://www.themoviedb.org/settings/api)

---

**Note**: Keep your API key secure and never share it publicly!
