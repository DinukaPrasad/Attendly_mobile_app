import 'package:attendly/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthUser', () {
    const tUser = AuthUser(
      id: 'user123',
      email: 'test@example.com',
      displayName: 'John Doe',
      photoUrl: 'https://example.com/photo.jpg',
      isEmailVerified: true,
      phoneNumber: '+1234567890',
    );

    test('should create with required and optional fields', () {
      expect(tUser.id, 'user123');
      expect(tUser.email, 'test@example.com');
      expect(tUser.displayName, 'John Doe');
      expect(tUser.photoUrl, 'https://example.com/photo.jpg');
      expect(tUser.isEmailVerified, isTrue);
      expect(tUser.phoneNumber, '+1234567890');
    });

    test('should have default values for optional fields', () {
      const user = AuthUser(id: 'user456');

      expect(user.email, isNull);
      expect(user.displayName, isNull);
      expect(user.photoUrl, isNull);
      expect(user.isEmailVerified, isFalse);
      expect(user.phoneNumber, isNull);
    });

    group('hasDisplayName', () {
      test('should return true when displayName is set', () {
        expect(tUser.hasDisplayName, isTrue);
      });

      test('should return false when displayName is null', () {
        const user = AuthUser(id: 'user');
        expect(user.hasDisplayName, isFalse);
      });

      test('should return false when displayName is empty', () {
        const user = AuthUser(id: 'user', displayName: '');
        expect(user.hasDisplayName, isFalse);
      });
    });

    group('hasPhoto', () {
      test('should return true when photoUrl is set', () {
        expect(tUser.hasPhoto, isTrue);
      });

      test('should return false when photoUrl is null', () {
        const user = AuthUser(id: 'user');
        expect(user.hasPhoto, isFalse);
      });

      test('should return false when photoUrl is empty', () {
        const user = AuthUser(id: 'user', photoUrl: '');
        expect(user.hasPhoto, isFalse);
      });
    });

    group('initials', () {
      test('should return initials from two-word display name', () {
        expect(tUser.initials, 'JD');
      });

      test('should return single initial from one-word display name', () {
        const user = AuthUser(id: 'user', displayName: 'Alice');
        expect(user.initials, 'A');
      });

      test('should return initials from multi-word display name', () {
        const user = AuthUser(id: 'user', displayName: 'John Michael Doe');
        expect(user.initials, 'JD');
      });

      test('should return email initial when no display name', () {
        const user = AuthUser(id: 'user', email: 'test@example.com');
        expect(user.initials, 'T');
      });

      test('should return ? when no name or email', () {
        const user = AuthUser(id: 'user');
        expect(user.initials, '?');
      });

      test('should uppercase initials', () {
        const user = AuthUser(id: 'user', displayName: 'alice bob');
        expect(user.initials, 'AB');
      });
    });

    group('Equality', () {
      test('should be equal when all properties match', () {
        const user1 = AuthUser(id: 'user123', email: 'test@example.com');
        const user2 = AuthUser(id: 'user123', email: 'test@example.com');

        expect(user1, equals(user2));
      });

      test('should not be equal when id differs', () {
        const user1 = AuthUser(id: 'user123');
        const user2 = AuthUser(id: 'user456');

        expect(user1, isNot(equals(user2)));
      });
    });
  });
}
