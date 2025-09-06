# {{ cookiecutter.project_name }}

{{ cookiecutter.project_description }}

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Generate code (DI, JSON serialization, etc.)
flutter packages pub run build_runner build

# Create native splash screens
flutter pub run flutter_native_splash:create

# Run the app
flutter run
```

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with **feature-based organization** for optimal maintainability and scalability.

### Project Structure

```
lib/
├── core/                    # Core utilities and configurations
│   ├── config/             # Environment configuration (envied)
│   ├── constants/          # App constants and dimensions
│   ├── di/                # Dependency injection (get_it + injectable)
│   ├── errors/            # Error handling (exceptions & failures)
│   ├── hooks/             # Custom Flutter hooks
│   ├── router/            # Navigation (GoRouter)
│   └── utils/             # Utility functions and logging
├── data/                   # Data layer (external concerns)
│   ├── datasources/       # Data sources (local & remote)
│   │   ├── local/         # Local storage (Hive)
│   │   └── remote/        # API calls (Retrofit + Dio)
│   ├── models/            # Data models with JSON serialization
│   └── repositories/      # Repository implementations
├── domain/                 # Domain layer (business logic)
│   ├── entities/          # Business entities
│   └── repositories/      # Repository contracts
└── presentation/           # Presentation layer (UI) - Feature-based
    ├── todos/             # Todo feature
    │   ├── bloc/          # Todo-specific BLoC
    │   ├── pages/         # Todo-specific pages
    │   ├── widgets/       # Todo-specific widgets
    │   └── todos.dart     # Barrel export
    └── demos/             # Demo feature
        ├── pages/         # Demo pages
        ├── widgets/       # Demo widgets
        └── demos.dart     # Barrel export
```

## 🎯 Feature-Based Presentation Layer

### Why Feature-Based Organization?

The presentation layer is organized by **feature/domain** rather than by type, providing:

- ✅ **Better Maintainability** - Related code grouped together
- ✅ **Team Collaboration** - Clear feature ownership boundaries
- ✅ **Scalability** - Easy to add new features without cluttering
- ✅ **Testability** - Feature-specific tests can be organized similarly

### Feature Structure

Each feature follows this pattern:
```
presentation/feature_name/
├── bloc/                   # Feature-specific state management
├── pages/                  # Feature-specific pages
├── widgets/               # Feature-specific widgets
└── feature_name.dart      # Barrel export for clean imports
```

### Barrel Exports

Clean imports using barrel exports:

```dart
// Instead of multiple imports:
import '../../presentation/todos/bloc/todo_bloc.dart';
import '../../presentation/todos/pages/todos_page.dart';
import '../../presentation/todos/widgets/todo_item_widget.dart';

// Use single barrel import:
import '../../presentation/todos/todos.dart';
```

## 📦 Tech Stack & Packages

### 🏛️ Architecture & State Management
- **flutter_bloc** (^9.1.1) - BLoC pattern for state management
- **get_it** (^8.2.0) + **injectable** (^2.5.1) - Dependency injection
- **dartz** (^0.10.1) - Functional programming (Either types)
- **equatable** (^2.0.7) - Value equality

### 🌐 Network & Data
- **dio** (^5.9.0) - HTTP client
- **retrofit** (^4.7.2) - Type-safe API client
- **json_annotation** + **json_serializable** - JSON serialization
- **hive** (^2.2.3) + **hive_flutter** - Local storage

### 🎨 UI & Navigation
- **go_router** (^14.8.1) - Declarative navigation
- **flutter_hooks** (^0.20.5) - React-style hooks
- **flutter_screenutil** (^5.9.3) - Responsive design
- **formz** (^0.7.0) - Form validation

### 🛠️ Development & Tools
- **envied** (^0.5.4+1) - Environment variable management
- **talker** (^5.0.0) - Advanced logging and debugging
- **flutter_native_splash** (^2.4.6) - Native splash screens
- **easy_localization** (^3.0.8) - Internationalization
- **build_runner** - Code generation

## 🔧 Environment Configuration

The app uses **envied** for type-safe environment variable management:

### Setup
1. Copy `.env.example` to `.env` (if exists) or create your own `.env` file
2. Configure your environment variables:

```env
# API Configuration
API_BASE_URL={{ cookiecutter.api_base_url }}
API_TIMEOUT=30000

# App Configuration
APP_NAME={{ cookiecutter.project_name }}
APP_VERSION=1.0.0
DEBUG_MODE=true

# Feature Flags
ENABLE_LOGGING={{ cookiecutter.enable_logging }}
ENABLE_CRASH_REPORTING={{ cookiecutter.enable_crash_reporting }}
ENABLE_ANALYTICS={{ cookiecutter.enable_analytics }}

