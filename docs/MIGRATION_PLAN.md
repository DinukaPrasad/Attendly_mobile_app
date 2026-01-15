# 📋 Attendly Clean Architecture Migration Plan

## 🎯 Target Clean Architecture Structure

```
lib/
├── main.dart                           # Entry point (Firebase + DI init)
├── app.dart                            # MaterialApp configuration
│
├── core/                               # Shared/Cross-cutting concerns
│   ├── core.dart                       # Barrel export
│   ├── constants/
│   │   └── constants.dart              # ApiConstants, StorageKeys, etc.
│   ├── di/
│   │   └── injection_container.dart    # GetIt setup
│   ├── errors/
│   │   ├── exceptions.dart             # AppException hierarchy
│   │   └── failures.dart               # Failure hierarchy
│   ├── network/
│   │   └── api_client.dart             # HTTP client with JWT
│   ├── routing/
│   │   └── app_router.dart             # All route definitions
│   ├── theme/
│   │   └── app_theme.dart              # ThemeData definitions
│   ├── usecases/
│   │   └── usecase.dart                # Base usecase classes
│   ├── utils/
│   │   ├── result.dart                 # Result<T> sealed class
│   │   └── helpers.dart                # Shared utility functions
│   └── widgets/                        # Shared reusable widgets
│       ├── app_button.dart
│       ├── app_dialog.dart
│       ├── app_loader.dart
│       └── app_textfield.dart
│
├── features/
│   ├── auth/                           # ✅ DONE
│   │   ├── injection.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── auth_user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── auth_user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_email_password.dart
│   │   │       └── sign_in_with_google.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── login_bloc.dart
│   │       │   ├── login_event.dart
│   │       │   ├── login_state.dart
│   │       │   ├── register_bloc.dart
│   │       │   ├── register_event.dart
│   │       │   └── register_state.dart
│   │       └── pages/
│   │           ├── login_screen.dart
│   │           └── register_screen.dart
│   │
│   ├── attendance/                     # 🔄 TO CREATE
│   │   ├── injection.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── attendance_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── attendance_model.dart
│   │   │   └── repositories/
│   │   │       └── attendance_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── attendance.dart
│   │   │   ├── repositories/
│   │   │   │   └── attendance_repository.dart
│   │   │   └── usecases/
│   │   │       ├── submit_attendance.dart
│   │   │       └── get_attendance_history.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── scan_bloc.dart
│   │       │   └── history_bloc.dart
│   │       └── pages/
│   │           ├── scan_screen.dart
│   │           ├── confirm_screen.dart
│   │           └── history_screen.dart
│   │
│   ├── profile/                        # 🔄 TO CREATE
│   │   ├── injection.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── profile_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── student_model.dart
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── student.dart
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_profile.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── profile_bloc.dart
│   │       │   ├── profile_event.dart
│   │       │   └── profile_state.dart
│   │       └── pages/
│   │           └── profile_screen.dart
│   │
│   └── settings/                       # 🔄 TO CREATE
│       ├── injection.dart
│       └── presentation/
│           └── pages/
│               └── settings_screen.dart
│
└── services/                           # External SDK wrappers (kept separate)
    ├── auth_service.dart               # Firebase Auth wrapper
    └── storage_service.dart            # SecureStorage wrapper
```

---

## 📊 Migration Map Table

