# Attendly – Mobile Application

Attendly is a Flutter-based mobile application for university attendance tracking with anti-cheating features.
The app uses **Clean Architecture** with **Feature-First** organization and **BLoC** for state management.

This project is developed as part of a **BSc (Hons) Software Engineering Final Year Project** at **Cardiff Metropolitan University**.

---

## 🚀 Key Features

### Student
- Secure login with email/password and Google Sign-In
- QR code scanning for attendance check-in
- Attendance history with status tracking
- Profile management
- Customizable app settings

### Lecturer (Planned)
- Start attendance sessions with QR codes
- Monitor real-time attendance responses
- Timetable and module views

### University Management (Planned)
- Manage modules, timetables, lecturers
- Attendance analytics and reports

### Admin (Planned)
- University and system configuration
- User and role management

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.9.2 (Dart ^3.9.2) |
| Architecture | **Clean Architecture** (Feature-First) |
| State Management | **flutter_bloc** ^9.1.0 |
| Dependency Injection | **get_it** ^8.0.3 |
| Networking | `http` package |
| Firebase | `firebase_core`, `firebase_auth` |
| Google Sign-In | `google_sign_in` ^7.2.0 |
| Local Storage | `shared_preferences`, `flutter_secure_storage` |
| UI Components | `getwidget`, `calendar_view`, `fl_chart` |

---

## 🧱 Architecture Overview

The application follows **Clean Architecture** principles with a **Feature-First** folder structure:

### Layers

1. **Domain Layer** (innermost)
   - Entities: Pure Dart classes representing business objects
   - Repositories: Abstract interfaces defining data contracts
   - Use Cases: Single-responsibility business logic operations

2. **Data Layer**
   - Models: Data transfer objects with JSON serialization
   - Data Sources: Remote (API) and local (cache) implementations
   - Repository Implementations: Concrete implementations of domain interfaces

3. **Presentation Layer** (outermost)
   - BLoCs: State management using events and states
   - Pages/Screens: UI components
   - Widgets: Reusable UI elements

### Key Patterns

- **Result\<T\>** sealed class for type-safe error handling (no exceptions in business logic)
- **UseCase** base classes for consistent use case implementation
- **Barrel exports** for clean imports
- **Dependency Injection** for testability and loose coupling

---

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── app/
│   └── app.dart                 # MaterialApp configuration
│
├── core/                        # Shared infrastructure
│   ├── constants/               # App-wide constants
│   ├── di/                      # Dependency injection container
│   ├── errors/                  # Exception and Failure classes
│   ├── network/                 # HTTP client configuration
│   ├── routing/                 # App router and routes
│   ├── theme/                   # App theme definitions
│   ├── usecases/                # UseCase base classes
│   ├── utils/                   # Result<T>, helpers
│   └── widgets/                 # Shared widgets
│
└── features/                    # Feature modules
    ├── auth/                    # Authentication feature
    │   ├── data/
    │   │   ├── datasources/     # Firebase auth service
    │   │   ├── models/          # AuthUserModel
    │   │   └── repositories/    # AuthRepositoryImpl
    │   ├── domain/
    │   │   ├── entities/        # AuthUser
    │   │   ├── repositories/    # AuthRepository interface
    │   │   └── usecases/        # SignIn, SignUp, SignOut
    │   ├── presentation/
    │   │   ├── bloc/            # LoginBloc, RegisterBloc
    │   │   └── pages/           # LoginScreen, RegisterScreen
    │   └── injection.dart       # Feature DI registration
    │
    ├── profile/                 # User profile feature
    │   ├── data/
    │   ├── domain/
    │   ├── presentation/
    │   └── injection.dart
    │
    ├── attendance/              # Attendance tracking feature
    │   ├── data/
    │   │   ├── datasources/     # Remote API calls
    │   │   ├── models/          # AttendanceModel, SessionModel
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/        # Attendance, AttendanceSession
    │   │   ├── repositories/
    │   │   └── usecases/        # SubmitAttendance, ValidateQR, etc.
    │   ├── presentation/
    │   │   ├── bloc/            # ScanBloc, HistoryBloc
    │   │   └── pages/           # ScanScreen, ConfirmScreen, HistoryScreen
    │   └── injection.dart
    │
    └── settings/                # App settings feature
        ├── data/
        │   ├── datasources/     # SharedPreferences storage
        │   ├── models/          # AppSettingsModel
        │   └── repositories/
        ├── domain/
        │   ├── entities/        # AppSettings, AppThemeMode
        │   ├── repositories/
        │   └── usecases/        # GetSettings, UpdateTheme, Toggles
        ├── presentation/
        │   ├── bloc/            # SettingsBloc
        │   └── pages/           # SettingsScreen
        └── injection.dart
```

---

## 🔐 Security Considerations

- **Firebase Authentication** for secure user management
- **Secure token storage** using flutter_secure_storage
- **Result pattern** prevents exception leaks across layers
- **Planned**: Device binding and location-based anti-cheating measures
- **Planned**: Server-side attendance validation

---

## ▶️ Running the App Locally

```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build for release
flutter build apk --release
```

### Prerequisites

- Flutter SDK 3.9.2+
- Dart SDK 3.9.2+
- Firebase project configured (google-services.json for Android)
- Android Studio / VS Code with Flutter extensions

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 📌 Project Status

🔧 **In active development** (Final Year Project – 2026)

### Completed
- ✅ Clean Architecture migration
- ✅ Auth feature (Email/Password, Google Sign-In)
- ✅ Profile feature
- ✅ Attendance feature (QR scanning, history)
- ✅ Settings feature (theme, notifications, privacy)

### Planned
- 📋 Camera integration for QR scanning
- 📋 Location verification for attendance
- 📋 Push notifications
- 📋 Lecturer dashboard
- 📋 Admin panel

---

## 👨‍🎓 Author

**A.G. Dinuka Prasad Premarathna**  
BSc (Hons) Software Engineering  
Cardiff Metropolitan University

---

## 📄 License

This project is developed for **academic purposes only**.