# Third-party Services
FIREBASE_API_KEY=your_firebase_key_here
SENTRY_DSN=your_sentry_dsn_here
```

### Usage
```dart
import 'core/config/env.dart';

// Type-safe access to environment variables
final apiUrl = Env.apiBaseUrl;
final isDebug = Env.isDebugMode;
final timeout = Env.apiTimeoutMs;
```

## 🎨 Responsive Design

Using **flutter_screenutil** for mobile-optimized responsive design:

### Screen Breakpoints
- **Small phones**: < 360dp width
- **Medium phones**: 360dp - 400dp width  
- **Large phones**: > 400dp width
- **Tablets**: > 600dp width (graceful degradation)

### Usage Examples
```dart
// Responsive sizing
Container(
  width: 200.w,          // 200 logical pixels
  height: 100.h,         // 100 logical pixels
  padding: EdgeInsets.all(16.w),
)

// Responsive text
Text(
  'Hello World',
  style: TextStyle(fontSize: 16.sp), // 16 scaled pixels
)

// Custom dimensions
Container(
  padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
  margin: EdgeInsets.symmetric(
    horizontal: AppDimensions.marginLarge.w,
    vertical: AppDimensions.marginSmall.h,
  ),
)
```

## 🎣 Flutter Hooks Integration

Custom hooks for common patterns:

### Available Hooks
```dart
// Todo operations
final todoOps = useTodoOperations();
todoOps.addTodo(todo);
todoOps.updateTodo(todo);
todoOps.deleteTodo(id);

// Form management with Formz
final formState = useTodoFormz();
final isValid = formState.status.isValid;

// Navigation
final navigation = useAppNavigation();
navigation.pushAddTodo();
navigation.pop();

// Search functionality
final searchController = useSearch();
```

### Custom Hook Example
```dart
TodoOperations useTodoOperations() {
  final bloc = useBloc<TodoBloc>();
  
  return TodoOperations(
    addTodo: (todo) => bloc.add(AddTodoEvent(todo)),
    updateTodo: (todo) => bloc.add(UpdateTodoEvent(todo)),
    deleteTodo: (id) => bloc.add(DeleteTodoEvent(id)),
  );
}
```

## 📋 Form Validation with Formz

Type-safe, composable form validation:

### Form Input Classes
```dart
// Title validation
class TodoTitle extends FormzInput<String, TodoTitleValidationError> {
  const TodoTitle.pure() : super.pure('');
  const TodoTitle.dirty([String value = '']) : super.dirty(value);
  
  @override
  TodoTitleValidationError? validator(String value) {
    if (value.isEmpty) return TodoTitleValidationError.empty;
    if (value.length < 3) return TodoTitleValidationError.tooShort;
    return null;
  }
}
```

### Form State Management
```dart
class TodoFormState with FormzMixin {
  final TodoTitle title;
  final TodoDescription description;

  const TodoFormState({
    this.title = const TodoTitle.pure(),
    this.description = const TodoDescription.pure(),
  });

  @override
  List<FormzInput> get inputs => [title, description];
}
```

## 🌍 Internationalization

Supports multiple languages with **easy_localization**:

### Available Languages
- 🇺🇸 English (en)
- 🇪🇸 Spanish (es)

### Adding Translations
1. Add translations to `assets/translations/`:
   ```json
   // assets/translations/en.json
   {
     "title": "{{ cookiecutter.project_name }}",
     "todos": {
       "title": "Todos",
       "add_todo": "Add Todo",
       "edit_todo": "Edit Todo"
  }
}
```

2. Use in code:
```dart
   Text('todos.title'.tr()),           // "Todos"
   Text('todos.add_todo'.tr()),        // "Add Todo"
   ```

## 🔍 Logging & Debugging

Advanced logging with **Talker**:

### Features
- ✅ **Colored console output** (iTerm2 compatible)
- ✅ **HTTP request/response logging** (Dio integration)
- ✅ **BLoC state change logging**
- ✅ **Error tracking and reporting**
- ✅ **Performance monitoring**

### Usage
```dart
import 'core/utils/logger_config.dart';

// Log different levels
getIt<Talker>().debug('Debug message');
getIt<Talker>().info('Info message');
getIt<Talker>().warning('Warning message');
getIt<Talker>().error('Error message');