| # | Current Path | New Path | Action | Notes |
|---|--------------|----------|--------|-------|
| **CORE LAYER** |
| 1 | `lib/app/theme.dart` | `lib/core/theme/app_theme.dart` | MOVE | Theme belongs in core |
| 2 | `lib/app/routes.dart` | `lib/core/routing/app_router.dart` | MOVE+RENAME | Routing is cross-cutting |
| 3 | `lib/utils/constants.dart` | `lib/core/constants/constants.dart` | MERGE | Already exists, merge content |
| 4 | `lib/utils/helpers.dart` | `lib/core/utils/helpers.dart` | MOVE | Move to core utils |
| 5 | `lib/widgets/app_button.dart` | `lib/core/widgets/app_button.dart` | MOVE | Shared widget |
| 6 | `lib/widgets/app_dialog.dart` | `lib/core/widgets/app_dialog.dart` | MOVE | Shared widget |
| 7 | `lib/widgets/app_loader.dart` | `lib/core/widgets/app_loader.dart` | MOVE | Shared widget |
| 8 | `lib/widgets/app_textfield.dart` | `lib/core/widgets/app_textfield.dart` | MOVE | Shared widget |
| **APP LAYER** |
| 9 | `lib/app/app.dart` | `lib/app.dart` | MOVE | Root app widget |
| 10 | `lib/main.dart` | `lib/main.dart` | KEEP | Already correct |
| **AUTH FEATURE** |
| 11 | `lib/screens/auth/login_screen.dart` | `lib/features/auth/presentation/pages/login_screen.dart` | MOVE | Already uses BLoC |
| 12 | `lib/screens/auth/register_screen.dart` | `lib/features/auth/presentation/pages/register_screen.dart` | MOVE+REFACTOR | ⚠️ Remove direct API calls |
| **ATTENDANCE FEATURE** |
| 13 | `lib/models/attendance.dart` | `lib/features/attendance/domain/entities/attendance.dart` | MOVE+SPLIT | Entity (pure) + Model (data layer) |
| 14 | `lib/screens/attendance/scan_screen.dart` | `lib/features/attendance/presentation/pages/scan_screen.dart` | MOVE | Placeholder |
| 15 | `lib/screens/attendance/confirm_screen.dart` | `lib/features/attendance/presentation/pages/confirm_screen.dart` | MOVE | Placeholder |
| 16 | `lib/screens/attendance/history_screen.dart` | `lib/features/attendance/presentation/pages/history_screen.dart` | MOVE | Placeholder |
| **PROFILE FEATURE** |
| 17 | `lib/models/student.dart` | `lib/features/profile/domain/entities/student.dart` | MOVE+SPLIT | Entity + Model |
| 18 | `lib/models/user.dart` | `lib/features/profile/domain/entities/user.dart` | MOVE+SPLIT | Entity + Model |
| 19 | `lib/models/user_name.dart` | `lib/features/profile/domain/entities/user_name.dart` | MOVE | Value object |
| 20 | `lib/screens/profile/profile_screen.dart` | `lib/features/profile/presentation/pages/profile_screen.dart` | MOVE | Placeholder |
| 21 | `lib/services/test_student_api.dart` | `lib/features/profile/data/datasources/student_remote_datasource.dart` | MOVE+REFACTOR | Wrap in datasource pattern |
| 22 | `lib/services/test_user_api.dart` | `lib/features/profile/data/datasources/user_remote_datasource.dart` | MOVE+REFACTOR | Wrap in datasource pattern |
| **SETTINGS FEATURE** |
| 23 | `lib/screens/settings/settings_screen.dart` | `lib/features/settings/presentation/pages/settings_screen.dart` | MOVE | Placeholder |
| **SERVICES (EXTERNAL WRAPPERS)** |
| 24 | `lib/services/auth_service.dart` | `lib/services/auth_service.dart` | KEEP | External wrapper, already used |
| 25 | `lib/services/storage_service.dart` | `lib/services/storage_service.dart` | KEEP | External wrapper |
| **DELETE** |
| 26 | `lib/screens/api_test.dart` | ❌ DELETE | DELETE | Test file with direct API calls |
| 27 | `lib/utils/` (folder) | ❌ DELETE | DELETE | After contents merged to core |
| 28 | `lib/widgets/` (folder) | ❌ DELETE | DELETE | After contents moved to core |
| 29 | `lib/models/` (folder) | ❌ DELETE | DELETE | After contents moved to features |
| 30 | `lib/screens/` (folder) | ❌ DELETE | DELETE | After contents moved to features |

---

## 🔒 Refactor Rules (ENFORCED)

### Rule 1: Layer Dependency Direction
```
Presentation → Domain → Data
     ↓            ↓        ↓
   BLoC      UseCases  Repository
     ↓            ↓        ↓
  Widgets    Entities  DataSource
                         ↓
                    External APIs
```
**NEVER** go backwards: Data must NOT import Domain, Domain must NOT import Presentation.

### Rule 2: Domain Layer = Pure Dart
```dart
// ✅ ALLOWED in domain/
import 'dart:async';
import 'package:equatable/equatable.dart';
import '../entities/user.dart';
import '../../core/utils/result.dart';

// ❌ FORBIDDEN in domain/
import 'package:firebase_auth/firebase_auth.dart';  // NO!
import 'package:flutter/material.dart';              // NO!
import 'package:http/http.dart';                     // NO!
import 'package:geolocator/geolocator.dart';         // NO!
```

