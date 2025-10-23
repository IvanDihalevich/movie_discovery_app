# 🚀 Quick Start Guide

## ⚡ Get Started in 5 Minutes

### Step 1: Install Prerequisites

1. **Install Flutter SDK**
   - Windows: Download from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
   - macOS: `brew install flutter`
   - Linux: Follow [Flutter install guide](https://flutter.dev/docs/get-started/install/linux)

2. **Install Git**
   - Windows: Download from [git-scm.com](https://git-scm.com/download/win)
   - macOS: `brew install git`
   - Linux: `sudo apt install git`

3. **Install Android Studio** (for Android development)
   - Download from [developer.android.com](https://developer.android.com/studio)

### Step 2: Set Up Project

1. **Clone or Download Project**
   ```bash
   # If you have Git installed
   git clone <repository-url>
   cd movie_discovery_app
   
   # Or download ZIP and extract
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Get TMDB API Key**
   - Go to [TMDB API](https://www.themoviedb.org/documentation/api)
   - Create account and get API key
   - Update `lib/core/constants/app_constants.dart`

### Step 3: Run the App

```bash
flutter run
```

## 🔧 Alternative Setup Methods

### Method 1: Automated Setup (Windows)

1. Install Flutter and Git
2. Double-click `setup_git.bat`
3. Follow the prompts

### Method 2: PowerShell Setup

1. Install Flutter and Git
2. Run PowerShell as Administrator
3. Execute: `PowerShell -ExecutionPolicy Bypass -File setup_git.ps1`

### Method 3: Manual Setup

Follow the detailed instructions in:
- [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md)
- [GIT_SETUP.md](GIT_SETUP.md)
- [API_SETUP.md](API_SETUP.md)

## 🐛 Troubleshooting

### Common Issues:

1. **"flutter: command not found"**
   - Add Flutter to your PATH environment variable
   - Restart terminal/command prompt

2. **"git: command not found"**
   - Install Git from [git-scm.com](https://git-scm.com/)
   - Restart terminal/command prompt

3. **"Android license issues"**
   ```bash
   flutter doctor --android-licenses
   ```

4. **"Dependencies issues"**
   ```bash
   flutter clean
   flutter pub get
   ```

## 📱 Running on Different Platforms

```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios

# Web
flutter run -d web

# Desktop
flutter run -d windows  # Windows
flutter run -d macos    # macOS
flutter run -d linux    # Linux
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/unit/movie_test.dart
```

## 📚 Next Steps

1. **Get TMDB API Key** - See [API_SETUP.md](API_SETUP.md)
2. **Set up GitHub Repository** - See [GIT_SETUP.md](GIT_SETUP.md)
3. **Implement Features** - Follow the project structure
4. **Add Tests** - Write unit, widget, and integration tests
5. **Deploy** - Use CI/CD pipeline for automated deployment

## 🆘 Need Help?

- Check [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for detailed setup
- Read [API_SETUP.md](API_SETUP.md) for TMDB API configuration
- Follow [GIT_SETUP.md](GIT_SETUP.md) for GitHub setup
- Search [Flutter Documentation](https://flutter.dev/docs)
- Ask questions in Flutter communities

---

**Happy Coding! 🎬✨**