// Log HTTP requests (automatic with Dio)
// Log BLoC events (automatic with BLoC)
```

## 🎨 Native Splash Screens

Configured with **flutter_native_splash**:

### Configuration
```yaml
flutter_native_splash:
  color: "{{ cookiecutter.primary_color }}"
  image: assets/images/splash_icon.png
  color_dark: "{{ cookiecutter.primary_color_dark }}"
  image_dark: assets/images/splash_icon_dark.png
  
  android_12:
    image: assets/images/splash_icon.png
    color: "{{ cookiecutter.primary_color }}"
```

### Generate Splash Screens
```bash
flutter pub run flutter_native_splash:create
```

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/todo_bloc_test.dart
```

### Test Structure
```
test/
├── unit/                   # Unit tests
│   ├── blocs/             # BLoC tests
│   ├── repositories/      # Repository tests
│   └── utils/             # Utility tests
├── widget/                # Widget tests
├── integration/           # Integration tests
└── helpers/               # Test helpers
```

## 🔧 Code Generation

This project uses several code generation tools:

```bash
# Generate all code
flutter packages pub run build_runner build

# Clean and regenerate
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes (development)
flutter packages pub run build_runner watch
```

### Generated Files
- **Dependency Injection**: `injection.config.dart`
- **JSON Serialization**: `*.g.dart` files
- **API Clients**: `*_remote_datasource.g.dart`
- **Hive Adapters**: `*.g.dart` for models
- **Environment Config**: `env.g.dart`

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| 📱 **Android** | ✅ Supported | API 21+ |
| 🍎 **iOS** | ✅ Supported | iOS 12+ |
| 🌐 **Web** | ✅ Supported | Modern browsers |
| 🖥️ **macOS** | ✅ Supported | macOS 10.14+ |
| 🐧 **Linux** | ✅ Supported | Ubuntu 18.04+ |
| 🪟 **Windows** | ✅ Supported | Windows 10+ |

## 🚀 Adding New Features

### 1. Create Feature Structure
```bash
mkdir -p lib/presentation/new_feature/{bloc,pages,widgets}
```

### 2. Create Barrel Export
```dart
// lib/presentation/new_feature/new_feature.dart
export 'bloc/new_feature_bloc.dart';
export 'pages/new_feature_page.dart';
export 'widgets/new_feature_widget.dart';
```

### 3. Add to Router
```dart
import '../../presentation/new_feature/new_feature.dart';

GoRoute(
  path: '/new-feature',
  builder: (context, state) => const NewFeaturePage(),
),
```

### 4. Register Dependencies
```dart
@injectable
class NewFeatureBloc extends Bloc<NewFeatureEvent, NewFeatureState> {
  // Implementation
}
```

## 🔄 Development Workflow

### 1. **Environment Setup**
```bash
flutter pub get
flutter packages pub run build_runner build
```

### 2. **Feature Development**
- Create feature in `lib/presentation/feature_name/`
- Add BLoC, pages, and widgets
- Create barrel export
- Update routing and DI

### 3. **Code Generation**
```bash
flutter packages pub run build_runner build
```

### 4. **Testing**
```bash
flutter test
flutter analyze
```

### 5. **Build & Deploy**
```bash
flutter build apk --release          # Android
flutter build ios --release          # iOS
flutter build web --release          # Web
```

## 📊 Performance Optimization

### Bundle Size
- **Tree shaking** enabled for web builds
- **Code splitting** with lazy loading
- **Asset optimization** with compression

### Runtime Performance
- **BLoC pattern** for efficient state management
- **Hive** for fast local storage
- **Dio interceptors** for request caching
- **Image caching** with network images

## 🔐 Security Best Practices

- ✅ **Environment variables** for sensitive data
- ✅ **Certificate pinning** ready (Dio configuration)
- ✅ **Local storage encryption** (Hive configuration)
- ✅ **Input validation** with Formz
- ✅ **Error handling** without data leakage

## 🛠️ Troubleshooting

### Common Issues

#### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### iOS Build Issues
```bash
cd ios && pod install && cd ..
flutter clean && flutter pub get
```

#### Code Generation Issues
```bash
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Environment Issues
- Ensure `.env` file exists and is properly configured
- Check that all required environment variables are set
- Verify `envied` configuration in `pubspec.yaml`

## 📚 Learning Resources

### Architecture
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

### State Management
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Flutter Hooks Documentation](https://pub.dev/packages/flutter_hooks)

### Testing
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [BLoC Testing Guide](https://bloclibrary.dev/testing/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use provided linting rules (`analysis_options.yaml`)
- Ensure all tests pass before submitting PR

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **BLoC Library** for excellent state management
- **Community packages** that make development easier
- **Clean Architecture** principles by Robert C. Martin

---

Built with ❤️ using Flutter and Clean Architecture principles.

**Happy Coding!** 🚀