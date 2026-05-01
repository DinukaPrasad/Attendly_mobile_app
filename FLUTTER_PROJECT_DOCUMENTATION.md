# Attendly Mobile App - Complete Project Documentation

## 1. Project Overview

Attendly is an attendance management mobile application built with Flutter. It provides a platform for users to manage attendance records through login/registration, view attendance reports, manage members, and access settings. The application follows Clean Architecture principles with separation of concerns across data, domain, and presentation layers.

### Platform Targets
- **Android** (Primary, API level 16+)
- **iOS** (iOS 11+)
- **Web** (Browser-based)
- **Linux** (Desktop application)
- **macOS** (Desktop application)

### Tech Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | Latest (SDK ^3.10.4) | UI Framework |
| Dart | 3.10.4+ | Programming Language |
| HTTP | ^1.2.1 | Network requests |
| Cupertino Icons | ^1.0.8 | iOS-style icons |
| Material Design | 3 | UI Design System |
| Geolocator | ^11.0.0 | GPS location capture |
| Permission Handler | ^11.3.0 | Runtime permission requests |
| Local Auth | ^2.3.0 | Biometric / fingerprint authentication |

---

## 2. Project Structure

### Directory Tree with Descriptions

```
attendly_mobile_app/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── core/                              # Shared functionality & constants
│   │   ├── constants/
│   │   │   ├── api_constants.dart         # API base URLs, endpoints, timeout
│   │   │   ├── app_colors.dart            # Theme colors (primary, accent, text, etc.)
│   │   │   └── app_strings.dart           # String constants for UI labels
│   │   ├── network/
│   │   │   ├── api_client.dart            # HTTP client with interceptors & auth
│   │   │   └── api_exception.dart         # Custom API exception classes
│   │   ├── services/
│   │   │   ├── location_service.dart      # GPS location capture via geolocator
│   │   │   └── biometric_service.dart     # Fingerprint / FaceID via local_auth
│   │   └── utils/
│   │       └── validators.dart            # Form validation logic
│   │
│   ├── data/                              # Data layer (repository implementations)
│   │   ├── datasources/
│   │   │   └── auth_remote_datasource.dart # Remote API calls for auth
│   │   ├── models/
│   │   │   └── user_model.dart            # User model with JSON serialization
│   │   └── repositories/
│   │       └── auth_repository_impl.dart  # Implementation of auth repository
│   │
│   ├── domain/                            # Domain layer (business logic)
│   │   ├── entities/
│   │   │   └── user.dart                  # User entity (pure data object)
│   │   ├── repositories/
│   │   │   └── auth_repository.dart       # Abstract auth repository interface
│   │   └── usecases/
│   │       ├── login_usecase.dart         # Login business logic
│   │       └── register_usecase.dart      # Registration business logic
│   │
│   └── presentation/                      # Presentation layer (UI)
│       ├── screens/
│       │   ├── login/
│       │   │   └── login_screen.dart      # Login UI & state management
│       │   ├── register/
│       │   │   └── register_screen.dart   # Registration UI & state management
│       │   └── home/
│       │       └── home_screen.dart       # Dashboard with user info & quick actions
│       └── widgets/
│           ├── custom_button.dart         # Reusable elevated button component
│           └── custom_text_field.dart     # Reusable text input component
│
├── android/                               # Android native code & config
│   ├── app/
│   │   ├── build.gradle.kts               # Android build configuration
│   │   └── src/
│   │       ├── main/
│   │       │   └── AndroidManifest.xml    # Android app manifest
│   │       ├── debug/
│   │       │   └── AndroidManifest.xml
│   │       └── profile/
│   │           └── AndroidManifest.xml
│   └── gradle/
│       └── wrapper/                       # Gradle wrapper files
│
├── ios/                                   # iOS native code & config
│   ├── Runner/
│   │   ├── Info.plist                     # iOS app configuration
│   │   ├── AppDelegate.swift              # Swift app delegate
│   │   ├── GeneratedPluginRegistrant.h/m  # Auto-generated plugin registry
│   │   └── Assets.xcassets/               # App icons & images
│   ├── Runner.xcodeproj/                  # Xcode project file
│   └── Runner.xcworkspace/                # Xcode workspace
│
├── web/                                   # Web platform configuration
│   ├── index.html                         # Web entry point
│   ├── manifest.json                      # PWA manifest
│   └── icons/                             # Web app icons
│
├── linux/                                 # Linux desktop configuration
│   ├── CMakeLists.txt
│   ├── flutter/
│   └── runner/
│
├── macos/                                 # macOS desktop configuration
│   ├── Flutter/
│   ├── Runner/
│   └── RunnerTests/
│
├── test/                                  # Unit & widget tests
│   └── widget_test.dart
│
├── build/                                 # Build outputs (generated)
├── pubspec.yaml                           # Project dependencies & metadata
├── analysis_options.yaml                  # Dart linter configuration
└── README.md                              # Basic project info
```

### Architecture Layers Explanation

**Core Layer** - Shared functionality:
- `constants/`: Centralized configuration (colors, strings, API endpoints)
- `network/`: HTTP client with token management and error handling
- `services/`: Device capability abstractions (GPS location, biometric auth)
- `utils/`: Validation logic and helper functions

**Data Layer** - API & Repository implementation:
- `datasources/`: Direct API calls to backend
- `models/`: Data models with JSON serialization (extends domain entities)
- `repositories/`: Concrete repository implementations that use datasources

**Domain Layer** - Business logic (framework-independent):
- `entities/`: Pure Dart data classes (no framework dependencies)
- `repositories/`: Abstract interfaces defining data contracts
- `usecases/`: Encapsulated business logic (use cases execute via `call()` method)

**Presentation Layer** - UI & User Interaction:
- `screens/`: Full-page widgets with state management and navigation
- `widgets/`: Reusable UI components (buttons, text fields, etc.)

### State Management Approach

