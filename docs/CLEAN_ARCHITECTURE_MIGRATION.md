# Attendly Clean Architecture Migration Guide

## Target Folder Structure (Feature-First)

```
lib/
├── core/                              # Shared infrastructure
│   ├── constants/
│   │   └── constants.dart             # API, storage, validation constants
│   ├── di/
│   │   └── injection_container.dart   # GetIt setup
│   ├── errors/
│   │   ├── exceptions.dart            # Data layer exceptions
│   │   └── failures.dart              # Domain layer failures
│   ├── network/
│   │   └── api_client.dart            # HTTP client with JWT
│   ├── usecases/
│   │   └── usecase.dart               # Base UseCase classes
│   ├── utils/
│   │   └── result.dart                # Result<T> type (Either alternative)
│   └── core.dart                      # Barrel export
│
├── features/                          # Feature modules
│   ├── auth/
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
│   │   │   │   └── auth_repository.dart     # Abstract interface
│   │   │   └── usecases/
│   │   │       ├── sign_in_email_password.dart
│   │   │       └── sign_in_with_google.dart
│   │   ├── presentation/
│   │   │   └── bloc/
│   │   │       ├── login_bloc.dart
│   │   │       ├── login_event.dart
│   │   │       └── login_state.dart
│   │   └── injection.dart             # Feature DI registration
│   │
│   ├── attendance/                    # TODO: Migrate
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── location/                      # TODO: Migrate
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/                       # TODO: Migrate
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── screens/                           # Existing screens (migrate to features/*/presentation/pages/)
│   ├── auth/
│   │   ├── login_screen.dart          # ✅ Migrated to use BLoC
│   │   └── register_screen.dart       # TODO
│   ├── attendance/
│   └── profile/
│
├── services/                          # Legacy services (wrap in data sources)
│   └── auth_service.dart              # ✅ Wrapped by AuthRemoteDataSource
│
└── main.dart                          # App entry point with DI init
```

---

## Migration Plan Checklist

### Phase 1: Core Layer Setup ✅
- [x] Create `core/errors/failures.dart` - Base failure classes
- [x] Create `core/errors/exceptions.dart` - Data layer exceptions
- [x] Create `core/utils/result.dart` - Result type for error handling
- [x] Create `core/usecases/usecase.dart` - Base use case classes
- [x] Create `core/di/injection_container.dart` - GetIt setup
- [x] Create `core/network/api_client.dart` - HTTP client
- [x] Create `core/constants/constants.dart` - App constants
- [x] Add dependencies: `get_it`, `flutter_secure_storage`

### Phase 2: Auth Feature Migration ✅
- [x] Create `features/auth/domain/entities/auth_user.dart`
- [x] Create `features/auth/domain/repositories/auth_repository.dart`
- [x] Create `features/auth/domain/usecases/sign_in_email_password.dart`
- [x] Create `features/auth/domain/usecases/sign_in_with_google.dart`
- [x] Create `features/auth/data/models/auth_user_model.dart`
- [x] Create `features/auth/data/datasources/auth_remote_datasource.dart`
- [x] Create `features/auth/data/repositories/auth_repository_impl.dart`
- [x] Update `features/auth/presentation/bloc/login_bloc.dart`
- [x] Create `features/auth/injection.dart`
- [x] Update `screens/auth/login_screen.dart` to use BLoC
- [x] Update `main.dart` to initialize DI

### Phase 3: Attendance Feature Migration (TODO)
- [ ] Create domain entities (AttendanceRecord, QrCode, etc.)
- [ ] Create domain repository interface
- [ ] Create use cases (ScanQrCode, SubmitAttendance, GetHistory)
- [ ] Create data models and data sources
- [ ] Create repository implementation
- [ ] Create BLoC (ScanBloc, HistoryBloc)
- [ ] Update screens to use BLoC
- [ ] Register in DI

