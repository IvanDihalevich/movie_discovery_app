# 🎬 Movie Discovery App

A Flutter application for discovering movies and TV shows using The Movie Database (TMDB) API.

## 🎯 Project Overview

This project implements a **Movie Discovery App** following Clean Architecture principles with BLoC pattern for state management. The app provides users with a comprehensive movie browsing experience including popular movies, top-rated content, search functionality, and favorites management.

## 🏗️ Architecture

- **Clean Architecture** with 3 layers (Presentation, Domain, Data)
- **BLoC Pattern** for state management
- **Repository Pattern** for data access
- **Dependency Injection** using GetIt
- **Offline-first** approach with caching

## 🌐 API Integration

- **TMDB API** for movie data
- **Dio** HTTP client with interceptors
- **Error handling** with retry mechanisms
- **Caching** for offline support

## 🚀 Features

- 📱 Browse popular, top-rated, now playing, and upcoming movies
- 🔍 Search movies by title
- ❤️ Add movies to favorites/watchlist
- 🎬 View detailed movie information
- 🖼️ High-quality movie posters and backdrops
- 🌙 Dark/Light theme support
- 📱 Responsive design for all screen sizes

## 🛠️ Setup Instructions

### Prerequisites

1. **Flutter SDK** (3.9.2 or higher)
   ```bash
   # Check Flutter installation
   flutter --version
   ```

2. **TMDB API Key**
   - Go to [TMDB API](https://www.themoviedb.org/documentation/api)
   - Create an account and get your API key
   - Update `lib/core/constants/app_constants.dart` with your API key

### Installation

1. **Install Prerequisites**
   - Install [Flutter SDK](https://flutter.dev/docs/get-started/install)
   - Install [Git](https://git-scm.com/downloads)
   - Install [Android Studio](https://developer.android.com/studio) (for Android development)

2. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd movie_discovery_app
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate code** (for models and repositories)
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants and configuration
│   ├── errors/             # Error handling classes
│   ├── network/            # HTTP client and network configuration
│   ├── storage/            # Local storage implementations
│   ├── utils/              # Utility functions
│   └── dependency_injection/ # DI setup
├── features/               # Feature modules
│   ├── auth/              # Authentication feature
│   ├── home/              # Home screen with movie lists
│   ├── movie_details/     # Movie details screen
│   ├── favorites/         # Favorites management
│   ├── search/            # Movie search functionality
│   └── profile/           # User profile
├── shared/                # Shared components
│   ├── widgets/           # Reusable UI components
│   ├── models/            # Shared data models
│   └── utils/             # Shared utilities
└── main.dart              # App entry point
```

## 🧪 Testing

### Running Tests

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/

# Coverage report
flutter test --coverage
```

### Test Coverage

- **Unit Tests**: Business logic and use cases
- **Widget Tests**: UI components
- **Integration Tests**: End-to-end user flows
- **Target Coverage**: 70%+

## 🔧 CI/CD

The project includes GitHub Actions workflow for:

- ✅ Automated testing on push/PR
- ✅ Code analysis and linting
- ✅ APK build artifacts
- ✅ Coverage reports

## 📊 Performance Optimizations

- **Lazy loading** for movie lists
- **Image caching** with CachedNetworkImage
- **Widget rebuild optimization** with BLoC
- **Memory management** for large datasets
- **Offline caching** for better UX

## 🔒 Security Measures

- **API keys** stored securely
- **Secure storage** for user tokens
- **Code obfuscation** for release builds
- **Input validation** for all user inputs

## 🎨 UI/UX Features

- **Custom widgets** for movie cards and lists
- **Hero animations** for smooth transitions
- **Loading animations** with shimmer effects
- **Responsive design** for all devices
- **Material Design 3** components

## 📱 Screenshots

*Screenshots will be added after UI implementation*

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🔧 Git & GitHub Setup

### Quick Setup (Windows)

1. **Install Git**: Download from [git-scm.com](https://git-scm.com/download/win)
2. **Run setup script**: Double-click `setup_git.bat` or run `setup_git.ps1`
3. **Your GitHub repository**: [https://github.com/IvanDihalevich/movie_discovery_app](https://github.com/IvanDihalevich/movie_discovery_app)

### Manual Setup

```bash
# Initialize Git repository
git init

# Add files
git add .

# Make initial commit
git commit -m "Initial commit: Movie Discovery App"

# Connect to GitHub
git remote add origin https://github.com/IvanDihalevich/movie_discovery_app.git

# Push to GitHub
git push -u origin main
```

For detailed instructions, see [GIT_SETUP.md](GIT_SETUP.md)

## 🎯 Next Steps

- [ ] Install Git and set up GitHub repository
- [ ] Get TMDB API key and update constants
- [ ] Implement TMDB API integration
- [ ] Add authentication system
- [ ] Create movie details screen
- [ ] Implement favorites functionality
- [ ] Add search feature
- [ ] Test CI/CD pipeline
- [ ] Add comprehensive testing
- [ ] Optimize performance
- [ ] Add dark theme support

---

**Note**: This project is part of a Flutter course assignment demonstrating professional app development practices.