**No external state management library** — Uses `StatefulWidget` for local state management:
- Each screen (LoginScreen, RegisterScreen, HomeScreen) manages its own state
- Form validation, loading states, and error messages stored in `State` class
- Use cases instantiated directly in screens
- Navigation handled with `Navigator.push()` and `Navigator.pushReplacement()`

---

## 3. Dependencies & Tech Stack

### Dependency Classification

#### Core Flutter
| Package | Version | Purpose |
|---------|---------|---------|
| flutter | SDK | Flutter framework |
| flutter_test | SDK | Widget testing framework |

#### Networking
| Package | Version | Purpose |
|---------|---------|---------|
| http | ^1.2.1 | HTTP client for API requests |

#### Device & Sensors

| Package | Version | Purpose |
| ------- | ------- | ------- |
| geolocator | ^11.0.0 | GPS position capture with accuracy control |
| permission_handler | ^11.3.0 | Runtime permission requests (location, etc.) |
| local_auth | ^2.3.0 | Biometric authentication (fingerprint, Face ID) |

#### UI & Icons
| Package | Version | Purpose |
|---------|---------|---------|
| cupertino_icons | ^1.0.8 | iOS-style icons (CupertinoIcons) |

#### Development & Linting
| Package | Version | Purpose |
|---------|---------|---------|
| flutter_lints | ^6.0.0 | Recommended lint rules for Flutter projects |

### Current Dependency Status
- **Minimal dependencies** — Project relies on Flutter's built-in Material Design
- **No external state management** (Provider, Riverpod, GetX, Bloc)
- **No storage solutions** (SharedPreferences, Hive, SQLite)
- **No auth libraries** (Firebase Auth)
- **No UI libraries** (Lottie, CachedNetworkImage, FlutterToast)

---

## 4. Configuration

### pubspec.yaml Settings

```yaml
name: attendly_mobile_app
description: "A new Flutter project."
version: 1.0.0+1

environment:
  sdk: ^3.10.4

flutter:
  uses-material-design: true
```

- **App Name**: `attendly_mobile_app`
- **Version**: `1.0.0` (build number: `1`)
- **SDK Requirement**: Dart 3.10.4 or higher
- **Build System**: Modern Dart SDK required
- **Publish Status**: `publish_to: 'none'` (private package, not published to pub.dev)

### Android Configuration (AndroidManifest.xml)

**Location**: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application 
        android:label="attendly_mobile_app"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
        <!-- Cleartext traffic enabled for development API calls -->
    </application>
    <!-- Intent filter for text processing (Flutter standard) -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>
```

**Permissions declared**:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
```

| Permission | Purpose |
| --- | --- |
| `ACCESS_FINE_LOCATION` | Precise GPS coordinates for attendance |
| `ACCESS_COARSE_LOCATION` | Network-based location fallback |
| `USE_BIOMETRIC` | Biometric hardware access (Android 9+) |
| `USE_FINGERPRINT` | Legacy fingerprint API (Android 6–8) |

**Key Settings**:
- ✅ Cleartext traffic **enabled** (`usesCleartextTraffic="true"`) — allows HTTP (not HTTPS) connections
- Standard Flutter activity configuration
- Launcher activity set to MainActivity

**Security Note**: Cleartext traffic should be disabled in production and HTTPS should be used.

### iOS Configuration (Info.plist)

**Location**: `ios/Runner/Info.plist`

```plist
<key>CFBundleDisplayName</key>
<string>Attendly Mobile App</string>
<key>CFBundleShortVersionString</key>
<string>$(FLUTTER_BUILD_NAME)</string>
<key>CFBundleVersion</key>
<string>$(FLUTTER_BUILD_NUMBER)</string>
<key>LSRequiresIPhoneOS</key>
<true/>
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
```

**Permissions**: None declared currently (location and biometric permissions are Android-only; iOS Info.plist usage descriptions should be added before App Store submission)

**Supported Orientations**:
- Portrait (primary)
- Landscape Left
- Landscape Right

### API Configuration

**File**: `lib/core/constants/api_constants.dart`

```dart
class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.83.206.198:8080';
    }
    return 'http://localhost:8080';
  }

  static const Duration timeout = Duration(seconds: 30);

  // Endpoints
  static const String health = '/api/health';
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String markAttendance = '/api/attendance/mark';
}
```

**Base URLs by Platform**:
| Platform | URL | Purpose |
|----------|-----|---------|
| Android | `http://10.83.206.198:8080` | Development API server |
| iOS | `http://localhost:8080` | Local development server |
| Web | `http://localhost:8080` | Local development server |

**API Timeout**: 30 seconds

**Endpoints**:
- `/api/health` — Health check endpoint
- `/api/auth/login` — User login
- `/api/auth/register` — User registration
- `/api/attendance/mark` — Mark attendance (requires auth token, lat/lng/timestamp)

### Theme & Colors

**File**: `lib/core/constants/app_colors.dart`

```dart
Primary Color:        #6C63FF (Purple)
Primary Dark:         #4B44CC (Dark Purple)
Accent:               #03DAC6 (Teal)
Background:           #F5F5F5 (Light Gray)
Surface:              #FFFFFF (White)
Error:                #B00020 (Red)
Text Primary:         #1A1A2E (Dark Blue-Black)
Text Secondary:       #6E6E8A (Gray)
Text Hint:            #AAAAAA (Light Gray)
Input Border:         #E0E0E0 (Border Gray)
Input Focused:        #6C63FF (Purple - matches primary)
```

**Material 3 Theme**: Uses `ColorScheme.fromSeed()` with purple as primary color

### Analyzer Configuration

**File**: `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Default Flutter lint rules enabled
    # Can be customized per-project needs
```

- Includes recommended Flutter lints (`package:flutter_lints`)
- No custom linter rules overridden
- Follows Flutter best practices

---

## 5. App Architecture

### Architecture Pattern: **Clean Architecture**

