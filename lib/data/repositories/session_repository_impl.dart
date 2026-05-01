import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_datasource.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;

  const SessionRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Session>> getAllSessions() {
    return remoteDataSource.getAllSessions();
  }

  @override
  Future<Session> createSession(Map<String, dynamic> sessionData) {
    return remoteDataSource.createSession(sessionData);
  }
}