### Phase 4: Location Feature Migration (TODO)
- [ ] Create domain entities (Location, WifiInfo, etc.)
- [ ] Create domain repository interface
- [ ] Create use cases (GetCurrentLocation, VerifyLocation)
- [ ] Create data sources (GPS, WiFi, Bluetooth)
- [ ] Create repository implementation
- [ ] Create BLoC
- [ ] Register in DI

### Phase 5: Profile Feature Migration (TODO)
- [ ] Create domain entities
- [ ] Create domain repository
- [ ] Create use cases
- [ ] Create data layer
- [ ] Create BLoC
- [ ] Update screens
- [ ] Register in DI

### Phase 6: Testing
- [ ] Unit tests for use cases
- [ ] Unit tests for repositories
- [ ] BLoC tests
- [ ] Widget tests
- [ ] Integration tests

---

## Search & Replace Refactoring Rules

### Rule 1: Move Service Calls Out of Widgets
```
BEFORE (in widget):
  final _authService = AuthService();
  await _authService.signInWithEmailPassword(...);

AFTER (in widget):
  context.read<LoginBloc>().add(LoginEmailPressed(...));
```

### Rule 2: Widgets Only Dispatch Events
```
BEFORE:
  onPressed: () async {
    setState(() => _isLoading = true);
    try {
      await someService.doSomething();
      Navigator.push(...);
    } catch (e) {
      showError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

AFTER:
  onPressed: () {
    context.read<SomeBloc>().add(SomeEvent());
  }
  // Navigation/errors handled in BlocListener
```

### Rule 3: Use Cases Must Be Single Responsibility
```
GOOD:
  - SignInWithEmailPassword
  - SignInWithGoogle
  - SignOut
  - GetCurrentUser

BAD:
  - AuthUseCase (does everything)
```

### Rule 4: No BuildContext in BLoC
```
BEFORE (in BLoC):
  Navigator.of(context).push(...);  // ❌ WRONG

AFTER:
  emit(SomeState.navigateTo(route));  // ✅ State carries intent
  // Navigation happens in BlocListener in UI
```

### Rule 5: Domain Layer = Pure Dart
```
ALLOWED in domain/:
  - import 'dart:async';
  - import 'package:equatable/equatable.dart';
  - import '../core/...';

FORBIDDEN in domain/:
  - import 'package:flutter/...';  // ❌
  - import 'package:firebase_auth/...';  // ❌
```

### Rule 6: Data Layer Handles External Packages
```
// All Firebase, HTTP, Geolocator, etc. imports stay in data/
import 'package:firebase_auth/firebase_auth.dart';  // ✅ OK in data/
import 'package:geolocator/geolocator.dart';         // ✅ OK in data/
```

### Rule 7: Exceptions → Failures Mapping
```
// In repository implementation:
try {
  final result = await dataSource.doSomething();
  return Result.success(result);
} on SomeException catch (e) {
  return Result.failure(mapException(e));
}
```

### Rule 8: BLoC State Patterns
```dart
// Standard state structure:
sealed class SomeState extends Equatable {
  const SomeState();
}

class SomeInitial extends SomeState { ... }
class SomeLoading extends SomeState { ... }
class SomeSuccess extends SomeState { final Data data; ... }
class SomeFailure extends SomeState { final String message; ... }

// Or use single class with status enum:
class SomeState extends Equatable {
  final SomeStatus status;  // initial, loading, success, failure
  final Data? data;
  final String? errorMessage;
}
```

### Rule 9: Event Naming
```
PATTERN: [Feature][Action][Trigger]
EXAMPLES:
  - LoginEmailPressed
  - LoginGooglePressed
  - AttendanceScanCompleted
  - ProfileUpdateRequested
  - LocationRefreshTriggered
```