The project implements **Clean Architecture** with three distinct layers:

```
┌─────────────────────────────────┐
│    Presentation Layer (UI)      │
│  ├─ Screens (StatefulWidget)    │
│  └─ Widgets (Reusable UI)       │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│    Domain Layer (Business)      │
│  ├─ Entities (Data Models)      │
│  ├─ Repositories (Interfaces)   │
│  └─ Use Cases (Business Logic)  │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│     Data Layer (API/DB)         │
│  ├─ Data Sources (Remote/Local) │
│  ├─ Models (JSON Mapping)       │
│  └─ Repositories (Implementation)│
└─────────────────────────────────┘
```

### Data Flow Architecture

```
User Input (UI) 
    ↓
Presentation Layer (Screen)
    ↓
Use Case (Business Logic)
    ↓
Domain Repository Interface
    ↓
Data Repository Implementation
    ↓
Remote Data Source (API Call)
    ↓
API Client (HTTP)
    ↓
Backend Server
    ↓
JSON Response
    ↓
UserModel (JSON Deserialization)
    ↓
User Entity
    ↓
Presentation Layer (Update UI)
```

### Layer-by-Layer Explanation

#### **Presentation Layer** (`lib/presentation/`)
- **Screens**: Full-page widgets that handle user interaction and display data
  - `LoginScreen`: User authentication with email/password form
  - `RegisterScreen`: New user registration with validation
  - `HomeScreen`: Dashboard showing user info and quick action buttons
- **Widgets**: Reusable UI components
  - `CustomButton`: Styled elevated button with loading state
  - `CustomTextField`: Styled text input with validation
- **State Management**: Uses `StatefulWidget` for local form state, loading states, and error messages
- **Navigation**: Manual navigation using `Navigator.push()` and `Navigator.pushReplacement()`

#### **Domain Layer** (`lib/domain/`)
- **Entities**: Pure data classes (framework-independent)
  - `User`: Contains id, name, email, and optional token
- **Repositories**: Abstract interfaces defining what data operations are available
  - `AuthRepository`: Defines `login()` and `register()` contracts
- **Use Cases**: Encapsulates specific business logic
  - `LoginUseCase`: Takes email/password, calls repository, returns User
  - `RegisterUseCase`: Takes name/email/password, calls repository, returns User
  - Use cases are invoked via `call()` method for clean syntax: `usecase(args)`

#### **Data Layer** (`lib/data/`)
- **Remote Data Sources**: Direct API calls
  - `AuthRemoteDataSource`: Calls `/api/auth/login` and `/api/auth/register`
- **Models**: Data transfer objects with JSON serialization
  - `UserModel`: Extends `User` entity, adds `fromJson()` and `toJson()` methods
- **Repositories**: Implements domain repository interfaces
  - `AuthRepositoryImpl`: Wraps `AuthRemoteDataSource`, provides implementation

#### **Core Layer** (`lib/core/`)
- **Constants**: Centralized configuration
  - `api_constants.dart`: Base URLs, endpoints, timeout
  - `app_colors.dart`: Theme colors
  - `app_strings.dart`: UI text strings
- **Network**: HTTP client and exception handling
  - `api_client.dart`: Centralized HTTP client with auth token management
  - `api_exception.dart`: Custom exception hierarchy
- **Utils**: Helper functions
  - `validators.dart`: Form field validation logic

---

## 6. Screens & Navigation

### Screen Inventory

| Screen Name | File Path | Route Name | Description | Entry Point |
|---|---|---|---|---|
| Login | `lib/presentation/screens/login/login_screen.dart` | N/A (Home) | User authentication with email/password. Has link to registration. | App default screen |
| Register | `lib/presentation/screens/register/register_screen.dart` | N/A | New user account creation with name/email/password validation. Has back button to login. | From LoginScreen link |
| Home | `lib/presentation/screens/home/home_screen.dart` | N/A | Dashboard showing user welcome card with name/email and quick action grid (Attendance, Reports, Members, Settings). Logout button in AppBar. | After successful login/register |

### Navigation Flow

```
┌─────────────────────┐
│   AttendlyApp       │
│   (MaterialApp)     │
└──────────┬──────────┘
           │
           ├─ home: LoginScreen (default entry point)
           │
           ▼
┌─────────────────────┐
│  LoginScreen        │
├─────────────────────┤
│ • Email/Password    │
│ • Login Button      │
│ • Sign Up Link ────────┐
│ • Error Display     │   │
└────────┬────────────┘   │
         │                │
    Login Success          │ Navigation.push()
         │                │
         │                ▼
         │         ┌──────────────────┐
         │         │ RegisterScreen   │
         │         ├──────────────────┤
         │         │ • Name Field     │
         │         │ • Email/Password │
         │         │ • Register Btn   │
         │         │ • Back Button ───────┐
         │         │ • Error Display  │   │
         │         └────────┬─────────┘   │
         │                  │             │
         │            Register Success    │ pop()
         │                  │             │
         ▼                  ▼             │
┌──────────────────────────────────┐     │
│ HomeScreen                       │     │
├──────────────────────────────────┤     │
│ • Welcome Card (User Info)       │     │
│ • Action Grid (4 quick actions)  │     │
│ • Logout Button (in AppBar) ─────┐    │
│                                  │    │
│  Logout: Navigator.pushAndRemoveUntil()
│  Returns to: LoginScreen         │    │
└──────────────────────────────────┘    │
                                        │
Back Link ──────────────────────────────┘
```

### Navigation Implementation

**Navigation Type**: **Navigator 1.0** (Manual Stack-based Navigation)

**Key Routes**:
1. **LoginScreen → RegisterScreen**: `Navigator.push(MaterialPageRoute(builder: (_) => RegisterScreen()))`
2. **LoginScreen → HomeScreen**: `Navigator.pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(user: user)))`
3. **RegisterScreen → LoginScreen**: `Navigator.pop(context)` (Back button)
4. **RegisterScreen → HomeScreen**: `Navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScreen(user: user)), (_) => false)`
5. **HomeScreen → LoginScreen**: `Navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => LoginScreen()), (_) => false)` (Logout)