### Rule 3: UI Never Imports External SDKs
```dart
// In presentation/pages/*.dart:
// ✅ ALLOWED
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../../../core/widgets/app_button.dart';

// ❌ FORBIDDEN
import 'package:firebase_auth/firebase_auth.dart';   // NO!
import 'package:http/http.dart';                     // NO!
import '../../../services/test_user_api.dart';       // NO! (direct API call)
```

### Rule 4: UseCase Returns Result<T>
```dart
// ✅ CORRECT
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

// ❌ WRONG - throwing exceptions
Future<User> call(Params params) async {
  throw Exception('error'); // NO!
}
```

### Rule 5: BLoC Depends ONLY on UseCases
```dart
// ✅ CORRECT
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInEmailPassword signInEmailPassword;
  final SignInWithGoogle signInWithGoogle;
  // Uses usecases, NOT repositories, NOT datasources
}

// ❌ WRONG
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;     // NO! Use usecase
  final AuthRemoteDataSource api;      // NO! Direct API access
}
```

### Rule 6: GetIt Registration Pattern
```dart
// ✅ CORRECT
sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(...));
sl.registerFactory(() => LoginBloc(...));  // BLoCs are FACTORY (new instance)

// ❌ WRONG
sl.registerSingleton<LoginBloc>(...);  // NO! BLoCs should be factories
```

### Rule 7: Exception → Failure Mapping in Repository
```dart
// In data/repositories/auth_repository_impl.dart:
@override
Future<Result<AuthUser>> signIn(String email, String password) async {
  try {
    final user = await remoteDataSource.signIn(email, password);
    return Result.success(user.toEntity());  // ✅ Map to entity
  } on AuthException catch (e) {
    return Result.fail(AuthFailure(e.message));  // ✅ Map to failure
  } on NetworkException {
    return Result.fail(const NetworkFailure('No internet'));
  } catch (e) {
    return Result.fail(UnknownFailure(e.toString()));
  }
}
```

### Rule 8: Model ↔ Entity Conversion
```dart
// data/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  
  factory UserModel.fromJson(Map<String, dynamic> json) => ...;
  Map<String, dynamic> toJson() => ...;
  
  // ✅ REQUIRED: Convert to domain entity
  User toEntity() => User(id: id, email: email);
  
  // ✅ REQUIRED: Create from domain entity
  factory UserModel.fromEntity(User entity) => ...;
}
```

### Rule 9: Feature Injection Pattern
```dart
// features/auth/injection.dart
void registerAuthDependencies(GetIt sl) {
  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(...);
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(...);
  
  // UseCases
  sl.registerLazySingleton(() => SignInEmailPassword(sl()));
  
  // BLoCs
  sl.registerFactory(() => LoginBloc(...));
}
```

### Rule 10: Folder Structure Per Feature
```
features/
  feature_name/
    ├── injection.dart           # Required: DI setup
    ├── data/
    │   ├── datasources/         # External API calls
    │   ├── models/              # JSON serialization
    │   └── repositories/        # Interface implementation
    ├── domain/
    │   ├── entities/            # Pure Dart objects
    │   ├── repositories/        # Abstract interfaces
    │   └── usecases/            # Business logic
    └── presentation/
        ├── bloc/                # State management
        └── pages/               # UI screens
```

---

## 🚀 Safe Step-by-Step Migration Plan

### Phase 0: Preparation (No Breaking Changes)
- [ ] **0.1** Create all target directories (empty)
- [ ] **0.2** Ensure project builds successfully before starting
- [ ] **0.3** Commit current state: `git commit -m "Pre-migration checkpoint"`

### Phase 1: Core Layer Migration (Low Risk)
- [ ] **1.1** Move `lib/app/theme.dart` → `lib/core/theme/app_theme.dart`
- [ ] **1.2** Move `lib/utils/helpers.dart` → `lib/core/utils/helpers.dart`
- [ ] **1.3** Merge `lib/utils/constants.dart` into `lib/core/constants/constants.dart`
- [ ] **1.4** Move all widgets from `lib/widgets/` → `lib/core/widgets/`
- [ ] **1.5** Create barrel export `lib/core/widgets/widgets.dart`
- [ ] **1.6** Move `lib/app/routes.dart` → `lib/core/routing/app_router.dart`
- [ ] **1.7** Update all imports across the project
- [ ] **1.8** Run `flutter analyze` and `flutter build` to verify
- [ ] **1.9** Commit: `git commit -m "Migrate core layer"`

