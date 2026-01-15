import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/attendance_remote_datasource.dart';
import 'data/repositories/attendance_repository_impl.dart';
import 'domain/repositories/attendance_repository.dart';
import 'domain/usecases/usecases.dart';
import 'presentation/bloc/bloc.dart';

/// Registers all attendance feature dependencies.
void registerAttendanceDependencies(GetIt sl) {
  // BLoCs
  sl.registerFactory(
    () => ScanBloc(
      validateQrCode: sl(),
      submitAttendance: sl(),
      getActiveSessions: sl(),
    ),
  );

  sl.registerFactory(() => HistoryBloc(getAttendanceHistory: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetAttendanceHistory(sl()));
  sl.registerLazySingleton(() => SubmitAttendance(sl()));
  sl.registerLazySingleton(() => ValidateQrCode(sl()));
  sl.registerLazySingleton(() => GetActiveSessions(sl()));

  // Repository
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(
      client: sl<http.Client>(),
      baseUrl: sl<String>(instanceName: 'baseUrl'),
    ),
  );
}