**Routing Approach**: 
- No named routes defined
- No GoRouter, AutoRoute, or other routing packages
- Routes passed as data objects (e.g., `HomeScreen(user: user)`)
- Authentication state not persisted between sessions

**Deep Linking**: Not implemented

---

## 7. API Integration & Networking

### HTTP Client Architecture

**File**: `lib/core/network/api_client.dart`

The app uses a **centralized HTTP client** (`ApiClient`) class that wraps the standard `http` package:

```dart
class ApiClient {
  final http.Client _httpClient;
  String? _authToken;

  // Methods: get(), post(), put(), patch(), delete()
  // All methods handle:
  //   1. Request serialization
  //   2. Auth token attachment
  //   3. Response deserialization
  //   4. Error handling
  //   5. Timeout management
}
```

### Request/Response Cycle

```
User Action (Login)
    ↓
UseCase.call()
    ↓
Repository.login(email, password)
    ↓
RemoteDataSource.login()
    ↓
ApiClient.post('/api/auth/login', body: {...})
    ↓
HTTP Request Construction
  • URL: 'http://10.83.206.198:8080/api/auth/login'
  • Headers: 
    - Content-Type: application/json
    - Authorization: Bearer <token> (if logged in)
  • Body: JSON encoded {'email': '...', 'password': '...'}
    ↓
Send Request → Server Processing
    ↓
Receive Response (30s timeout)
    ↓
Status Code Check (200-299 = success)
    ↓
JSON Decode Response
    ↓
UserModel.fromJson(data)
    ↓
Return User Entity
    ↓
Update UI (Navigate to HomeScreen)
```

### API Endpoints & Methods

| HTTP Method | Endpoint | File/Function | Purpose | Auth Required | Request Body | Response |
|---|---|---|---|---|---|---|
| POST | `/api/auth/login` | `auth_remote_datasource.dart::login()` | User login | No | `{"email": "...", "password": "..."}` | `{"id": "...", "name": "...", "email": "...", "token": "..."}` |
| POST | `/api/auth/register` | `auth_remote_datasource.dart::register()` | User registration | No | `{"name": "...", "email": "...", "password": "..."}` | `{"id": "...", "name": "...", "email": "...", "token": "..."}` |
| GET | `/api/health` | Not implemented | Health check | No | None | Plain text response |
| POST | `/api/attendance/mark` | `home_screen.dart::_onMarkAttendance()` | Mark attendance with GPS | Yes | `{"latitude": 0.0, "longitude": 0.0, "timestamp": "ISO8601"}` | `{}` (success) |

### Request Headers

```dart
Map<String, String> get _headers => {
  'Content-Type': 'application/json',
  if (_authToken != null) 'Authorization': 'Bearer $_authToken',
};
```

**Headers Set**:
- `Content-Type: application/json` — Always sent
- `Authorization: Bearer <token>` — Only sent if `_authToken` is set (after login)

### Response Handling

**Success** (Status 200-299):
```dart
if (response.statusCode >= 200 && response.statusCode < 300) {
  if (response.body.isEmpty) return <String, dynamic>{};
  try {
    return jsonDecode(response.body); // Parse JSON or return as string
  } catch (_) {
    return response.body; // Return plain text if not JSON
  }
}
```

**Error** (Status 300+):
- **401 Unauthorized**: Throws `UnauthorizedException`
- **500+ Server Error**: Throws `ServerException`
- **Other Errors**: Throws generic `ApiException`

### Error Handling & Exception Hierarchy

**File**: `lib/core/network/api_exception.dart`

```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
}

class NetworkException extends ApiException { }
class TimeoutException extends ApiException { }
class UnauthorizedException extends ApiException { }
class ServerException extends ApiException { }
```

**Error Types**:
| Exception | When Thrown | Message | Status Code |
|---|---|---|---|
| `NetworkException` | Connection error, device offline | "Network error. Check your connection." | N/A |
| `TimeoutException` | Request exceeds 30s | "Request timed out." | N/A |
| `UnauthorizedException` | HTTP 401 response | From server or "Unauthorized. Please log in again." | 401 |
| `ServerException` | HTTP 500+ response | From server or "Server error. Try again later." | 500+ |
| `ApiException` | HTTP 300-499 (except 401) | From server response body | Actual status code |

**Error Handling in UI**:
```dart
try {
  final User user = await _loginUseCase(email: email, password: password);
  Navigator.pushReplacement(...);
} catch (e) {
  setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
}
```

### Auth Token Management

**Storing Token**:
```dart
// After successful login
_apiClient.setAuthToken(user.token);
```

**Using Token**:
```dart
// Automatically added to all subsequent requests
'Authorization': 'Bearer $token'
```

**Clearing Token**:
```dart
// On logout
_apiClient.clearAuthToken();
```

**Current Implementation Status**: Token stored only in memory (lost on app restart)

### API Client Configuration

| Setting | Value | Purpose |
|---------|-------|---------|
| HTTP Client | `http.Client()` | Standard Dart HTTP library |
| Timeout | 30 seconds | Maximum wait time for response |
| Base URL | Dynamic (per platform) | Configurable for development/production |
| Content Type | application/json | JSON request/response bodies |

### Interceptors

**None currently implemented** — Could be added for:
- Request/response logging
- Automatic token refresh
- Request retries
- Rate limiting

---

## 8. Authentication Flow

### Authentication Mechanism: **JWT Token-Based**

The app uses JWT (JSON Web Tokens) for API authentication. After login/register, the backend returns a token that must be sent with subsequent requests.

### Login Flow

**Step-by-step**:

1. **User enters credentials** on LoginScreen
   - Email validation: Must match regex pattern
   - Password validation: Minimum 6 characters