### Phase 2: Auth Feature Completion (Medium Risk)
- [ ] **2.1** Move `lib/screens/auth/login_screen.dart` → `lib/features/auth/presentation/pages/`
- [ ] **2.2** Move `lib/screens/auth/register_screen.dart` → `lib/features/auth/presentation/pages/`
- [ ] **2.3** Create `RegisterBloc`, `RegisterEvent`, `RegisterState`
- [ ] **2.4** Create `SignUpEmailPassword` usecase
- [ ] **2.5** Refactor `register_screen.dart` to use BLoC (remove direct API calls)
- [ ] **2.6** Update auth injection.dart
- [ ] **2.7** Update route imports in `app_router.dart`
- [ ] **2.8** Run tests and verify
- [ ] **2.9** Commit: `git commit -m "Complete auth feature migration"`

### Phase 3: Profile Feature Creation (Medium Risk)
- [ ] **3.1** Create feature structure: `lib/features/profile/`
- [ ] **3.2** Split `lib/models/student.dart`:
  - Entity: `domain/entities/student.dart`
  - Model: `data/models/student_model.dart`
- [ ] **3.3** Split `lib/models/user.dart`:
  - Entity: `domain/entities/user.dart`
  - Model: `data/models/user_model.dart`
- [ ] **3.4** Move `lib/models/user_name.dart` → `domain/entities/user_name.dart`
- [ ] **3.5** Refactor `lib/services/test_student_api.dart`:
  - Create `data/datasources/student_remote_datasource.dart`
  - Wrap API calls, throw typed exceptions
- [ ] **3.6** Refactor `lib/services/test_user_api.dart`:
  - Create `data/datasources/user_remote_datasource.dart`
- [ ] **3.7** Create `ProfileRepository` interface
- [ ] **3.8** Create `ProfileRepositoryImpl`
- [ ] **3.9** Create `GetProfile`, `GetStudent` usecases
- [ ] **3.10** Create `ProfileBloc`
- [ ] **3.11** Move and refactor `profile_screen.dart`
- [ ] **3.12** Create `injection.dart`
- [ ] **3.13** Register in main `injection_container.dart`
- [ ] **3.14** Verify and commit

### Phase 4: Attendance Feature Creation (Medium Risk)
- [ ] **4.1** Create feature structure: `lib/features/attendance/`
- [ ] **4.2** Split `lib/models/attendance.dart`:
  - Entity: `domain/entities/attendance.dart`
  - Model: `data/models/attendance_model.dart`
- [ ] **4.3** Create `AttendanceRemoteDataSource`
- [ ] **4.4** Create `AttendanceRepository` interface
- [ ] **4.5** Create `AttendanceRepositoryImpl`
- [ ] **4.6** Create usecases: `SubmitAttendance`, `GetAttendanceHistory`
- [ ] **4.7** Create `ScanBloc`, `HistoryBloc`
- [ ] **4.8** Move screens to `presentation/pages/`
- [ ] **4.9** Create `injection.dart`
- [ ] **4.10** Register in main DI
- [ ] **4.11** Verify and commit

### Phase 5: Settings Feature (Low Risk)
- [ ] **5.1** Create minimal structure: `lib/features/settings/`
- [ ] **5.2** Move `settings_screen.dart` → `presentation/pages/`
- [ ] **5.3** Create `injection.dart` (empty for now)
- [ ] **5.4** Verify and commit

### Phase 6: Cleanup (Low Risk)
- [ ] **6.1** Delete `lib/screens/api_test.dart`
- [ ] **6.2** Delete empty `lib/screens/` folder
- [ ] **6.3** Delete empty `lib/models/` folder
- [ ] **6.4** Delete empty `lib/utils/` folder
- [ ] **6.5** Delete empty `lib/widgets/` folder
- [ ] **6.6** Delete `lib/services/test_student_api.dart` (after refactored)
- [ ] **6.7** Delete `lib/services/test_user_api.dart` (after refactored)
- [ ] **6.8** Move `lib/app/app.dart` → `lib/app.dart`
- [ ] **6.9** Delete empty `lib/app/` folder
- [ ] **6.10** Final `flutter analyze` and `flutter build`
- [ ] **6.11** Commit: `git commit -m "Clean Architecture migration complete"`

