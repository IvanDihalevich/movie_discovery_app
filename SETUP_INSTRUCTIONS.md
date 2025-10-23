# 🚀 Setup Instructions for Movie Discovery App

## 📋 Prerequisites

### 1. Install Flutter SDK

#### Windows:
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract the zip file to `C:\flutter`
3. Add `C:\flutter\bin` to your PATH environment variable
4. Run `flutter doctor` to verify installation

#### macOS:
```bash
# Using Homebrew
brew install flutter

# Or download from flutter.dev and add to PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

#### Linux:
```bash
# Download and extract
wget https://storage.googleapis.com/flutter_infra_releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
tar xf flutter_linux_3.24.0-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
```

### 2. Verify Flutter Installation

```bash
flutter --version
flutter doctor
```

### 3. Install Android Studio (for Android development)

1. Download from [developer.android.com](https://developer.android.com/studio)
2. Install Android SDK
3. Create an Android Virtual Device (AVD)

### 4. Install VS Code (Recommended IDE)

1. Download from [code.visualstudio.com](https://code.visualstudio.com/)
2. Install Flutter extension
3. Install Dart extension

## 🔑 Get TMDB API Key

1. Go to [TMDB API](https://www.themoviedb.org/documentation/api)
2. Create an account
3. Request an API key
4. Copy your API key

## ⚙️ Project Setup

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd movie_discovery_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Update API Key

Edit `lib/core/constants/app_constants.dart` and replace:
```dart
static const String tmdbApiKey = 'your_tmdb_api_key_here';
```
with your actual API key:
```dart
static const String tmdbApiKey = 'your_actual_api_key';
```

### 4. Generate Code

```bash
flutter packages pub run build_runner build
```

### 5. Run the App

```bash
# For debug mode
flutter run

# For release mode
flutter run --release
```

## 🧪 Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/movie_test.dart
```

## 🔧 Development Commands

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Clean build
flutter clean
flutter pub get

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

## 📱 Running on Different Platforms

### Android
```bash
flutter run -d android
```

### iOS (macOS only)
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d web
```

### Desktop
```bash
flutter run -d windows  # Windows
flutter run -d macos    # macOS
flutter run -d linux    # Linux
```

## 🐛 Troubleshooting

### Common Issues:

1. **Flutter command not found**
   - Add Flutter to your PATH environment variable
   - Restart your terminal

2. **Android license issues**
   ```bash
   flutter doctor --android-licenses
   ```

3. **Dependencies issues**
   ```bash
   flutter clean
   flutter pub get
   ```

4. **Build issues**
   ```bash
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [TMDB API Documentation](https://developers.themoviedb.org/3/getting-started/introduction)
- [BLoC Pattern Guide](https://bloclibrary.dev/)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 🆘 Getting Help

If you encounter any issues:

1. Check the troubleshooting section above
2. Search for similar issues on [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
3. Check Flutter's [GitHub Issues](https://github.com/flutter/flutter/issues)
4. Ask for help in Flutter communities

---

**Note**: Make sure you have a stable internet connection for downloading dependencies and running the app.