2. **Form validation** on submit
   - Both fields required and valid
   - If invalid, show validation errors and prevent submission

3. **ShowLoading state**
   - Button shows spinner, becomes disabled
   - User input remains editable (can fix errors)

4. **Call LoginUseCase**
   ```dart
   final User user = await _loginUseCase(
     email: _emailController.text.trim(),
     password: _passwordController.text,
   );
   ```

5. **UseCase execution**
   - Calls `AuthRepository.login(email, password)`
   - Repository calls `AuthRemoteDataSource.login()`
   - DataSource makes POST request to `/api/auth/login`

6. **API Request**
   ```json
   POST http://10.83.206.198:8080/api/auth/login
   Content-Type: application/json

   {
     "email": "user@example.com",
     "password": "password123"
   }
   ```

7. **Parse response**
   - Server returns User object with JWT token
   ```json
   {
     "id": "12345",
     "name": "John Doe",
     "email": "user@example.com",
     "token": "eyJhbGciOiJIUzI1NiIs..."
   }
   ```

8. **Store token** in ApiClient
   ```dart
   _apiClient.setAuthToken(user.token);
   ```

9. **Navigate to HomeScreen**
   ```dart
   Navigator.pushReplacement(
     context,
     MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
   );
   ```

10. **Handle errors**
    - Server returns 401 or validation error → Show error banner
    - Network error → Show connection error
    - Timeout → Show timeout message

### Registration Flow

**Similar to login, with differences**:

1. **Collect additional data**: Name field required
2. **Password confirmation**: Password fields must match
3. **Validation**:
   - Name: Required, not empty
   - Email: Required, valid format
   - Password: Required, minimum 6 chars
   - Confirm: Must match password

4. **Call RegisterUseCase**
   ```dart
   final User user = await _registerUseCase(
     name: _nameController.text.trim(),
     email: _emailController.text.trim(),
     password: _passwordController.text,
   );
   ```

5. **API Request**
   ```json
   POST http://10.83.206.198:8080/api/auth/register
   Content-Type: application/json

   {
     "name": "John Doe",
     "email": "user@example.com",
     "password": "password123"
   }
   ```

6. **Navigate to HomeScreen** (replaces entire stack with pushAndRemoveUntil)
   ```dart
   Navigator.pushAndRemoveUntil(
     context,
     MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
     (_) => false, // Remove all previous routes
   );
   ```

### Logout Flow

1. **User taps logout** button in HomeScreen AppBar
2. **Confirmation dialog** shown: "Are you sure you want to logout?"
3. **On confirm**:
   - Clear auth token from ApiClient
   - Navigate back to LoginScreen
   - Remove all previous routes from stack

```dart
_apiClient.clearAuthToken(); // Clear in-memory token

Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const LoginScreen()),
  (_) => false, // Replace entire stack
);
```

4. **User returns to login screen**, must authenticate again

### Token Storage

**Current Implementation**:
- Token stored **only in memory** as `String? _authToken` in `ApiClient`
- Token **lost on app restart** or when app is killed
- **Not persisted** to device storage (SharedPreferences, Secure Storage, etc.)

**Limitations**:
- ❌ User cannot access app after restart
- ❌ No persistent login sessions
- ❌ No automatic token refresh mechanism

**Improvements Needed**:
- Use `flutter_secure_storage` for secure token storage
- Implement token refresh logic (check expiration, auto-refresh if expired)
- Use SharedPreferences for non-sensitive data

### Token Refresh Logic

**Not implemented** — Would need:
1. Check token expiration time
2. If expired and refresh token available, get new token
3. If refresh token expired, force re-login
4. Automatically attach new token to subsequent requests

### Role-Based Access & Conditional Navigation

**Not implemented** — All authenticated users go to HomeScreen directly
- No role checking
- No conditional screens based on user type
- No permission validation

---

## 9. Device Features Used

**Current Status**: ✅ **GPS location and biometric authentication implemented**

| Feature | Current | Package |
|---------|---------|---------|
| Camera | Not used | `image_picker`, `camera` — for photo capture/upload |
| GPS / Location | ✅ Implemented | `geolocator` ^11.0.0 — high-accuracy position for attendance |
| Biometrics | ✅ Implemented | `local_auth` ^2.3.0 — fingerprint / Face ID before marking attendance |
| Push Notifications | Not used | `firebase_messaging`, `flutter_local_notifications` — for alerts |
| Bluetooth / NFC | Not used | Not applicable for attendance app |
| File System | Not used | `path_provider`, `file_picker` — for document management |
| Sensors | Not used | Gyroscope, accelerometer — not needed |

### LocationService (`lib/core/services/location_service.dart`)

```dart
class LocationService {
  static Future<Position?> getCurrentLocation() async {
    // 1. Check if device location services are enabled
    // 2. Request location permission via permission_handler
    // 3. Return Position using desiredAccuracy: LocationAccuracy.high
    // Returns null if services disabled or permission denied
  }
}
```

**Accuracy setting**: `LocationAccuracy.high` — passed via the `desiredAccuracy` named parameter (compatible with geolocator ^11 on the target SDK).

**Returns**: `Position?` — null on any failure; callers must handle null before consuming coordinates.

### BiometricService (`lib/core/services/biometric_service.dart`)

```dart
class BiometricService {
  static Future<bool> isBiometricAvailable() async {
    // Checks canCheckBiometrics AND isDeviceSupported — both must be true
  }

  static Future<bool> authenticate() async {
    // Triggers system biometric prompt
    // biometricOnly: true  — password fallback disabled
    // stickyAuth: true     — prompt persists if app is backgrounded
    // Returns false on any exception (never throws)
  }
}
```

**Reason string**: `"Please verify your identity to mark attendance"`

### Permissions Required

**Android** (`android/app/src/main/AndroidManifest.xml`):