### Rule 10: DI Registration Order
```dart
// Register in dependency order:
void registerFeatureDependencies(GetIt sl) {
  // 1. External services (singletons)
  sl.registerLazySingleton<SomeService>(() => SomeService());
  
  // 2. Data sources (singletons)
  sl.registerLazySingleton<SomeDataSource>(
    () => SomeDataSourceImpl(sl<SomeService>()),
  );
  
  // 3. Repositories (singletons)
  sl.registerLazySingleton<SomeRepository>(
    () => SomeRepositoryImpl(sl<SomeDataSource>()),
  );
  
  // 4. Use cases (singletons)
  sl.registerLazySingleton<SomeUseCase>(
    () => SomeUseCase(sl<SomeRepository>()),
  );
  
  // 5. BLoCs (FACTORY - new instance per screen)
  sl.registerFactory<SomeBloc>(
    () => SomeBloc(sl<SomeUseCase>()),
  );
}
```

---

## Quick Reference: Creating a New Feature

```bash
# 1. Create folder structure
lib/features/[feature]/
  ├── data/
  │   ├── datasources/
  │   ├── models/
  │   └── repositories/
  ├── domain/
  │   ├── entities/
  │   ├── repositories/
  │   └── usecases/
  ├── presentation/
  │   ├── bloc/
  │   ├── pages/
  │   └── widgets/
  └── injection.dart
```

```dart
// 2. Start with domain layer (pure Dart)
// domain/entities/my_entity.dart
class MyEntity extends Equatable { ... }

// domain/repositories/my_repository.dart
abstract class MyRepository {
  Future<Result<MyEntity>> getSomething();
}

// domain/usecases/get_something.dart
class GetSomething implements UseCaseNoParams<MyEntity> {
  final MyRepository repository;
  GetSomething(this.repository);
  
  @override
  Future<Result<MyEntity>> call() => repository.getSomething();
}

// 3. Implement data layer
// data/models/my_model.dart
class MyModel extends MyEntity {
  factory MyModel.fromJson(Map<String, dynamic> json) { ... }
}

// data/repositories/my_repository_impl.dart
class MyRepositoryImpl implements MyRepository {
  final MyDataSource dataSource;
  
  @override
  Future<Result<MyEntity>> getSomething() async {
    try {
      final model = await dataSource.fetchSomething();
      return Result.success(model);
    } on SomeException catch (e) {
      return Result.failure(SomeFailure(message: e.message));
    }
  }
}

// 4. Create BLoC
// presentation/bloc/my_bloc.dart
class MyBloc extends Bloc<MyEvent, MyState> {
  final GetSomething getSomething;
  
  MyBloc(this.getSomething) : super(MyInitial()) {
    on<MyLoadRequested>(_onLoad);
  }
  
  Future<void> _onLoad(MyLoadRequested event, Emitter<MyState> emit) async {
    emit(MyLoading());
    final result = await getSomething();
    result.fold(
      onFailure: (f) => emit(MyFailure(f.message)),
      onSuccess: (data) => emit(MySuccess(data)),
    );
  }
}

// 5. Register DI
// injection.dart
void registerMyFeature(GetIt sl) {
  sl.registerLazySingleton<MyDataSource>(...);
  sl.registerLazySingleton<MyRepository>(...);
  sl.registerLazySingleton<GetSomething>(...);
  sl.registerFactory<MyBloc>(...);
}

// 6. Update UI to use BLoC
BlocProvider(
  create: (_) => sl<MyBloc>()..add(MyLoadRequested()),
  child: BlocBuilder<MyBloc, MyState>(
    builder: (context, state) {
      return switch (state) {
        MyInitial() => const SizedBox(),
        MyLoading() => const CircularProgressIndicator(),
        MySuccess(:final data) => MyContent(data: data),
        MyFailure(:final message) => ErrorWidget(message),
      };
    },
  ),
)
```

---

## Dependencies Added

```yaml
dependencies:
  flutter_bloc: ^9.1.0      # State management
  equatable: ^2.0.7         # Value equality
  get_it: ^8.0.3            # Dependency injection
  flutter_secure_storage: ^9.2.4  # Secure token storage
```
