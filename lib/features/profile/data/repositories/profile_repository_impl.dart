import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/student.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/student_remote_datasource.dart';
import '../datasources/user_remote_datasource.dart';

/// Implementation of [ProfileRepository].
///
/// This connects the domain layer to the data layer by implementing
/// the abstract repository interface and delegating to the data sources.
///
/// All exceptions from data sources are caught and mapped to [Failure]s.
class ProfileRepositoryImpl implements ProfileRepository {
  final StudentRemoteDataSource _studentDataSource;
  final UserRemoteDataSource _userDataSource;

  ProfileRepositoryImpl({
    required StudentRemoteDataSource studentDataSource,
    required UserRemoteDataSource userDataSource,
  }) : _studentDataSource = studentDataSource,
       _userDataSource = userDataSource;

  @override
  Future<Result<List<Student>>> getAllStudents() async {
    try {
      final studentModels = await _studentDataSource.fetchAllStudents();
      final students = studentModels.map((m) => m.toEntity()).toList();
      return Result.success(students);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<Student>> getStudentById(String id) async {
    try {
      final studentModel = await _studentDataSource.fetchStudentById(id);
      return Result.success(studentModel.toEntity());
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<List<User>>> getUsers({int count = 30}) async {
    try {
      final userModels = await _userDataSource.fetchUsers(count: count);
      final users = userModels.map((m) => m.toEntity()).toList();
      return Result.success(users);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<User>> getRandomUser() async {
    try {
      final userModel = await _userDataSource.fetchRandomUser();
      return Result.success(userModel.toEntity());
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }
}