| Permission | API Level | Purpose |
| --- | --- | --- |
| `ACCESS_FINE_LOCATION` | All | Precise GPS for attendance coordinates |
| `ACCESS_COARSE_LOCATION` | All | Network-based location fallback |
| `USE_BIOMETRIC` | 28+ (Android 9+) | Biometric hardware access |
| `USE_FINGERPRINT` | 23–27 (Android 6–8) | Legacy fingerprint API |

**iOS**: `NSLocationWhenInUseUsageDescription` and `NSFaceIDUsageDescription` keys must be added to `Info.plist` before App Store submission.

---

## 10. Local Storage & State

### Current Implementation: **Minimal (In-Memory Only)**

| Data | Storage | Persistence | Scope |
|------|---------|-------------|-------|
| User Object | Memory | Until app restart | HomeScreen widget |
| Auth Token | Memory (ApiClient) | Until app restart | Subsequent API requests |
| Form Input | Memory (TextEditingController) | Until screen disposed | Current screen only |
| Loading State | Memory (StatefulWidget) | Real-time | Current screen only |
| Error Messages | Memory (StatefulWidget) | Real-time | Current screen only |

### State Management Breakdown

**Presentation State** (UI state):
```dart
// In each screen's State class:
bool _isLoading = false;           // Loading indicator
String? _errorMessage;             // Error banner
TextEditingController controller;  // Form input

// All cleared when screen disposed:
@override void dispose() {
  controller.dispose();
  super.dispose();
}
```

**Application State** (Shared across screens):
```dart
// In ApiClient:
String? _authToken; // Cleared on logout

// In HomeScreen:
final User user;    // Passed as constructor parameter
```

**What's Fetched Fresh**:
- User data on login/register (from API)
- No caching of API responses
- Every screen reconstructed when navigated to

### Offline Support

**Not implemented** — App requires internet connection:
- ❌ No local database
- ❌ No offline queue
- ❌ No sync mechanism
- ❌ If server unavailable → shows network error

**To implement**:
1. Use `Hive` or `SQLite` for local storage
2. Implement retry logic with exponential backoff
3. Cache API responses
4. Sync when connection restored

### Local Storage Options That Could Be Used

| Solution | Use Case |
|----------|----------|
| `SharedPreferences` | Simple key-value (user ID, last login time) |
| `flutter_secure_storage` | Sensitive data (JWT token, passwords) |
| `Hive` | Fast, local database (attendance records, user cache) |
| `SQLite` (sqflite) | Structured data with relations |
| `File System` | Document storage, file uploads |

---

## 11. UI & Theming

### Theme Configuration

**Theme Setup** in `main.dart`:
```dart
MaterialApp(
  title: 'Attendly',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
  ),
  home: const LoginScreen(),
)
```

**Color Palette** (`app_colors.dart`):

```
Primary Colors:
  • Primary:       #6C63FF (Purple - Main accent)
  • Primary Dark:  #4B44CC (Darker purple - Gradient)
  • Accent:        #03DAC6 (Teal - Secondary highlight)

Background & Surfaces:
  • Background:    #F5F5F5 (Light gray - Page background)
  • Surface:       #FFFFFF (White - Cards, inputs)
  • Error:         #B00020 (Red - Error messages)

Text Colors:
  • Text Primary:  #1A1A2E (Very dark blue - Primary text)
  • Text Secondary:#6E6E8A (Gray - Secondary text, labels)
  • Text Hint:     #AAAAAA (Light gray - Placeholder text)

Input Styling:
  • Input Border:  #E0E0E0 (Border color when unfocused)
  • Input Focused: #6C63FF (Purple - Matches primary)
```

**Design System**: Material Design 3 (`useMaterial3: true`)
- Rounded corners (12-16px)
- Shadows for depth
- Color-coded icons
- Consistent spacing

### Custom Widgets

**1. CustomButton** (`lib/presentation/widgets/custom_button.dart`)

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
}
```

**Features**:
- Full-width elevated button
- Rounded corners (12px radius)
- Displays spinner when loading
- Disabled state when loading
- Customizable label text

**Used In**:
- LoginScreen: "Login" button
- RegisterScreen: "Register" button

**2. CustomTextField** (`lib/presentation/widgets/custom_text_field.dart`)

```dart
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
}
```

**Features**:
- Outlined text field with rounded corners (12px)
- Label text with color scheme
- Prefix/suffix icons (for email, lock, visibility toggle)
- Validation error display
- Focus border color change
- Support for password masking

**Used In**:
- LoginScreen: Email field, Password field
- RegisterScreen: Name field, Email field, Password field, Confirm Password field

### Key UI Components & Patterns

#### **LoginScreen UI Structure**:
```
SafeArea
├── SingleChildScrollView
│   └── Column
│       ├── Header (Icon + Title + Subtitle)
│       ├── Error Banner (conditional)
│       ├── Email TextField
│       ├── Password TextField (with visibility toggle)
│       ├── Login Button
│       └── Sign Up Link Row
```

#### **RegisterScreen UI Structure**:
```
SafeArea
├── SingleChildScrollView
│   └── Column
│       ├── Back Button
│       ├── Header (Icon + Title + Subtitle)
│       ├── Error Banner (conditional)
│       ├── Name TextField
│       ├── Email TextField
│       ├── Password TextField (with visibility toggle)
│       ├── Confirm Password TextField (with visibility toggle)
│       ├── Register Button
│       └── Sign In Link Row
```

#### **HomeScreen UI Structure**:
```
Scaffold
├── AppBar (with Logout button)
└── SafeArea
    └── Padding
        └── Column
            ├── Welcome Card
            │   ├── Avatar (user initials)
            │   ├── Welcome Text
            │   └── User Info (name, email)
            └── Quick Actions Grid
                ├── Attendance Card
                ├── Reports Card
                ├── Members Card
                └── Settings Card
