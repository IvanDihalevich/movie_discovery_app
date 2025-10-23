# 🔧 Git & GitHub Setup Instructions

## 📋 Prerequisites

### 1. Install Git

#### Windows:
1. Download Git from [git-scm.com](https://git-scm.com/download/win)
2. Run the installer and follow the setup wizard
3. Choose default options for most settings
4. After installation, restart your terminal/command prompt

#### macOS:
```bash
# Using Homebrew
brew install git

# Or download from git-scm.com
```

#### Linux:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install git

# CentOS/RHEL
sudo yum install git
```

### 2. Verify Git Installation

```bash
git --version
```

### 3. Configure Git (First time setup)

```bash
# Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main
```

## 🚀 Project Setup on GitHub

### Step 1: Initialize Git Repository

```bash
# Navigate to your project directory
cd movie_discovery_app

# Initialize git repository
git init

# Add all files to git
git add .

# Make initial commit
git commit -m "Initial commit: Movie Discovery App with Clean Architecture"
```

### Step 2: Create GitHub Repository

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the **"+"** button in the top right corner
3. Select **"New repository"**
4. Fill in the repository details:
   - **Repository name**: `movie_discovery_app`
   - **Description**: `Flutter Movie Discovery App with Clean Architecture, BLoC pattern, and TMDB API integration`
   - **Visibility**: Choose Public or Private
   - **Initialize**: Leave unchecked (we already have files)
5. Click **"Create repository"**

### Step 3: Connect Local Repository to GitHub

```bash
# Add GitHub repository as remote origin
git remote add origin https://github.com/YOUR_USERNAME/movie_discovery_app.git

# Push your code to GitHub
git push -u origin main
```

### Alternative: Using GitHub CLI

If you have GitHub CLI installed:

```bash
# Create repository and push in one command
gh repo create movie_discovery_app --public --source=. --remote=origin --push
```

## 📁 Project Structure on GitHub

Your repository should contain:

```
movie_discovery_app/
├── .github/
│   └── workflows/
│       └── flutter.yml          # CI/CD pipeline
├── lib/
│   ├── core/                    # Core functionality
│   ├── features/               # Feature modules
│   ├── shared/                 # Shared components
│   └── main.dart               # App entry point
├── test/                       # Unit and widget tests
├── integration_test/           # Integration tests
├── assets/                     # App assets
├── .gitignore                  # Git ignore rules
├── analysis_options.yaml       # Code analysis rules
├── pubspec.yaml               # Dependencies
├── README.md                  # Project documentation
├── SETUP_INSTRUCTIONS.md      # Setup guide
├── API_SETUP.md               # API setup guide
└── GIT_SETUP.md               # This file
```

## 🔄 Daily Git Workflow

### Making Changes

```bash
# Check status of your files
git status

# Add specific files
git add lib/features/home/presentation/pages/home_page.dart

# Or add all changes
git add .

# Commit changes
git commit -m "Add movie details screen"

# Push to GitHub
git push
```

### Creating Feature Branches

```bash
# Create and switch to new branch
git checkout -b feature/movie-search

# Make your changes...
# Add and commit changes
git add .
git commit -m "Implement movie search functionality"

# Push branch to GitHub
git push -u origin feature/movie-search

# Create Pull Request on GitHub
```

### Merging Changes

```bash
# Switch to main branch
git checkout main

# Pull latest changes
git pull origin main

# Merge feature branch
git merge feature/movie-search

# Push merged changes
git push origin main
```

## 🏷️ Git Tags and Releases

### Creating Tags

```bash
# Create a tag for version 1.0.0
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tags to GitHub
git push origin v1.0.0
```

### Creating GitHub Release

1. Go to your repository on GitHub
2. Click **"Releases"** in the right sidebar
3. Click **"Create a new release"**
4. Fill in the release details:
   - **Tag version**: `v1.0.0`
   - **Release title**: `Movie Discovery App v1.0.0`
   - **Description**: List of features and changes
5. Click **"Publish release"**

## 🔧 GitHub Repository Settings

### Enable GitHub Actions

1. Go to your repository settings
2. Navigate to **"Actions"** → **"General"**
3. Ensure **"Allow all actions and reusable workflows"** is selected

### Enable Issues and Projects

1. Go to repository settings
2. Scroll down to **"Features"**
3. Enable **"Issues"** and **"Projects"**

### Set up Branch Protection

1. Go to **"Settings"** → **"Branches"**
2. Click **"Add rule"**
3. Configure protection for `main` branch:
   - Require pull request reviews
   - Require status checks to pass
   - Require branches to be up to date

## 🚨 Common Issues and Solutions

### Issue 1: "git: command not found"
- **Solution**: Install Git from [git-scm.com](https://git-scm.com/)

### Issue 2: "Permission denied (publickey)"
- **Solution**: Set up SSH keys or use HTTPS with personal access token

### Issue 3: "Repository not found"
- **Solution**: Check repository URL and permissions

### Issue 4: "Merge conflicts"
- **Solution**: Resolve conflicts manually and commit

## 📚 Additional Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Documentation](https://docs.github.com/)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/ci)
- [Git Best Practices](https://www.atlassian.com/git/tutorials/comparing-workflows)

## 🆘 Getting Help

If you encounter issues:

1. Check Git documentation
2. Search Stack Overflow for Git/GitHub issues
3. Ask for help in Flutter communities
4. Check GitHub's troubleshooting guides

---

**Note**: Make sure to keep your repository updated regularly and follow good Git practices!
