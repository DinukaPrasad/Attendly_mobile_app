import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/attendance_session.dart';
import '../repositories/attendance_repository.dart';

/// Parameters for ValidateQrCode use case
class ValidateQrCodeParams {
  final String qrCode;

  const ValidateQrCodeParams({required this.qrCode});
}

/// Use case for validating a QR code and getting the associated session.
class ValidateQrCode
    implements UseCase<AttendanceSession, ValidateQrCodeParams> {
  final AttendanceRepository _repository;

  ValidateQrCode(this._repository);

  @override
  Future<Result<AttendanceSession>> call(ValidateQrCodeParams params) {
    if (params.qrCode.isEmpty) {
      return Future.value(
        Result.failure(const ValidationFailure(message: 'QR code is required')),
      );
    }

    return _repository.validateQrCode(params.qrCode);
  }
}