```

### Screen-Specific Styling

#### **LoginScreen Colors**:
- Background: Light gray (#F5F5F5)
- Text: Dark blue (#1A1A2E)
- Labels: Gray (#6E6E8A)
- Icons: Gray (#6E6E8A)
- Button: Purple (#6C63FF)
- Error: Red (#B00020)

#### **HomeScreen Colors**:
- AppBar: Purple (#6C63FF)
- Welcome Card: Gradient (Purple → Dark Purple)
- Action Cards: Color-coded (Green, Blue, Orange, Purple)
- Text: Dark blue (#1A1A2E)

### Dark Mode Support

**Not implemented** — App uses only light theme
- No dark color variants
- No `ThemeData.dark()`
- No theme switcher UI

---

## 12. Key Business Logic

### Core Use Cases

#### **1. LoginUseCase** (`lib/domain/usecases/login_usecase.dart`)

```dart
class LoginUseCase {
  final AuthRepository repository;

  Future<User> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
```

**Purpose**: Authenticate user with email/password
**Input**: Email, Password (strings)
**Output**: User object (with ID, name, email, token)
**Errors**: Throws ApiException (401, validation errors, network errors)
**Flow**: Validates credentials → Calls backend → Returns authenticated User

#### **2. RegisterUseCase** (`lib/domain/usecases/register_usecase.dart`)

```dart
class RegisterUseCase {
  final AuthRepository repository;

  Future<User> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.register(name: name, email: email, password: password);
  }
}
```

**Purpose**: Create new user account
**Input**: Name, Email, Password (strings)
**Output**: User object (with ID, name, email, token)
**Errors**: Throws ApiException (account exists, validation errors, network errors)
**Flow**: Validates input → Calls backend → Returns new User with token

### Form Validation Logic

**File**: `lib/core/utils/validators.dart`

| Validator | Input | Returns | Error Message |
|-----------|-------|---------|---|
| `Validators.name()` | Full name | null if valid | "Name is required" |
| `Validators.email()` | Email address | null if valid | "Email is required" OR "Enter a valid email address" |
| `Validators.password()` | Password | null if valid | "Password is required" OR "Password must be at least 6 characters" |
| `Validators.confirmPassword()` | Password + Confirm | null if valid | (from password) OR "Passwords do not match" |

**Email Regex Pattern**:
```regex
^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$
```
Matches: `user@example.com`, `john.doe+tag@company.co.uk`

**Validation Integration**:
```dart
TextFormField(
  validator: Validators.email, // Called on form validation
  // Shows error message below field if validation returns non-null string
)
```

### API Response Mapping

**Mapping Flow**:
```
JSON Response (from server)
    ↓
UserModel.fromJson(jsonData)
    ↓
User Entity (domain layer)
    ↓
