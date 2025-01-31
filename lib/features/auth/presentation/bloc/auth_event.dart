part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String name;
  final String password;

  AuthSignUp({
    required this.email,
    required this.name,
    required this.password,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthLoggedIn extends AuthEvent {}

final class AuthLogout extends AuthEvent {}

final class AuthEditUser extends AuthEvent {
  final String userId;
  final String? name;
  final String? email;
  final String? password;

  AuthEditUser({
    required this.userId,
    this.name,
    this.email,
    this.password,
  });
}

final class AuthDeleteUser extends AuthEvent {
  final String userId;

  AuthDeleteUser({required this.userId});
}
