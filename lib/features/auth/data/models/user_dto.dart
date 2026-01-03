import '../../domain/entities/user.dart';

class UserDto {
  const UserDto({required this.id, required this.email});

  final String id;
  final String email;

  User toEntity() => User(id: id, email: email);
}