Display in HomeScreen
```

**Example**:
```json
{
  "id": "12345",
  "name": "John Doe",
  "email": "john@example.com",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

Becomes:
```dart
User(
  id: "12345",
  name: "John Doe",
  email: "john@example.com",
  token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
)
```

### User Entity

```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? token;
}
```

**Properties**:
- `id`: Unique user identifier
- `name`: Full name
- `email`: Email address (used for login)
- `token`: JWT authentication token (nullable, not always present)

---

## 13. Limitations & Known Issues

### Hardcoded Values

| Location | Value | Issue | Fix |
|----------|-------|-------|-----|
| `api_constants.dart` | Android API IP: `10.83.206.198:8080` | Hardcoded dev IP, not portable | Use environment variables or config file |
| `api_constants.dart` | Timeout: 30 seconds | Fixed for all requests | Allow per-request timeout override |
| HomeScreen | Quick action items (4 items) | Hardcoded inline in code | Move to data model/repository |
| HomeScreen | Action card colors | Hardcoded hex values | Centralize in app_colors.dart |

### Platform-Specific Limitations

| Platform | Limitation | Reason |
|----------|-----------|--------|
| All | No offline support | No local database |
| All | No persistent login | Token only in memory |
| All | Cleartext traffic enabled | Security risk in production |
| iOS | No notification support | Firebase setup required |
| Android | No notification support | Firebase setup required |
| Web | Unclear base URL on web | May need separate backend |
| Linux/macOS | No dedicated UI | Uses same mobile UI |

### Known Incomplete Features

| Feature | Status | Notes |
|---------|--------|-------|
| Attendance Tracking | ✅ Implemented | Biometric → GPS → POST `/api/attendance/mark` |
| Reports | Placeholder only | "Reports" quick action does nothing |
| Members Management | Placeholder only | "Members" quick action does nothing |
| Settings | Placeholder only | "Settings" quick action does nothing |
| User Profile | Not implemented | No profile screen |
| Password Reset | Not implemented | No forgot password flow |
| Profile Update | Not implemented | User cannot change details |
| Account Deletion | Not implemented | No delete account option |
| Multi-language | Not implemented | Only English strings |
| Push Notifications | Not implemented | No notification system |

### TODO Comments Found in Code

**Android Build Configuration** (`android/app/build.gradle.kts`):
```
// TODO: Specify your own unique Application ID
// TODO: Add your own signing config for the release build
```

**Linux Build** (`linux/flutter/CMakeLists.txt`):
```
# TODO: Move the rest of this into files in ephemeral
```

### Architecture/Design Debt

1. **No state management framework** — StatefulWidget works but doesn't scale
   - Would benefit from Provider, Riverpod, or Bloc for complex features

2. **No dependency injection** — Hard-coded instantiation
   ```dart
   late final LoginUseCase _loginUseCase = LoginUseCase(
     AuthRepositoryImpl(AuthRemoteDataSource()),
   );
   ```
   Could use GetIt, Provider, or Riverpod for DI

3. **No logging/monitoring** — No visibility into app behavior
   - Should add Sentry, Firebase Analytics, or similar

4. **No error recovery** — Network failures show raw error strings
   - Need user-friendly error messages and retry mechanisms

5. **No loading skeleton** — Content pops in abruptly
   - Should add skeleton loaders or progress indicators

6. **Navigation is fragile** — Manual route management
   - No automatic deep linking
   - No route guards or middleware

### Security Issues

1. **Cleartext traffic enabled** in Android for development
   ```xml
   android:usesCleartextTraffic="true"
   ```
   ❌ Must disable in production, use HTTPS only

2. **Token stored in memory** — Lost on app restart
   - Should use `flutter_secure_storage` for persistent storage

3. **No certificate pinning** — Vulnerable to MITM attacks
   - Should implement SSL certificate pinning

4. **Credentials visible in code**
   - Hardcoded API IP address should be in secure config
   - Should use environment variables or secure configuration

5. **No input sanitization** — Form fields not validated server-side
   - Backend should validate all inputs

---

## 14. Summary

### Project Maturity: **Early-Stage Prototype**

The Attendly Mobile App is a minimal, well-structured Flutter application following Clean Architecture principles. It demonstrates solid foundational practices (layered architecture, separation of concerns, custom widgets) but lacks production-ready features (persistent storage, state management, offline support, error recovery).

### Strengths
✅ Clean Architecture with clear layer separation  
✅ Centralized API client with proper error handling  
✅ Form validation and error display  
✅ Reusable custom widgets (Button, TextField)  
✅ Type-safe data models with JSON serialization  
✅ Cross-platform support (Android, iOS, Web, Desktop)  
✅ Proper use case pattern for business logic  
✅ GPS location capture with permission handling  
✅ Biometric authentication (fingerprint / Face ID) before marking attendance  
✅ Mark attendance flow: biometric → GPS → authenticated API call  

### Weaknesses
❌ No persistent authentication (token lost on restart)  
❌ In-memory only state (no database)  
❌ Hardcoded API IP for Android  
❌ Reports, Members, Settings quick actions still placeholder  
❌ Manual route navigation (fragile, not scalable)  
❌ No state management framework  
❌ No error recovery or retry logic  
❌ Cleartext traffic enabled (security risk)  
❌ No logging or crash reporting  
❌ Missing notification system  
❌ iOS Info.plist location/Face ID usage descriptions not yet added  

### Next Steps for Production Readiness
1. **Add persistent authentication** → `flutter_secure_storage` for token
2. **Implement state management** → Provider or Riverpod
3. **Add local database** → Hive or SQLite for offline support
4. **Complete feature screens** → Attendance, Reports, Members, Settings
5. **Add error handling** → Retry logic, offline queue, user-friendly errors
6. **Improve security** → HTTPS only, certificate pinning, disable cleartext
7. **Add testing** → Unit tests, widget tests, integration tests
8. **Setup CI/CD** → Automated builds, testing, deployment
9. **Add monitoring** → Sentry, Firebase Analytics, Crashlytics
10. **Implement deep linking** → Use GoRouter or similar routing package

---

## Appendix: File Reference Guide

### Core Application Files
- [main.dart](main.dart) — App entry point, MaterialApp setup
- [pubspec.yaml](pubspec.yaml) — Dependencies and project metadata

### Constants & Configuration
- [lib/core/constants/api_constants.dart](lib/core/constants/api_constants.dart) — API endpoints, base URLs
- [lib/core/constants/app_colors.dart](lib/core/constants/app_colors.dart) — Color palette
- [lib/core/constants/app_strings.dart](lib/core/constants/app_strings.dart) — UI text strings

### Network Layer
- [lib/core/network/api_client.dart](lib/core/network/api_client.dart) — HTTP client implementation
- [lib/core/network/api_exception.dart](lib/core/network/api_exception.dart) — Exception hierarchy

### Services

- [lib/core/services/location_service.dart](lib/core/services/location_service.dart) — GPS capture (`desiredAccuracy: LocationAccuracy.high`)
- [lib/core/services/biometric_service.dart](lib/core/services/biometric_service.dart) — Biometric availability check and authentication prompt

### Utilities
- [lib/core/utils/validators.dart](lib/core/utils/validators.dart) — Form field validation

### Presentation Layer - Screens
- [lib/presentation/screens/login/login_screen.dart](lib/presentation/screens/login/login_screen.dart) — Login screen
- [lib/presentation/screens/register/register_screen.dart](lib/presentation/screens/register/register_screen.dart) — Registration screen
- [lib/presentation/screens/home/home_screen.dart](lib/presentation/screens/home/home_screen.dart) — Dashboard screen

### Presentation Layer - Widgets
- [lib/presentation/widgets/custom_button.dart](lib/presentation/widgets/custom_button.dart) — Reusable button
- [lib/presentation/widgets/custom_text_field.dart](lib/presentation/widgets/custom_text_field.dart) — Reusable text field

### Data Layer - Datasources
- [lib/data/datasources/auth_remote_datasource.dart](lib/data/datasources/auth_remote_datasource.dart) — API calls

### Data Layer - Models
- [lib/data/models/user_model.dart](lib/data/models/user_model.dart) — User data model with JSON mapping

### Data Layer - Repositories
- [lib/data/repositories/auth_repository_impl.dart](lib/data/repositories/auth_repository_impl.dart) — Repository implementation

### Domain Layer - Entities
- [lib/domain/entities/user.dart](lib/domain/entities/user.dart) — User entity

### Domain Layer - Repositories
- [lib/domain/repositories/auth_repository.dart](lib/domain/repositories/auth_repository.dart) — Repository interface

### Domain Layer - Usecases
- [lib/domain/usecases/login_usecase.dart](lib/domain/usecases/login_usecase.dart) — Login business logic
- [lib/domain/usecases/register_usecase.dart](lib/domain/usecases/register_usecase.dart) — Registration business logic

### Platform Configuration
- [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml) — Android manifest
- [ios/Runner/Info.plist](ios/Runner/Info.plist) — iOS configuration
- [web/index.html](web/index.html) — Web entry point

---

**Documentation Generated**: April 29, 2026  
**Attendly Mobile App** — Version 1.0.0
