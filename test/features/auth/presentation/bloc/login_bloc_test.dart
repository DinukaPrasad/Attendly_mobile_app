import 'package:attendly/core/errors/failures.dart';
import 'package:attendly/core/utils/result.dart';
import 'package:attendly/features/auth/domain/entities/auth_user.dart';
import 'package:attendly/features/auth/domain/usecases/sign_in_email_password.dart';
import 'package:attendly/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:attendly/features/auth/presentation/bloc/login_bloc.dart';
import 'package:attendly/features/auth/presentation/bloc/login_event.dart';
import 'package:attendly/features/auth/presentation/bloc/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInEmailPassword extends Mock implements SignInEmailPassword {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

void main() {
  late MockSignInEmailPassword mockSignInEmailPassword;
  late MockSignInWithGoogle mockSignInWithGoogle;

  setUp(() {
    mockSignInEmailPassword = MockSignInEmailPassword();
    mockSignInWithGoogle = MockSignInWithGoogle();
  });

  setUpAll(() {
    registerFallbackValue(
      const SignInEmailPasswordParams(email: '', password: ''),
    );
  });

  LoginBloc buildBloc() => LoginBloc(
    signInEmailPassword: mockSignInEmailPassword,
    signInWithGoogle: mockSignInWithGoogle,
  );

  const tUser = AuthUser(
    id: 'user123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  group('LoginBloc', () {
    test('initial state should be LoginState.initial', () {
      final bloc = buildBloc();
      expect(bloc.state, const LoginState.initial());
    });

    group('LoginEmailPressed', () {
      blocTest<LoginBloc, LoginState>(
        'emits [loading, success] when sign in succeeds',
        build: () {
          when(
            () => mockSignInEmailPassword(any()),
          ).thenAnswer((_) async => const Result.success(tUser));
          return buildBloc();
        },
        act: (bloc) => bloc.add(
          const LoginEmailPressed(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [const LoginState.loading(), const LoginState.success()],
        verify: (_) {
          verify(
            () => mockSignInEmailPassword(
              const SignInEmailPasswordParams(
                email: 'test@example.com',
                password: 'password123',
              ),
            ),
          ).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, failure] when sign in fails',
        build: () {
          when(() => mockSignInEmailPassword(any())).thenAnswer(
            (_) async => const Result.failure(
              AuthFailure(message: 'Invalid credentials'),
            ),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(
          const LoginEmailPressed(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
        ),
        expect: () => [
          const LoginState.loading(),
          const LoginState.failure('Invalid credentials'),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'does not emit when already loading',
        build: () => buildBloc(),
        seed: () => const LoginState.loading(),
        act: (bloc) => bloc.add(
          const LoginEmailPressed(email: 'test@example.com', password: '123'),
        ),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockSignInEmailPassword(any()));
        },
      );
    });

    group('LoginGooglePressed', () {
      blocTest<LoginBloc, LoginState>(
        'emits [loading, success] when Google sign in succeeds',
        build: () {
          when(
            () => mockSignInWithGoogle(),
          ).thenAnswer((_) async => const Result.success(tUser));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoginGooglePressed()),
        expect: () => [const LoginState.loading(), const LoginState.success()],
        verify: (_) {
          verify(() => mockSignInWithGoogle()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, initial] when Google sign in is cancelled',
        build: () {
          when(() => mockSignInWithGoogle()).thenAnswer(
            (_) async => const Result.failure(
              AuthFailure(message: 'Cancelled', code: 'cancelled'),
            ),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoginGooglePressed()),
        expect: () => [const LoginState.loading(), const LoginState.initial()],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, failure] when Google sign in fails',
        build: () {
          when(() => mockSignInWithGoogle()).thenAnswer(
            (_) async => const Result.failure(
              AuthFailure(message: 'Network error', code: 'network-error'),
            ),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoginGooglePressed()),
        expect: () => [
          const LoginState.loading(),
          const LoginState.failure('Network error'),
        ],
      );
    });

    group('LoginPhonePressed', () {
      blocTest<LoginBloc, LoginState>(
        'emits [navigateToPhone, initial] when phone login pressed',
        build: buildBloc,
        act: (bloc) => bloc.add(const LoginPhonePressed()),
        expect: () => [
          const LoginState.navigateToPhone(),
          const LoginState.initial(),
        ],
      );
    });

    group('LoginClearError', () {
      blocTest<LoginBloc, LoginState>(
        'emits [initial] when clearing error',
        build: buildBloc,
        seed: () => const LoginState.failure('Some error'),
        act: (bloc) => bloc.add(const LoginClearError()),
        expect: () => [const LoginState.initial()],
      );
    });
  });
}
