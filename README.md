# 🚀 Flutter Clean Architecture Starter Template

A production-ready **Cookiecutter** template for Flutter applications built with **Clean Architecture**, **BLoC**, and modern development practices.

## ✨ Features

### 🏗️ **Clean Architecture**
- **Domain Layer** - Business logic and entities
- **Data Layer** - Repositories and data sources (remote/local)
- **Presentation Layer** - Feature-based organization with BLoC state management

### 🔧 **State Management & DI**
- **BLoC Pattern** - Predictable state management
- **Get It + Injectable** - Dependency injection
- **Dartz** - Functional programming with Either types

### 💾 **Data & Network**
- **Hive** - Fast local NoSQL database
- **Dio + Retrofit** - Type-safe HTTP client
- **JSON Serialization** - Automatic model generation

### 🎯 **Feature-Based Architecture**
- **Domain-Driven Organization** - Features grouped by business logic
- **Barrel Exports** - Clean imports with single entry points
- **Scalable Structure** - Easy to add new features without conflicts
- **Team-Friendly** - Clear boundaries for parallel development

### 🎨 **UI & UX**
- **Material Design 3** - Modern UI components
- **Flutter ScreenUtil** - Responsive design
- **Flutter Native Splash** - Professional splash screens
- **GoRouter** - Declarative navigation
- **Flutter Hooks** - React-style state management
- **Formz** - Composable form validation

### 🔐 **Configuration & Security**
- **Envied** - Type-safe environment variables
- **Feature Flags** - Runtime behavior control
- **Multi-environment** support (dev/staging/prod)

### 🐛 **Development & Debugging**
- **Talker** - Advanced logging system
- **Code Generation** - Automated boilerplate
- **Easy Localization** - Internationalization ready

## 🛠️ Installation

### Prerequisites
- Python 3.7+ with `cookiecutter`
- Flutter SDK 3.0+
- Dart SDK

### Install Cookiecutter
```bash
pip install cookiecutter
```

### Generate Project
```bash
cookiecutter https://github.com/webdastur/flutter-starter-kit
```

Or use local template:
```bash
cookiecutter /path/to/cookiecutter-flutter-starter
```

## 📋 Template Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `project_name` | Human-readable project name | "My Flutter App" | "TaskMaster Pro" |
| `project_slug` | Project folder name (auto-generated) | `my_flutter_app` | `taskmaster_pro` |
| `project_description` | Brief project description | "A Flutter app..." | "Task management app" |
| `package_name` | Android/iOS package identifier | `com.example.my_flutter_app` | `com.company.taskmaster` |
| `author_name` | Your name | "Your Name" | "John Doe" |
| `author_email` | Your email | "your.email@example.com" | "john@company.com" |
| `flutter_version` | Flutter SDK constraint | ">=3.0.0" | ">=3.16.0" |
| `use_firebase` | Include Firebase setup | "n" | "y" |
| `use_sentry` | Include Sentry crash reporting | "n" | "y" |
| `use_analytics` | Include analytics | "n" | "y" |
| `primary_color` | App primary color (hex) | "#673AB7" | "#FF5722" |
| `primary_color_dark` | Dark mode primary color | "#2E2E2E" | "#212121" |
| `api_base_url` | Default API endpoint | "https://api.example.com" | "https://api.myapp.com" |
| `enable_logging` | Enable logging by default | "y" | "n" |
| `enable_crash_reporting` | Enable crash reporting | "n" | "y" |
| `enable_analytics` | Enable analytics | "n" | "y" |

## 🎯 Quick Start

After generating your project:

### 1. **Setup Dependencies**
```bash
cd your_project_name
flutter pub get
```

### 2. **Generate Code**
```bash
flutter packages pub run build_runner build
```

### 3. **Create Splash Screens**
```bash
flutter pub run flutter_native_splash:create
```

### 4. **Configure Environment**
```bash
# Edit .env file with your settings
nano .env

# Regenerate environment code
flutter packages pub run build_runner build
```

### 5. **Run the App**
```bash
flutter run
```

## 📁 Project Structure

```
your_project/
├── lib/
│   ├── core/                          # Core functionality
│   │   ├── config/                    # Environment configuration
│   │   ├── constants/                 # App constants
│   │   ├── di/                        # Dependency injection
│   │   ├── errors/                    # Error handling
│   │   ├── hooks/                     # Custom Flutter hooks
│   │   ├── router/                    # Navigation setup
│   │   ├── utils/                     # Utilities
│   │   └── validation/                # Form validation
│   ├── data/                          # Data layer
│   │   ├── datasources/               # Remote & local data sources
│   │   ├── models/                    # Data models
│   │   └── repositories/              # Repository implementations
│   ├── domain/                        # Domain layer
│   │   ├── entities/                  # Business entities
│   │   └── repositories/              # Repository contracts
│   └── presentation/                  # Presentation layer (Feature-based)
│       ├── todos/                     # Todo feature
│       │   ├── bloc/                  # Todo-specific BLoC
│       │   ├── pages/                 # Todo-specific pages
│       │   ├── widgets/               # Todo-specific widgets
│       │   └── todos.dart             # Barrel export
│       └── demos/                     # Demo feature
│           ├── pages/                 # Demo pages
│           ├── widgets/               # Demo widgets
│           └── demos.dart             # Barrel export
├── assets/                            # Static assets
│   ├── images/                        # Images & splash icons
│   └── translations/                  # Localization files
├── android/                           # Android-specific code
├── ios/                               # iOS-specific code
├── web/                               # Web-specific code
├── .env                               # Environment variables (gitignored)
├── pubspec.yaml                       # Dependencies & configuration
└── README.md                          # Project documentation
```

