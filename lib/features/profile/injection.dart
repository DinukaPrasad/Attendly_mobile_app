import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/student_remote_datasource.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/usecases/get_all_students.dart';
import 'domain/usecases/get_random_user.dart';
import 'domain/usecases/get_student_by_id.dart';
import 'domain/usecases/get_users.dart';
import 'presentation/bloc/profile_bloc.dart';

/// Registers all profile feature dependencies with GetIt.
///
/// Call this during app initialization.
void registerProfileDependencies(GetIt sl) {
  // HTTP Client (if not already registered)
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(() => http.Client());
  }

  // Data Sources
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      studentDataSource: sl<StudentRemoteDataSource>(),
      userDataSource: sl<UserRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetAllStudents>(
    () => GetAllStudents(sl<ProfileRepository>()),
  );

  sl.registerLazySingleton<GetStudentById>(
    () => GetStudentById(sl<ProfileRepository>()),
  );

  sl.registerLazySingleton<GetUsers>(() => GetUsers(sl<ProfileRepository>()));

  sl.registerLazySingleton<GetRandomUser>(
    () => GetRandomUser(sl<ProfileRepository>()),
  );

  // BLoCs - use factory for fresh instances
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getAllStudents: sl<GetAllStudents>(),
      getUsers: sl<GetUsers>(),
    ),
  );
}

/// Convenience class for accessing profile dependencies.
class ProfileDI {
  static GetIt get _sl => GetIt.instance;

  /// Creates a new ProfileBloc instance
  static ProfileBloc get profileBloc => _sl<ProfileBloc>();

  /// Gets the profile repository
  static ProfileRepository get profileRepository => _sl<ProfileRepository>();
}
