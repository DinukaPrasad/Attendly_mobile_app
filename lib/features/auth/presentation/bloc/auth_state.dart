import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState({this.isLoading = false});

  final bool isLoading;

  AuthState copyWith({bool? isLoading}) {
    return AuthState(isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [isLoading];
}