## 🔧 Configuration

### Environment Variables
Edit `.env` file:
```env
# API Configuration
API_BASE_URL=https://your-api.com
API_TIMEOUT=30000

# App Configuration
APP_NAME=Your App Name
DEBUG_MODE=true

# Feature Flags
ENABLE_LOGGING=true
ENABLE_CRASH_REPORTING=false
ENABLE_ANALYTICS=false

# Third-party Services
FIREBASE_API_KEY=your_key_here
SENTRY_DSN=your_dsn_here
```

### Splash Screen
Update `pubspec.yaml`:
```yaml
flutter_native_splash:
  color: "#YourColor"
  color_dark: "#YourDarkColor"
  image: assets/images/your_icon.png
```

### Package Name
Already configured during template generation, but you can update:
- **Android**: `android/app/build.gradle.kts`
- **iOS**: `ios/Runner.xcodeproj/project.pbxproj`

## 🧪 Demo Pages

The template includes demo pages to showcase features:

- **📱 Todos Demo** - CRUD operations with BLoC
- **🎨 Responsive Demo** - ScreenUtil responsive design
- **🪝 Hooks Demo** - Flutter Hooks examples
- **📝 Formz Demo** - Advanced form validation
- **⚙️ Environment Demo** - Configuration viewer

## 📚 Architecture Guide

### Adding New Features

1. **Domain Entity**
```dart
// lib/domain/entities/user_entity.dart
class UserEntity extends Equatable {
  final String id;
  final String name;
  // ... implementation
}
```

2. **Data Model**
```dart
// lib/data/models/user_model.dart
@JsonSerializable()
@HiveType(typeId: 1)
class UserModel extends HiveObject {
  // ... implementation
}
```

3. **Repository**
```dart
// lib/domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();
}
```

4. **Feature Structure**
```bash
mkdir -p lib/presentation/users/{bloc,pages,widgets}
```

5. **BLoC**
```dart
// lib/presentation/users/bloc/user_bloc.dart
class UserBloc extends Bloc<UserEvent, UserState> {
  // ... implementation
}
```

6. **UI**
```dart
// lib/presentation/users/pages/users_page.dart
class UsersPage extends StatelessWidget {
  // ... implementation with BlocBuilder
}
```

7. **Barrel Export**
```dart
// lib/presentation/users/users.dart
export 'bloc/user_bloc.dart';
export 'pages/users_page.dart';
export 'widgets/user_widget.dart';
```

## 🔄 Code Generation

Run when you add new models or change existing ones:

```bash
# Generate all code
flutter packages pub run build_runner build

# Watch for changes (development)
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 🌍 Internationalization

Add translations in `assets/translations/`:

```json
// assets/translations/en.json
{
  "hello": "Hello",
  "welcome": "Welcome to {appName}"
}
```

Use in code:
```dart
Text('hello'.tr())
Text('welcome'.tr(namedArgs: {'appName': 'MyApp'}))
```

## 🧪 Testing

The template is ready for testing:

```bash
# Unit tests
flutter test

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 🧰 Makefile Commands

After generating a project, you can use the Makefile in the project root to speed up common tasks.

```bash
# Discover available commands
make help

# Install dependencies
make setup         # or: make get

# Code generation
make gen           # one-time build
make watch         # watch mode
make gen-clean     # rebuild deleting conflicts

# Quality
make analyze       # static analysis
make format        # dart format
make sort-imports  # organize imports

# Assets
make splash        # (re)generate native splash assets

# Testing
make test

# Run
make run           # auto device
make run-ios       # iOS simulator/device
make run-android   # Android emulator/device

# Clean
make clean

# Build
make build-android # release APK
make build-ios     # release iOS (requires Xcode setup)
make build-web     # release Web
```

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ✅ **Web** (Chrome, Safari, Firefox)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Windows** (Windows 10+)
- ✅ **Linux** (Ubuntu 18.04+)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the template generation
5. Submit a pull request

## 📄 License

This template is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

Built with these amazing packages:
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [get_it](https://pub.dev/packages/get_it)
- [hive](https://pub.dev/packages/hive)
- [dio](https://pub.dev/packages/dio)
- [go_router](https://pub.dev/packages/go_router)
- [flutter_hooks](https://pub.dev/packages/flutter_hooks)
- [formz](https://pub.dev/packages/formz)
- [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- [envied](https://pub.dev/packages/envied)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
- [talker](https://pub.dev/packages/talker)

---

**Happy Coding! 🚀**
