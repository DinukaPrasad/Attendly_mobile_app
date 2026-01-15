import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/student.dart';
import '../repositories/profile_repository.dart';

/// Parameters for the GetStudentById use case
class GetStudentByIdParams {
  final String id;

  const GetStudentByIdParams({required this.id});
}

/// Use case for fetching a student by ID.
class GetStudentById implements UseCase<Student, GetStudentByIdParams> {
  final ProfileRepository _repository;

  GetStudentById(this._repository);

  @override
  Future<Result<Student>> call(GetStudentByIdParams params) {
    if (params.id.isEmpty) {
      return Future.value(
        Result.failure(
          const ValidationFailure(message: 'Student ID is required'),
        ),
      );
    }
    return _repository.getStudentById(params.id);
  }
}
