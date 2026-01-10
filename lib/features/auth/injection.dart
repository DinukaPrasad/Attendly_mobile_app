import 'package:get_it/get_it.dart';

import '../../services/auth_service.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/sign_in_email_password.dart';
import 'domain/usecases/sign_in_with_google.dart';
import 'presentation/bloc/login_bloc.dart';

/// Registers all auth feature dependencies with GetIt.
///
/// Call this during app initialization in the correct order:
/// 1. External services (AuthService)
/// 2. Data sources
/// 3. Repositories
/// 4. Use cases
/// 5. BLoCs (as factories, not singletons)
void registerAuthDependencies(GetIt sl) {
  // External services
  if (!sl.isRegistered<AuthService>()) {
    sl.registerLazySingleton<AuthService>(() => AuthService());
  }

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<AuthService>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<SignInEmailPassword>(
    () => SignInEmailPassword(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<SignInWithGoogle>(
    () => SignInWithGoogle(sl<AuthRepository>()),
  );

  // BLoCs - use factory so each screen gets a fresh instance
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(
      signInEmailPassword: sl<SignInEmailPassword>(),
      signInWithGoogle: sl<SignInWithGoogle>(),
    ),
  );
}

/// Convenience class for accessing auth dependencies.
///
/// This provides a cleaner API for screens that need to create BLoCs.
class AuthDI {
  static GetIt get _sl => GetIt.instance;

  /// Creates a new LoginBloc instance
  static LoginBloc get loginBloc => _sl<LoginBloc>();

  /// Gets the auth repository (for checking auth state)
  static AuthRepository get authRepository => _sl<AuthRepository>();

  /// Gets the auth service (for legacy code migration)
  static AuthService get authService => _sl<AuthService>();
}
