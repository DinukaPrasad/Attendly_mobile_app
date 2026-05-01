import '../entities/session.dart';

abstract class SessionRepository {
  Future<List<Session>> getAllSessions();

  Future<Session> createSession(Map<String, dynamic> sessionData);
}