### Phase 7: Documentation & Polish
- [ ] **7.1** Update README.md with new architecture
- [ ] **7.2** Add architecture diagram
- [ ] **7.3** Document feature creation template
- [ ] **7.4** Final commit and tag: `git tag v1.0.0-clean-arch`

---

## ⚠️ Violation Fixes Required

### Violation 1: `register_screen.dart` - Direct API Call
```dart
// CURRENT (WRONG):
final api = TestStudentApi();
final result = await api.getStudentById('...');

// AFTER (CORRECT):
// In register_bloc.dart:
final result = await registerUseCase(RegisterParams(...));
```

### Violation 2: `api_test.dart` - Direct API Call
```dart
// CURRENT (WRONG):
final userApi = TestUserApi();
final result = await userApi.fetchUser('...');

// FIX: Delete this test file entirely
```

---

## 📁 Files to Create (New)

| File | Purpose |
|------|---------|
| `lib/core/routing/app_router.dart` | Route definitions |
| `lib/core/theme/app_theme.dart` | Theme configuration |
| `lib/core/widgets/widgets.dart` | Barrel export |
| `lib/features/auth/presentation/bloc/register_bloc.dart` | Registration state |
| `lib/features/auth/presentation/bloc/register_event.dart` | Registration events |
| `lib/features/auth/presentation/bloc/register_state.dart` | Registration states |
| `lib/features/auth/domain/usecases/sign_up_email_password.dart` | Sign up logic |
| `lib/features/profile/injection.dart` | Profile DI |
| `lib/features/profile/domain/entities/student.dart` | Student entity |
| `lib/features/profile/domain/entities/user.dart` | User entity |
| `lib/features/profile/data/models/student_model.dart` | Student JSON mapping |
| `lib/features/profile/data/models/user_model.dart` | User JSON mapping |
| `lib/features/profile/data/datasources/student_remote_datasource.dart` | Student API |
| `lib/features/profile/data/datasources/user_remote_datasource.dart` | User API |
| `lib/features/profile/domain/repositories/profile_repository.dart` | Abstract interface |
| `lib/features/profile/data/repositories/profile_repository_impl.dart` | Implementation |
| `lib/features/profile/domain/usecases/get_profile.dart` | Get profile usecase |
| `lib/features/profile/presentation/bloc/profile_bloc.dart` | Profile state |
| `lib/features/attendance/injection.dart` | Attendance DI |
| `lib/features/attendance/domain/entities/attendance.dart` | Attendance entity |
| `lib/features/attendance/data/models/attendance_model.dart` | Attendance JSON |
| `lib/features/attendance/data/datasources/attendance_remote_datasource.dart` | API calls |
| `lib/features/attendance/domain/repositories/attendance_repository.dart` | Interface |
| `lib/features/attendance/data/repositories/attendance_repository_impl.dart` | Implementation |
| `lib/features/attendance/domain/usecases/submit_attendance.dart` | Submit usecase |
| `lib/features/attendance/domain/usecases/get_attendance_history.dart` | History usecase |
| `lib/features/attendance/presentation/bloc/scan_bloc.dart` | Scan state |
| `lib/features/attendance/presentation/bloc/history_bloc.dart` | History state |
| `lib/features/settings/injection.dart` | Settings DI |

---

## 🎯 Success Criteria

- [ ] All screens are in `lib/features/*/presentation/pages/`
- [ ] All models split into Entity (domain) + Model (data)
- [ ] No UI file imports Firebase/http/external SDKs directly
- [ ] All features have `injection.dart` registered in main DI
- [ ] `flutter analyze` shows 0 issues
- [ ] `flutter build apk` succeeds
- [ ] All BLoCs use UseCases only
- [ ] Domain layer has no Flutter/external imports

---

*Generated: Migration Plan for Attendly Clean Architecture*
*Reference: docs/CLEAN_ARCHITECTURE_MIGRATION.md for implementation details*
